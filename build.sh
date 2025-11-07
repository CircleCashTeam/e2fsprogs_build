#!/bin/bash
LOCALDIR=$(pwd)

function build() {
    rm -rf "build"
    if grep -qo 'debian' /etc/os-release; then
        cmake \
            -DCMAKE_C_COMPILER=clang \
            -DCMAKE_CXX_COMPILER=clang++ \
            -DCMAKE_LINKER=ld.lld \
            -DCMAKE_SYSTEM_NAME=Linux \
            -DPREFER_STATIC_LINKING=ON \
            -DCMAKE_BUILD_TYPE=Debug \
            -G "Ninja" \
            -B "build"
    fi

    if uname -o | grep -qo "Msys"; then
        cmake \
            -DCMAKE_C_COMPILER=clang \
            -DCMAKE_CXX_COMPILER=clang++ \
            -DCMAKE_LINKER=ld.lld \
            -DCMAKE_SYSTEM_NAME=Windows \
            -DPREFER_STATIC_LINKING=ON \
            -DCMAKE_BUILD_TYPE=Debug \
            -G "Ninja" \
            -B "build"
        fi

    cmake --build "build" --target=e2fsextract -j$(nproc --all)
}

function prepare() {
    if grep -qo 'debian' /etc/os-release; then
        sudo apt install -y cmake gcc clang libc++-dev git ninja-build build-essential wget
        if [[ ! -e "llvm-mingw-20240619-msvcrt-ubuntu-20.04-x86_64" ]]; then
            wget https://github.com/mstorsjo/llvm-mingw/releases/download/20240619/llvm-mingw-20240619-msvcrt-ubuntu-20.04-x86_64.tar.xz
            tar -xf llvm-mingw-20240619-msvcrt-ubuntu-20.04-x86_64.tar.xz -C .
        fi
        export PATH="$LOCALDIR/llvm-mingw-20240619-msvcrt-ubuntu-20.04-x86_64/bin:$PATH"
    fi
       

    if uname -o | grep -qo "Msys"; then
        pacman -S --noconfirm cmake gcc clang git unzip mingw-w64-x86_64-libc++ wget
        if [[ ! -e "llvm-mingw-20240619-msvcrt-x86_64" ]]; then
            wget https://github.com/mstorsjo/llvm-mingw/releases/download/20240619/llvm-mingw-20240619-msvcrt-x86_64.zip
            unzip -q llvm-mingw-20240619-msvcrt-x86_64.zip -d .
        fi
        export PATH="$LOCALDIR/llvm-mingw-20240619-msvcrt-x86_64/bin:$PATH"
    fi
}

prepare
build