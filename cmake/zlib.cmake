set(target_name "zlib")

set(libz_srcs_dir "${CMAKE_SOURCE_DIR}/src/zlib")

set(libz_srcs
        "${libz_srcs_dir}/adler32.c"
        "${libz_srcs_dir}/adler32_simd.c"
        "${libz_srcs_dir}/compress.c"
        "${libz_srcs_dir}/cpu_features.c"
        "${libz_srcs_dir}/crc32.c"
        "${libz_srcs_dir}/crc32_simd.c"
        "${libz_srcs_dir}/crc_folding.c"
        "${libz_srcs_dir}/deflate.c"
        "${libz_srcs_dir}/gzclose.c"
        "${libz_srcs_dir}/gzlib.c"
        "${libz_srcs_dir}/gzread.c"
        "${libz_srcs_dir}/gzwrite.c"
        "${libz_srcs_dir}/infback.c"
        "${libz_srcs_dir}/inffast.c"
        "${libz_srcs_dir}/inflate.c"
        "${libz_srcs_dir}/inftrees.c"
        "${libz_srcs_dir}/trees.c"
        "${libz_srcs_dir}/uncompr.c"
        "${libz_srcs_dir}/zutil.c"
)

set(zlib_cflags
        # See ARMV8_OS_LINUX above.
        "-DX86_NOT_WINDOWS"
        # Android's host CPU feature requirements are *lower* than the
        # corresponding device CPU feature requirements so it's easier to just
        # say "no SIMD for you" rather than specificially disable SSSE3.
        # We should have a conversation about that but not until we at least have
        # data on how many Studio users have CPUs that don't make the grade...
        # https:#issuetracker.google.com/171235570
        "-DCPU_NO_SIMD"
        "-DINFLATE_CHUNK_READ_64LE"
        "-D_LARGEFILE64_SOURCE=1"
)

configure_file("${libz_srcs_dir}/zconf.h.cmakein" "${libz_srcs_dir}/zconf.h")

include(CheckFunctionExists)
check_function_exists(fseeko HAVE_FSEEKO)
if(NOT HAVE_FSEEKO)
    add_definitions(-DNO_FSEEKO)
endif()

add_library(${target_name} STATIC ${libz_srcs})

 if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
     target_link_options(${target_name} PRIVATE "-Wl,--dynamic-list=${liblog_src_dir}/libz.map.txt")
 endif()

target_compile_options(${target_name} PRIVATE ${zlib_cflags})
target_include_directories(${target_name} PRIVATE ${libz_srcs_dir})