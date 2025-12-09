set(target_name "selinux")

set(target_dir "${CMAKE_SOURCE_DIR}/src/selinux/libselinux")

set(cflags
    "-DNO_PERSISTENTLY_STORED_PATTERNS"
    "-DDISABLE_SETRANS"
    "-DDISABLE_BOOL"
    "-D_GNU_SOURCE"
    "-DNO_MEDIA_BACKEND"
    "-DNO_X_BACKEND"
    "-DNO_DB_BACKEND"
    "-Wall"
    "-Wno-error=missing-noreturn"
    "-Wno-error=unused-function"
    "-Wno-error=unused-variable"
    "-Wno-error=unused-but-set-variable"
    "-DUSE_PCRE2"
    # 1003 corresponds to auditd from system/core/logd/event.logtags
    "-DAUDITD_LOG_TAG=1003"
)

if(CMAKE_SYSTEM_NAME STREQUAL "Android")
    list(APPEND target_srcs "src/android/android_device.c")
    list(APPEND cflags 
        "-DHAVE_STRLCPY"
        "-DHAVE_REALLOCARRAY"
    )
else()
    list(APPEND cflags "-DBUILD_HOST")
endif()
include(CheckFunctionExists)
check_function_exists(reallocarray HAVE_REALLOCARRAY)
check_function_exists(strlcpy HAVE_STRLCPY)
if(HAVE_REALLOCARRAY)
    list(APPEND target_cflags "-DHAVE_REALLOCARRAY")
endif()
if(HAVE_STRLCPY)
    list(APPEND target_cflags "-DHAVE_STRLCPY")
endif()

set(target_srcs
        "${target_dir}/src/android/android.c"
        "${target_dir}/src/android/android_seapp.c"
        "${target_dir}/src/avc.c"
        "${target_dir}/src/avc_internal.c"
        "${target_dir}/src/avc_sidtab.c"
        "${target_dir}/src/booleans.c"
        "${target_dir}/src/callbacks.c"
        "${target_dir}/src/canonicalize_context.c"
        "${target_dir}/src/checkAccess.c"
        "${target_dir}/src/check_context.c"
        "${target_dir}/src/compute_av.c"
        "${target_dir}/src/compute_create.c"
        "${target_dir}/src/compute_member.c"
        "${target_dir}/src/context.c"
        "${target_dir}/src/deny_unknown.c"
        "${target_dir}/src/disable.c"
        "${target_dir}/src/enabled.c"
        "${target_dir}/src/fgetfilecon.c"
        "${target_dir}/src/freecon.c"
        "${target_dir}/src/fsetfilecon.c"
        "${target_dir}/src/get_initial_context.c"
        "${target_dir}/src/getenforce.c"
        "${target_dir}/src/getfilecon.c"
        "${target_dir}/src/getpeercon.c"
        "${target_dir}/src/hashtab.c"
        "${target_dir}/src/init.c"
        "${target_dir}/src/label.c"
        "${target_dir}/src/label_backends_android.c"
        "${target_dir}/src/label_file.c"
        "${target_dir}/src/label_support.c"
        "${target_dir}/src/lgetfilecon.c"
        "${target_dir}/src/load_policy.c"
        "${target_dir}/src/lsetfilecon.c"
        "${target_dir}/src/mapping.c"
        "${target_dir}/src/matchpathcon.c"
        "${target_dir}/src/policyvers.c"
        "${target_dir}/src/procattr.c"
        "${target_dir}/src/regex.c"
        "${target_dir}/src/reject_unknown.c"
        "${target_dir}/src/selinux_internal.c"
        "${target_dir}/src/sestatus.c"
        "${target_dir}/src/setenforce.c"
        "${target_dir}/src/setfilecon.c"
        "${target_dir}/src/setrans_client.c"
        "${target_dir}/src/sha1.c"
        "${target_dir}/src/stringrep.c"
)

add_library(${target_name} STATIC ${target_srcs})
target_compile_options(${target_name} PRIVATE ${cflags})
target_include_directories(${target_name} PUBLIC
    ${libbase_headers}
    ${libcutils_headers}
    ${liblog_headers}
    ${libpcre2_headers}
    ${libsepol_headers}
    ${libselinux_headers}
    PRIVATE "${target_dir}/src"
)
target_link_libraries(${target_name} PUBLIC 
    pcre2
    log
)
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_link_options(${target_name} PRIVATE "-Wl,--dynamic-list=${target_dir}/exported.map.txt")
endif()