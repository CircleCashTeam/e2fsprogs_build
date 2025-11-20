#!/bin/bash
LOCALDIR=$(pwd)

cc="clang"
cxx="clang++"

function check_gcc() {
    if [[ $cc == "clang" || $cxx == "clang++" ]]; then
        return
    fi

    if uname -o | grep -qo "Msys"; then
        if [[ $MSYSTEM == "CLANG64" ]]; then
           return
        fi
    fi

    if ! command -v gcc; then
        echo "not install gcc"
        exit 1
    fi

    local current_gcc_version=$(gcc --version | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]' | head -n1)
    local major_version=$(echo "$current_gcc_version" | cut -d"." -f1)
    if (($major_version < 18 )); then
        echo "build use gcc version min is 18.x.x! current version is $current_gcc_version"
        exit 1
    fi
}

function check_msys_clang64_environment() {
    if uname -o | grep -qo "Msys"; then
        if [[ $cc == "clang" && $cxx == "clang++" && $MSYSTEM != "CLANG64" ]]; then
            echo "need to use Msys2 clang64 environment"
            exit 1
        fi
    fi
}

function install_deps() {
    if grep -qo "debian" /etc/os-release; then
        sudo apt install -y cmake gcc clang build-essential binutils nasm llvm lld libc++-dev libc++abi-dev ninja-build git wget
    fi

    if uname -o | grep -qo "Msys"; then
        pacman -Sy --noconfirm
        pacman -S --needed --noconfirm pactoys git unzip wget
        if [[ $MSYSTEM == "CLANG64" ]]; then
            pacboy -S --needed --noconfirm {clang,llvm,llvm-libs,libc++,lld,nasm,cmake,ninja}:p
        else
            pacboy -S --needed --noconfirm {gcc,llvm,llvm-libs,lld,nasm,cmake,ninja}:p
        fi
    fi
}


function set_toolchains() {
    local windows_versioin="20251104"
    local platform_version="msvcrt"
    local mingw_ubuntu_version="22.04"
    local ndk_version="r29.3"

    if grep -qo "debian" /etc/os-release; then
        if [[ ! -e "ondk-$ndk_version-linux.tar.xz" ]]; then
            wget https://github.com/topjohnwu/ondk/releases/download/$ndk_version/ondk-$ndk_version-linux.tar.xz
        fi
        if [[ ! -e "ndk" ]]; then
            tar -xf "ondk-$ndk_version-linux.tar.xz" -C "."
            mv "ondk-$ndk_version" "ndk"
        fi
        export PATH="$LOCALDIR/ndk/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH"
    fi

    if uname -o | grep -qo "Msys"; then
        if [[ ! -e "llvm-mingw-$windows_versioin-$platform_version-x86_64.zip" ]]; then
            wget https://github.com/mstorsjo/llvm-mingw/releases/download/$windows_versioin/llvm-mingw-$windows_versioin-$platform_version-x86_64.zip
        fi
        if [[ ! -e "llvm-mingw-$platform_version-x86_64_windows" ]]; then
            unzip -q -o "llvm-mingw-$windows_versioin-$platform_version-x86_64.zip" -d "."
            mv "llvm-mingw-$windows_versioin-$platform_version-x86_64" "llvm-mingw-msvcrt-x86_64_windows"
        fi
        export PATH="$LOCALDIR/llvm-mingw-$platform_version-x86_64_windows/bin:$PATH"
    fi
}

function build() {
    local cmake_gen_args=
    local targets=

    if [[ $1 == "android" ]]; then
        cc="aarch64-linux-android$2-$cc"
        cxx="aarch64-linux-android$2-$cxx"
        cmake_gen_args="-DCMAKE_C_COMPILER=$cc -DCMAKE_CXX_COMPILER=$cxx -DPREFER_STATIC_LINKING=ON -DLOGANDROIDTARGET=ON"
        targets="mke2fs;tune2fs;e2fsdroid;debugfs;resize2fs;e2fsck;e2fsextract"
    elif [[ $(uname) == "Linux" ]]; then
        cmake_gen_args="-DCMAKE_C_COMPILER=$cc -DCMAKE_CXX_COMPILER=$cxx -DPREFER_STATIC_LINKING=ON -DLOGANDROIDTARGET=OFF"
        targets="mke2fs;tune2fs;e2fsdroid;debugfs;resize2fs;e2fsck;e2fsextract"
    elif [[ $(uname -o) == "Msys" ]]; then
        cmake_gen_args="-DCMAKE_C_COMPILER=$cc -DCMAKE_CXX_COMPILER=$cxx -DPREFER_STATIC_LINKING=ON -DLOGANDROIDTARGET=OFF"
        targets="mke2fs;e2fsextract"
    fi

    rm -rf "build"
    echo "cmake $cmake_gen_args -G Ninja"
    cmake $cmake_gen_args -DCMAKE_BUILD_TYPE="Release" -G "Ninja" -B "build"
    cmake --build "build" --target="$targets" -j$(nproc --all)
}

function install() {
    cmake --install "build" --prefix "build"
}

install_deps
check_msys_clang64_environment
check_gcc
set_toolchains
# if you need to compile for aarch64, please use "build android 30"
build $@
install
