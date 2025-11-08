set(target_name "resize2fs")

set(target_dir "${CMAKE_SOURCE_DIR}/src/e2fsprogs/resize")

set(target_srcs
    "${target_dir}/extent.c"
    "${target_dir}/resize2fs.c"
    "${target_dir}/main.c"
    "${target_dir}/online.c"
    "${target_dir}/sim_progress.c"
    "${target_dir}/resource_track.c"
)

add_executable(${target_name} ${target_srcs})
target_compile_options(${target_name} PRIVATE ${e2fsprogs_cflags})
target_include_directories(${target_name} PRIVATE
    ${e2fsprogs_includes}
    ${libext2_headers}
)
target_link_libraries(${target_name} PRIVATE
    ext2fs
    ext2_blkid
    ext2_com_err
    ext2_e2p
    ext2_uuid
    ext2_e2p
)