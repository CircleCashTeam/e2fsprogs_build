cmake_minimum_required(VERSION 3.10)

project(e2fsprogs_build LANGUAGES C CXX)

set(CMAKE_C_STANDARD 23)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_CXX_EXTENSIONS ON)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    # Android libs requried libc++
    if(NOT WIN32)
        link_libraries(stdc++)
    else()
        link_libraries(c++)
    endif()

    set(CMAKE_POLICY_DEFAULT_CMP0069 NEW)

    # enable
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)

    # use lld
    add_link_options(-fuse-ld=lld)
else()
    link_libraries(stdc++)
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
include("${CMAKE_SOURCE_DIR}/CMakeLists.include.txt")

# e2fs_defaults
include("${CMAKE_SOURCE_DIR}/CMakeLists.e2fsprogs.txt")

# e2fs_libs
include("${CMAKE_SOURCE_DIR}/CMakeLists.libext2_com_err.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libext2fs.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libext2_misc.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libext2_blkid.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libext2_uuid.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libext2_e2p.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libext2_ss.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libext2_support.txt")

# Libraries
include("${CMAKE_SOURCE_DIR}/CMakeLists.liblog.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libbase.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libsparse.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libprocessgroup.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libcutils.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.pcre.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libsepol.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.libselinux.txt")

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
include("${CMAKE_SOURCE_DIR}/CMakeLists.misc.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.e2fsck.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.debugfs.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.resize2fs.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.e2fsdroid.txt")
include("${CMAKE_SOURCE_DIR}/CMakeLists.extract.txt")
