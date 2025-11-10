cmake_minimum_required(VERSION 3.10)

project(e2fsprogs_build LANGUAGES C CXX)

set(CMAKE_C_STANDARD 23)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_CXX_EXTENSIONS ON)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    message("This use Clang build")

    # set clang policy
    set(CMAKE_POLICY_DEFAULT_CMP0069 NEW)
    # enable
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
    # use lld
    add_link_options("-fuse-ld=lld")

    # Android libs requried libc++ c++abi
    find_library(libcxx NAMES "libc++.a" "libc++.so" "libc++.dll" "libc++.lib")
    find_library(libcxxabi NAMES "libc++abi.a" "libc++abi.so" "libc++abi.dll" "libc++abi.lib")
    find_library(libstdcxx NAMES "libstdc++.a" "libstdc++.so" "libstdc++.dll" "libstdc++.lib")
    if(NOT CMAKE_SYSTEM_NAME STREQUAL "Linux")
        if(libcxx)
            message("find libc++")
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --stdlib=libc++")
        endif()
        if(libcxxabi)
            message("find libc++abi")
            link_libraries(c++abi)
        endif()
        if(libstdcxx AND NOT libcxx)
            message("find libstdc++ not find libc++")
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --stdlib=libstdc++")
        endif()
        if(NOT libstdcxx AND NOT libcxx)
            message("libstdc++ libc++ not find")
        endif()
    endif()
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES "GCC")
    message("This use GCC build")

    find_library(libstdcxx NAMES "libstdc++.a" "libstdc++.so" "libstdc++.dll" "libstdc++.lib")
    if(libstdcxx)
        message("find libstdc++")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --stdlib=libstdc++")
    endif()
         message("not find libstdc++")
endif()

# Lib with cmake can direct import
add_subdirectory("${CMAKE_SOURCE_DIR}/src/fmtlib")
add_subdirectory("${CMAKE_SOURCE_DIR}/src/zlib")

set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(BUILD_STATIC_LIBS ON CACHE BOOL "" FORCE)
set(JSONCPP_WITH_TESTS OFF CACHE BOOL "" FORCE)
add_subdirectory("${CMAKE_SOURCE_DIR}/src/jsoncpp")

set(BUILD_GMOCK ON CACHE BOOL "" FORCE)
add_subdirectory("${CMAKE_SOURCE_DIR}/src/googletest")

add_subdirectory("${CMAKE_SOURCE_DIR}/src/boringssl")
#add_subdirectory("${CMAKE_SOURCE_DIR}/src/pcre")

# Headers
include("${CMAKE_SOURCE_DIR}/cmake/include.cmake")

# e2fs_defaults
include("${CMAKE_SOURCE_DIR}/cmake/e2fsprogs.cmake")

# e2fs_libs
include("${CMAKE_SOURCE_DIR}/cmake/libext2_com_err.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libext2fs.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libext2_misc.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libext2_blkid.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libext2_uuid.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libext2_e2p.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libext2_ss.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libext2_support.cmake")

# Libraries
include("${CMAKE_SOURCE_DIR}/cmake/liblog.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libbase.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libsparse.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libprocessgroup.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libcutils.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/pcre.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libsepol.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/libselinux.cmake")

option(PREFER_STATIC_LINKING "Link static" OFF)

if(PREFER_STATIC_LINKING)
    set(CMAKE_EXE_LINKER_FLAGS "-static")
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3")
    set(CMAKE_CXX_FLAGS
        "${CMAKE_CXX_FLAGS} -O3 -ffunction-sections -fdata-sections -fno-rtti -fno-exceptions"
    )
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--gc-sections -s")
endif()

if(WIN32) 
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE")
endif()

# Binaries
include("${CMAKE_SOURCE_DIR}/cmake/misc.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/e2fsck.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/debugfs.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/resize2fs.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/e2fsdroid.cmake")
include("${CMAKE_SOURCE_DIR}/cmake/extract.cmake")
