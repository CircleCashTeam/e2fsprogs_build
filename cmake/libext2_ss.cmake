set(target_name "ext2_ss")

set(target_dir "${CMAKE_SOURCE_DIR}/src/e2fsprogs/lib/ss")

set(target_srcs
        "${target_dir}/ss_err.c"
        "${target_dir}/std_rqs.c"
        "${target_dir}/invocation.c"
        "${target_dir}/help.c"
        "${target_dir}/execute_cmd.c"
        "${target_dir}/listen.c"
        "${target_dir}/parse.c"
        "${target_dir}/error.c"
        "${target_dir}/prompt.c"
        "${target_dir}/request_tbl.c"
        "${target_dir}/list_rqs.c"
        "${target_dir}/pager.c"
        "${target_dir}/requests.c"
        "${target_dir}/data.c"
        "${target_dir}/get_readline.c"
)

list(APPEND libext2_headers "${target_dir}")
add_library(${target_name} STATIC ${target_srcs})
target_compile_options(${target_name} PRIVATE ${e2fsprogs_cflags})

target_include_directories(${target_name} PRIVATE
    ${e2fsprogs_includes}
    ${libext2_headers}
)