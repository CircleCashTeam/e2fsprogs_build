set(target_name "debugfs")

set(target_dir "${CMAKE_SOURCE_DIR}/src/e2fsprogs/debugfs")

set(target_srcs
        "${target_dir}/debug_cmds.c"
        "${target_dir}/debugfs.c"
        "${target_dir}/util.c"
        "${target_dir}/ncheck.c"
        "${target_dir}/icheck.c"
        "${target_dir}/ls.c"
        "${target_dir}/lsdel.c"
        "${target_dir}/dump.c"
        "${target_dir}/set_fields.c"
        "${target_dir}/logdump.c"
        "${target_dir}/htree.c"
        "${target_dir}/unused.c"
        "${target_dir}/e2freefrag.c"
        "${target_dir}/filefrag.c"
        "${target_dir}/extent_cmds.c"
        "${target_dir}/extent_inode.c"
        "${target_dir}/zap.c"
        "${target_dir}/quota.c"
        "${target_dir}/xattrs.c"
        "${target_dir}/journal.c"
        "${target_dir}/revoke.c"
        "${target_dir}/recovery.c"
        "${target_dir}/do_journal.c"
)

add_executable(${target_name} ${target_srcs})
target_compile_options(${target_name} PRIVATE
    ${e2fsprogs_cflags}
    "-DDEBUGFS"
)
target_include_directories(${target_name} PRIVATE
    ${e2fsprogs_includes}
    ${libext2_headers}
    ${target_dir}/../misc
    ${target_dir}/../e2fsck
)
target_link_libraries(${target_name} PRIVATE
    ext2_misc
    ext2fs
    ext2_blkid
    ext2_uuid
    ext2_ss
    ext2_quota
    ext2_com_err
    ext2_e2p
    ext2_support
)