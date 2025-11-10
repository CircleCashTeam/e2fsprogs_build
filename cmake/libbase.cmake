set(target_name "base")

set(libbase_cflags
    "-Wall"
    "-Wextra"
    "-Wexit-time-destructors"
)

if(CMAKE_SYSTEM_NAME STREQUAL "Android") 
    list(APPEND libbase_cflags "-D_FILE_OFFSET_BITS=64") 
endif()

if (WIN32)
    list(APPEND libbase_cflags "-D_POSIX_THREAD_SAFE_FUNCTIONS")
endif()

set(libbase_src_dir "${CMAKE_SOURCE_DIR}/src/libbase")

set(libbase_src
    "${libbase_src_dir}/abi_compatibility.cpp"
    "${libbase_src_dir}/chrono_utils.cpp"
    "${libbase_src_dir}/cmsg.cpp"
    "${libbase_src_dir}/file.cpp"
    "${libbase_src_dir}/hex.cpp"
    "${libbase_src_dir}/logging.cpp"
    "${libbase_src_dir}/mapped_file.cpp"
    "${libbase_src_dir}/parsebool.cpp"
    "${libbase_src_dir}/parsenetaddress.cpp"
    "${libbase_src_dir}/posix_strerror_r.cpp"
    "${libbase_src_dir}/process.cpp"
    "${libbase_src_dir}/properties.cpp"
    "${libbase_src_dir}/result.cpp"
    "${libbase_src_dir}/stringprintf.cpp"
    "${libbase_src_dir}/strings.cpp"
    "${libbase_src_dir}/threads.cpp"
    "${libbase_src_dir}/test_utils.cpp"
)

if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    list(APPEND libbase_src "${libbase_src_dir}/errors_unix.cpp")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    list(APPEND libbase_src "${libbase_src_dir}/errors_unix.cpp")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    list(APPEND libbase_src
        "${libbase_src_dir}/errors_windows.cpp"
        "${libbase_src_dir}/utf8.cpp"
    )
    list(REMOVE_ITEM libbase_src "${libbase_src_dir}/cmsg.cpp")
endif()
add_library(${target_name} STATIC ${libbase_src})
target_compile_options(${target_name} PRIVATE ${libbase_cflags})
target_include_directories(${target_name} PRIVATE
    ${fmtlib_headers}
    ${libbase_headers}
    ${liblog_headers}
)
