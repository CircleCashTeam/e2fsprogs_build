set(target_name "crypto")

set(boringssl_dir "${CMAKE_SOURCE_DIR}/src/boringssl")
set(BORINGSSL_ROOT "${boringssl_dir}/")
include("${boringssl_dir}/android-sources.cmake")

set(link_opts "-pthread")

set(common_cflags
    "-std=c++17"
    "-Wall"
    "-DBORINGSSL_IMPLEMENTATION"
    "-DBORINGSSL_ANDROID_SYSTEM"
)

if (WIN32)
    enable_language(ASM_NASM)
    list(APPEND link_opts "-ws2_32")
    list(APPEND crypto_sources ${crypto_sources_nasm})
else ()
    enable_language(ASM)
    list(APPEND common_cflags "-Wl-Bsymbolic")
    list(APPEND crypto_sources ${crypto_sources_asm})
    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        list(APPEND "-Wl--dynamic-list=${boringssl_dir}/src/crypto/fipsmodule/fips_shared.lds")
    endif ()
endif ()

add_library(${target_name} STATIC ${crypto_sources})
target_link_options(${target_name} PRIVATE ${link_opts})
target_include_directories(${target_name} PRIVATE ${libcrypto_headers})
target_compile_options(${target_name} PRIVATE
        ${common_flags}
        ${android_cflags}
)