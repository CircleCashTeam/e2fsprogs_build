set(target_name "log")

set(liblog_src_dir
    "${CMAKE_SOURCE_DIR}/src/logging/liblog"
)

set(liblog_src
    "${liblog_src_dir}/log_event_list.cpp"
    "${liblog_src_dir}/log_event_write.cpp"
    "${liblog_src_dir}/logger_name.cpp"
    "${liblog_src_dir}/logger_read.cpp"
    "${liblog_src_dir}/logger_write.cpp"
    "${liblog_src_dir}/logprint.cpp"
    "${liblog_src_dir}/properties.cpp"
)

set(liblog_target_sources
    "${liblog_src_dir}/log_time.cpp"
    "${liblog_src_dir}/pmsg_reader.cpp"
    "${liblog_src_dir}/pmsg_writer.cpp"
    "${liblog_src_dir}/logd_reader.cpp"
    "${liblog_src_dir}/logd_writer.cpp"
)

if(NOT WIN32)
    list(APPEND liblog_src "${liblog_src_dir}/event_tag_map.cpp")
endif()

add_library(${target_name} STATIC ${liblog_src})
target_compile_options(${target_name} PRIVATE
    "-Wall"
    "-Wextra"
    "-Wexit-time-destructors"
    "-DLIBLOG_LOG_TAG=1006"
    "-DSNET_EVENT_LOG_TAG=1397638484"
    "-DANDROID_DEBUGGABLE=0"
)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_options(${target_name} PRIVATE
        "-UANDROID_DEBUGGABLE"
        "-DANDROID_DEBUGGABLE=1"
    )
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_link_options(${target_name} PRIVATE "-Wl,--dynamic-list=${liblog_src_dir}/liblog.map.txt")
endif()

target_include_directories(${target_name} PRIVATE
    ${libbase_headers}
    ${libcutils_headers}
    ${liblog_headers}
    ${libutils_headers}
    ${core_headers}
)