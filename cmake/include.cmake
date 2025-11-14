set(libsparse_headers "${CMAKE_SOURCE_DIR}/src/core/libsparse/include" CACHE STRING "" FORCE)
set(libcrypto_headers "${CMAKE_SOURCE_DIR}/src/boringssl/include" CACHE STRING "" FORCE)
set(fmtlib_headers "${CMAKE_SOURCE_DIR}/src/fmtlib/include" CACHE STRING "" FORCE)
set(zlib_headers "${CMAKE_SOURCE_DIR}/src/zlib" CACHE STRING "" FORCE)
set(core_headers "${CMAKE_SOURCE_DIR}/src/core/include" CACHE STRING "" FORCE)
set(libbase_headers "${CMAKE_SOURCE_DIR}/src/libbase/include" CACHE STRING "" FORCE)
set(libcutils_headers "${CMAKE_SOURCE_DIR}/src/core/libcutils/include" CACHE STRING "" FORCE)
set(libutils_headers "${CMAKE_SOURCE_DIR}/src/core/libutils/include" CACHE STRING "" FORCE)
set(libselinux_headers "${CMAKE_SOURCE_DIR}/src/selinux/libselinux/include" CACHE STRING "" FORCE)
set(liblog_headers 
    "${CMAKE_SOURCE_DIR}/src/logging/liblog/include" 
    "${CMAKE_SOURCE_DIR}/src/logging/liblog/include_vndk"
CACHE STRING "" FORCE)
set(libsepol_headers
    "${CMAKE_SOURCE_DIR}/src/selinux/libsepol/include"
    "${CMAKE_SOURCE_DIR}/src/selinux/libsepol/cil/include"
    CACHE STRING "" FORCE
)
set(libpcre2_headers "${CMAKE_SOURCE_DIR}/src/pcre/include" CACHE STRING "" FORCE)

set(libext2_headers "" CACHE STRING "libext2 headers list" FORCE)