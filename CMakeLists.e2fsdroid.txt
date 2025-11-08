set(target_name "e2fsdroid")

set(target_dir "${CMAKE_SOURCE_DIR}/src/e2fsprogs/contrib/android")

set(target_srcs
    "${target_dir}/e2fsdroid.c"
    "${target_dir}/block_range.c"
    "${target_dir}/fsmap.c"
    "${target_dir}/block_list.c"
    "${target_dir}/base_fs.c"
    "${target_dir}/perms.c"
    "${target_dir}/basefs_allocator.c"
)

add_executable(${target_name} ${target_srcs})
target_compile_options(${target_name} PUBLIC
    ${e2fsprogs_cflags}
    "-Wno-error=macro-redefined"
    "-Wno-error=sign-compare"
)
target_include_directories(${target_name} PRIVATE
    ${e2fsprogs_includes}
    ${libext2_headers}
    ${libbase_headers}
    ${libsparse_headers}
    ${zlib_headers}
    ${libcutils_headers}
    ${libselinux_headers}
    ${libcrypto_headers}
    ${liblog_headers}
)
target_link_libraries(${target_name} PRIVATE
    ext2_com_err
    ext2_misc
    ext2fs
    sparse
    zlibstatic
    cutils
    base
    selinux
    crypto
    log
)
