#!/bin/bash
LOCALDIR=$(pwd)

export PATH=$LOCALDIR/llvm-mingw-20240619-msvcrt-ubuntu-20.04-x86_64/bin:$PATH
rm -rf build
#  -DCMAKE_SYSTEM_NAME=Windows
cmake -DPREFER_STATIC_LINKING=ON -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_LINKER=ld.lld -B build
cmake --build build --target=e2fsextract