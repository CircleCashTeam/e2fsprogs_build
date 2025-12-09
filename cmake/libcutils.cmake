set(libcutils_dir "${CMAKE_SOURCE_DIR}/src/core/libcutils")

set(cppflags
    "-Wno-exit-time-destructors"
)
set(ldflags "")
if(WIN32)
    list(APPEND ldflags "-lws2_32")
endif()

set(libcutils_sockets_sources
    "${libcutils_dir}/sockets.cpp"
)

set(libcutils_sockets_nonwindows_sources
    "${libcutils_dir}/socket_inaddr_any_server_unix.cpp"
    "${libcutils_dir}/socket_local_client_unix.cpp"
    "${libcutils_dir}/socket_local_server_unix.cpp"
    "${libcutils_dir}/socket_network_client_unix.cpp"
    "${libcutils_dir}/sockets_unix.cpp"
)

if(NOT WIN32)
    list(APPEND libcutils_sockets_sources 
        ${libcutils_sockets_nonwindows_sources}
    )
    if(CMAKE_SYSTEM_NAME STREQUAL "Android")
        list(APPEND libcutils_sockets_sources
            "${libcutils_dir}/android_get_control_file.cpp"
            "${libcutils_dir}/socket_inaddr_any_server_unix.cpp"
            "${libcutils_dir}/socket_local_client_unix.cpp"
            "${libcutils_dir}/socket_local_server_unix.cpp"
            "${libcutils_dir}/socket_network_client_unix.cpp"
            "${libcutils_dir}/sockets_unix.cpp"
        )
    endif()
else()
    list(APPEND libcutils_sockets_sources
        "${libcutils_dir}/socket_inaddr_any_server_windows.cpp"
        "${libcutils_dir}/socket_network_client_windows.cpp"
        "${libcutils_dir}/sockets_windows.cpp"
    )
endif()

set(libcutils_sources
    "${libcutils_dir}/config_utils.cpp"
    "${libcutils_dir}/iosched_policy.cpp"
    "${libcutils_dir}/load_file.cpp"
    "${libcutils_dir}/native_handle.cpp"
    "${libcutils_dir}/properties.cpp"
    "${libcutils_dir}/record_stream.cpp"
    "${libcutils_dir}/strlcpy.c"
)

set(libcutils_nonwindows_sources
    "${libcutils_dir}/fs.cpp"
    "${libcutils_dir}/hashmap.cpp"
    "${libcutils_dir}/multiuser.cpp"
    "${libcutils_dir}/str_parms.cpp"
)

set(libcutils_host_sources
    "${libcutils_dir}/trace-host.cpp"
    "${libcutils_dir}/ashmem-host.cpp"
)

set(libcutils_linux_sources
    "${libcutils_dir}/canned_fs_config.cpp"
    "${libcutils_dir}/fs_config.cpp"
)

if(NOT WIN32)
    list(APPEND libcutils_sources
        ${libcutils_nonwindows_sources}
        ${libcutils_linux_sources}
    )
    if(NOT CMAKE_SYSTEM_NAME STREQUAL "Android")
        list(APPEND libcutils_sources
            ${libcutils_host_sources}
        )
    else()
        list(APPEND libcutils_sources
            "${libcutils_dir}/android_reboot.cpp"
            "${libcutils_dir}/ashmem-dev.cpp"
            "${libcutils_dir}/klog.cpp"
            "${libcutils_dir}/partition_utils.cpp"
            "${libcutils_dir}/qtaguid.cpp"
            "${libcutils_dir}/trace-dev.cpp"
            "${libcutils_dir}/uevent.cpp"
        )
    endif()
endif()

add_library(cutils_sockets STATIC ${libcutils_sockets_sources})
target_compile_options(cutils_sockets PRIVATE ${cppflags} "-D_GNU_SOURCE")
target_link_options(cutils_sockets PRIVATE ${ldflags})
target_include_directories(cutils_sockets PUBLIC
    ${libbase_headers}
    ${libcutils_headers}
    ${liblog_headers}
)
target_link_directories(cutils_sockets PUBLIC
    base
    log
)

add_library(cutils STATIC ${libcutils_sources})
target_compile_options(cutils PRIVATE 
    ${cppflags}
    "-Wall"
    "-Wextra"
)
target_link_options(cutils PRIVATE ${ldflags})
target_include_directories(cutils PUBLIC
    ${libprocessgroup_headers}
    ${libcutils_headers}
    ${libbase_headers}
    ${liblog_headers}
    ${core_headers}
)
target_link_directories(cutils PUBLIC
    processgroup
    cutils_sockets
    base
    log
)