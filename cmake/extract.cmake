set(target_name "e2fsextract")

set(target_dir "${CMAKE_SOURCE_DIR}/src/extract")

# program version
set(VERSION 1)
set(PATCHLEVEL 0)
configure_file("${target_dir}/version.h.in" "${target_dir}/version.h" )

set(target_srcs
        "${target_dir}/main.cc"
        "${target_dir}/process.cc"
        "${target_dir}/extract.cc"
        "${target_dir}/progress.cc"
)

add_executable(${target_name} ${target_srcs})
target_compile_options(${target_name} PRIVATE ${e2fsprogs_cflags})
target_include_directories(${target_name} PRIVATE
        "${e2fsprogs_includes}"
        "${libext2_headers}"
        "${target_dir}"
        "${CMAKE_SOURCE_DIR}/src/e2fsprogs/e2fsck"
)

target_link_libraries(${target_name} PRIVATE
        ext2_com_err
        ext2fs
        fmt
        sparse
        base
        zlibstatic
)

if(CMAKE_SYSTEM_NAME STREQUAL "Windows") # mmap support for windows
        target_include_directories(${target_name} PRIVATE "${CMAKE_SOURCE_DIR}/src/mman-win32")
        target_link_libraries(${target_name} PRIVATE mman-win32)
endif()