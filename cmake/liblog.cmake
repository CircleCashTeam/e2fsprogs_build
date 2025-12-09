set(target_name "log")

set(liblog_src_dir "${CMAKE_SOURCE_DIR}/src/logging/liblog")

set(liblog_src
    "${liblog_src_dir}/log_event_list.cpp"
    "${liblog_src_dir}/log_event_write.cpp"
    "${liblog_src_dir}/logger_name.cpp"
    "${liblog_src_dir}/logger_read.cpp"
    "${liblog_src_dir}/logger_write.cpp"
    "${liblog_src_dir}/logprint.cpp"
    "${liblog_src_dir}/properties.cpp"
)

set(liblogwrap_src_dir "${CMAKE_SOURCE_DIR}/src/logging/logwrapper")
set(liblogwrap_sources
    "${liblogwrap_src_dir}/logwrap.cpp"
)

set(liblog_target_sources
    "${liblog_src_dir}/log_time.cpp"
    "${liblog_src_dir}/pmsg_reader.cpp"
    "${liblog_src_dir}/pmsg_writer.cpp"
    "${liblog_src_dir}/logd_reader.cpp"
    "${liblog_src_dir}/logd_writer.cpp"
)

set(log_flags
    "-std=c++23"
    "-Wall"
    "-Wextra"
    "-Wexit-time-destructors"
    "-DLIBLOG_LOG_TAG=1006"
    "-DSNET_EVENT_LOG_TAG=1397638484"
    "-DANDROID_DEBUGGABLE=0"
)

include(CheckFunctionExists)
check_function_exists(strlcpy HAVE_STRLCPY)
if(HAVE_STRLCPY)
    list(APPEND log_flags "-DHAVE_STRLCPY")
endif()

if(NOT WIN32)
    list(APPEND liblog_src "${liblog_src_dir}/event_tag_map.cpp")
endif()
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    list(APPEND log_flags
        "-UANDROID_DEBUGGABLE"
        "-DANDROID_DEBUGGABLE=1"
    )
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Android")
    list(APPEND liblog_src ${liblog_target_sources})
endif()

add_library(${target_name} STATIC ${liblog_src})
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_link_options(${target_name} PRIVATE "-Wl,--dynamic-list=${liblog_src_dir}/liblog.map.txt")
endif()
target_compile_options(${target_name} PRIVATE ${log_flags})
target_include_directories(${target_name} PUBLIC
    ${libbase_headers}
    ${libcutils_headers}
    ${libutils_headers}
    ${liblog_headers}
    ${core_headers}
)
target_link_libraries(${target_name} PUBLIC
        cutils
)
