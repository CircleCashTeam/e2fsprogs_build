set(target_name "pcre2")

set(target_cflags
    "-DHAVE_CONFIG_H"
    "-Wall"
    "-Werror"
    "-DPCRE2_CODE_UNIT_WIDTH=8"
)

set(target_dir
    "${CMAKE_SOURCE_DIR}/src/pcre"
)

set(target_srcs 
        "${target_dir}/src/pcre2_auto_possess.c"
        "${target_dir}/src/pcre2_chartables.c"
        "${target_dir}/src/pcre2_chkdint.c"
        "${target_dir}/src/pcre2_compile.c"
        "${target_dir}/src/pcre2_config.c"
        "${target_dir}/src/pcre2_context.c"
        "${target_dir}/src/pcre2_convert.c"
        "${target_dir}/src/pcre2_dfa_match.c"
        "${target_dir}/src/pcre2_error.c"
        "${target_dir}/src/pcre2_extuni.c"
        "${target_dir}/src/pcre2_find_bracket.c"
        "${target_dir}/src/pcre2_jit_compile.c"
        "${target_dir}/src/pcre2_maketables.c"
        "${target_dir}/src/pcre2_match_data.c"
        "${target_dir}/src/pcre2_match.c"
        "${target_dir}/src/pcre2_newline.c"
        "${target_dir}/src/pcre2_ord2utf.c"
        "${target_dir}/src/pcre2_pattern_info.c"
        "${target_dir}/src/pcre2_script_run.c"
        "${target_dir}/src/pcre2_serialize.c"
        "${target_dir}/src/pcre2_string_utils.c"
        "${target_dir}/src/pcre2_study.c"
        "${target_dir}/src/pcre2_substitute.c"
        "${target_dir}/src/pcre2_substring.c"
        "${target_dir}/src/pcre2_tables.c"
        "${target_dir}/src/pcre2_ucd.c"
        "${target_dir}/src/pcre2_valid_utf.c"
        "${target_dir}/src/pcre2_xclass.c"
)

add_library(${target_name} STATIC ${target_srcs})
target_compile_options(${target_name} PRIVATE ${target_cflags})
target_include_directories(${target_name} PRIVATE ${libpcre2_headers})