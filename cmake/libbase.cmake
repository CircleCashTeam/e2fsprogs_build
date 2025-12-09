set(target_name "base")

set(libbase_dir "${CMAKE_SOURCE_DIR}/src/libbase")

set(libbase_srcs
        "${libbase_dir}/chrono_utils.cpp"
        "${libbase_dir}/cmsg.cpp"
        "${libbase_dir}/file.cpp"
        "${libbase_dir}/hex.cpp"
        "${libbase_dir}/logging.cpp"
        "${libbase_dir}/mapped_file.cpp"
        "${libbase_dir}/parsebool.cpp"
        "${libbase_dir}/parsenetaddress.cpp"
        "${libbase_dir}/posix_strerror_r.cpp"
        "${libbase_dir}/process.cpp"
        "${libbase_dir}/properties.cpp"
        "${libbase_dir}/result.cpp"
        "${libbase_dir}/stringprintf.cpp"
        "${libbase_dir}/strings.cpp"
        "${libbase_dir}/threads.cpp"
        "${libbase_dir}/test_utils.cpp"
)

set(cflags
        "-Wall"
        "-Wextra"
        "-Wexit-time-destructors"
)

if(NOT WIN32)
    list(APPEND libbase_srcs "${libbase_dir}/errors_unix.cpp")
else()
    list(APPEND libbase_srcs 
        "${libbase_dir}/errors_windows.cpp"
        "${libbase_dir}/utf8.cpp"
    )
    list(REMOVE_ITEM libbase_srcs "${libbase_dir}/cmsg.cpp")
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Android")
    list(APPEND cflags "-D_FILE_OFFSET_BITS=64")
endif()

add_library(${target_name} STATIC ${libbase_srcs})
target_compile_options(${target_name} PRIVATE ${cflags})
target_include_directories(${target_name} PUBLIC 
    ${libbase_headers}
    ${fmtlib_headers}
    ${liblog_headers}
)
target_link_libraries(${target_name} PUBLIC
    log
    fmtlib
)