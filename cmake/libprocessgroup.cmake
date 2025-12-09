set(libprocessgroup_dir "${CMAKE_SOURCE_DIR}/src/core/libprocessgroup")
set(libprocessgroup_util_dir "${CMAKE_SOURCE_DIR}/src/core/libprocessgroup/util")


set(cppflags
    "-std=gnu++23"
    "-Wall"
)

set(libprocessgroup_util_srcs
        "${libprocessgroup_util_dir}/cgroup_controller.cpp"
        "${libprocessgroup_util_dir}/cgroup_descriptor.cpp"
        "${libprocessgroup_util_dir}/util.cpp"
)

set(libprocessgroup_srcs
        "${libprocessgroup_dir}/cgroup_map.cpp"
        "${libprocessgroup_dir}/processgroup.cpp"
        "${libprocessgroup_dir}/sched_policy.cpp"
        "${libprocessgroup_dir}/task_profiles.cpp"
)

add_library(processgroup_util STATIC ${libprocessgroup_srcs})
target_compile_options(processgroup_util PRIVATE ${cppflags})
target_include_directories(processgroup_util PUBLIC
    ${libbase_headers}
    ${libcutils_headers}
    ${libjsoncpp_headers}
    ${libprocessgroup_headers}
    ${libprocessgroup_util_headers}
)
target_link_libraries(processgroup_util PUBLIC
    base
    cutils
    
)

add_library(processgroup STATIC ${libprocessgroup_srcs})
target_compile_options(processgroup PRIVATE ${cppflags})
target_include_directories(processgroup PUBLIC
    ${libbase_headers}
    ${libcutils_headers}
    ${libjsoncpp_headers}
    ${libprocessgroup_headers}
    ${libprocessgroup_util_headers}
)
target_link_libraries(processgroup PUBLIC
    base
    cutils
    jsoncpp
    processgroup_util
)