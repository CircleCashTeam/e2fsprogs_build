#!/bin/bash
LOCALDIR=$(pwd)

function build() {
    target="$1"

    if [ -e "build_${target}" ]; then
        rm -rf "build_${target}"
    fi

    CC="${target}-clang" \
    CXX="${target}-clang++" \
    cmake \
        -DPREFER_STATIC_LINKING=ON \
        -DCMAKE_SYSTEM_NAME=Windows \
        -DCMAKE_LINKER=ld.lld \
        -B "build_${target}" && \
    cmake --build "build_${target}" --target=e2fsextract -j$(nproc --all)
}

function prepare() {
    if grep -qo 'debian' /etc/os-release; then
    sudo apt install -y make cmake gcc libc++-dev git patch wget
        if [[ ! -e "llvm-mingw-20240619-msvcrt-ubuntu-20.04-x86_64" ]]; then
            wget https://github.com/mstorsjo/llvm-mingw/releases/download/20240619/llvm-mingw-20240619-msvcrt-ubuntu-20.04-x86_64.tar.xz
            tar -xf llvm-mingw-20240619-msvcrt-ubuntu-20.04-x86_64.tar.xz -C .
        fi
    fi

    if uname -o | grep -qo "Msys"; then
    #pacman -Syu --noconfirm
    pacman -S --noconfirm make cmake gcc git unzip mingw-w64-x86_64-libc++ patch wget
        if [[ ! -e "llvm-mingw-20240619-msvcrt-x86_64" ]]; then
            # wget https://github.com/mstorsjo/llvm-mingw/releases/download/20240619/llvm-mingw-20240619-msvcrt-x86_64.zip
            unzip llvm-mingw-20240619-msvcrt-x86_64.zip -d .
        fi
    fi

    export PATH="$LOCALDIR/llvm-mingw-20240619-msvcrt-ubuntu-20.04-x86_64/bin:$PATH"
}

prepare
for target in "x86_64-w64-mingw32" "i686-w64-mingw32"; do
    echo "- Building target: ${target} ..."
    build "$target"
    echo "- Done!"
done