set(target_name "ext2_misc")

set(libext2_misc_dir
    "${CMAKE_SOURCE_DIR}/src/e2fsprogs/misc"
)

set(libext2_misc_srcs
    "${libext2_misc_dir}/create_inode.c"
)

list(APPEND libext2_headers "${libext2_misc_dir}")

add_library(${target_name} STATIC ${libext2_misc_srcs})
target_compile_options(${target_name} PRIVATE ${e2fsprogs_cflags})

target_include_directories(${target_name} PRIVATE
    ${e2fsprogs_includes}
    ${libext2_headers}
)