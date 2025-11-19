set(target_name "crypto")

set(target_src_dir "${CMAKE_SOURCE_DIR}/src/boringssl")
set(BORINGSSL_ROOT "${target_src_dir}/")
include("${target_src_dir}/android-sources.cmake")

set(link_opts "-pthread")

set(common_cflags
        "-Wall"
        "-std=c++17"
        "-fvisibility=hidden"
        "-DBORINGSSL_SHARED_LIBRARY"
        "-DOPENSSL_SMALL"
        "-Wno-unused-parameter"
        "-DBORINGSSL_IMPLEMENTATION"
        "-fsanitize=hwaddress"
)

set(android_cflags
        "-DBORINGSSL_ANDROID_SYSTEM"
        "-DBORINGSSL_FIPS"
        "-fPIC"
        # -fno[data|text]-sections required to ensure a
        # single text and data section for FIPS integrity check
        "-fno-data-sections"
        "-fno-function-sections"
)

if (WIN32)
    list(APPEND link_opts "-ws2_32")
    list(REMOVE_ITEM android_cflags "-DBORINGSSL_FIPS")
    list(APPEND crypto_sources ${crypto_sources_nasm})
else ()
    list(APPEND "-Wl-Bsymbolic")
    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        list(APPEND "-Wl--dynamic-list=${CMAKE_SOURCE_DIR}/src/crypto/fipsmodule/fips_shared.lds")
    endif ()
endif ()

add_library(${target_name} STATIC ${crypto_sources})
target_link_options(${target_name} PRIVATE ${link_opts})
target_include_directories(${target_name} PRIVATE ${libcrypto_headers})
target_compile_options(${target_name} PRIVATE
        ${common_flags}
        ${android_cflags}
)