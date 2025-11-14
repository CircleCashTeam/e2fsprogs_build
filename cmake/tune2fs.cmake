set(target_name "tune2fs")

set(target_srcs
        "${target_dir}/tune2fs.c"
        "${target_dir}/util.c"
)

add_executable(${target_name} ${target_srcs})
target_compile_options(${target_name} PRIVATE
        ${e2fsprogs_cflags}
        "-DNO_RECOVERY"
)
target_include_directories(${target_name} PRIVATE
        ${e2fsprogs_includes}
        ${libext2_headers}
        ${CMAKE_SOURCE_DIR}/src/e2fsprogs/e2fsck
)
target_link_libraries(${target_name} PRIVATE
        ext2_quota
        ext2_blkid
        ext2_uuid
        ext2_com_err
        ext2_e2p
        ext2fs
)