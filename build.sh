#!/bin/bash
LOCALDIR=$(pwd)
cc="clang"
cxx="clang++"

function prepare() {
    if grep -qo "debian" /etc/os-release; then
        sudo apt install -y cmake gcc clang llvm libc++-dev libc++abi-dev git ninja-build lld nasm wget
    fi

    if uname -o | grep -qo "Msys"; then
        pacman -Sy --noconfirm
        pacman -S --needed --noconfirm pactoys git unzip wget
        pacboy -S --needed --noconfirm {gcc,clang,llvm,libc++,cmake,ninja,lld,nasm}:p
    fi
}


function set_toolchains() {
    local windows_versioin="20251104"
    local linux_version="20251104"
    local platform_version="msvcrt"
    local mingw_ubuntu_version="22.04"

    if grep -qo "debian" /etc/os-release; then
        if [[ ! -e "llvm-mingw-$linux_version-$platform_version-ubuntu-$mingw_ubuntu_version-x86_64.tar.xz" ]]; then
            wget https://github.com/mstorsjo/llvm-mingw/releases/download/$linux_version/llvm-mingw-$linux_version-msvcrt-ubuntu-$mingw_ubuntu_version-x86_64.tar.xz
        fi
        if [[ ! -e "llvm-mingw-$platform_version-x86_64_linux" ]]; then
            tar -xf "llvm-mingw-$linux_version-$platform_version-ubuntu-$mingw_ubuntu_version-x86_64.tar.xz" -C "."
            mv "llvm-mingw-$linux_version-$platform_version-ubuntu-$mingw_ubuntu_version-x86_64" "llvm-mingw-$platform_version-x86_64_linux"
        fi
        export PATH="$LOCALDIR/llvm-mingw-$platform_version-x86_64_linux/bin:$PATH"
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

function check_gcc() {       
    local current_gcc_version=$(gcc --version | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]' | head -n1)
    local major_version=$(echo "$current_gcc_version" | cut -d"." -f1)
    if (($major_version < 18 )); then
        echo "build use gcc version min is 18.x.x! current version is $current_gcc_version"
        exit 1
fi
}

function build() {
    local cmake_gen_args=
    if grep -qo "debian" /etc/os-release; then
        cmake_gen_args="-DCMAKE_C_COMPILER=$cc -DCMAKE_CXX_COMPILER=$cxx -DCMAKE_SYSTEM_NAME=Linux -DPREFER_STATIC_LINKING=ON"
    fi

    if uname -o | grep -qo "Msys"; then
        cmake_gen_args="-DCMAKE_C_COMPILER=$cc -DCMAKE_CXX_COMPILER=$cxx -DCMAKE_SYSTEM_NAME=Windows -DPREFER_STATIC_LINKING=ON"
    fi

    rm -rf "build"
    echo "cmake $cmake_gen_args -G Ninja"
    cmake $cmake_gen_args -DCMAKE_BUILD_TYPE=Release -G Ninja -B build
    cmake --build build --target="e2fsextract" -j$(nproc --all)
}

prepare
set_toolchains
[[ $cc == "gcc" && $cxx == "g++" ]] && check_gcc
build