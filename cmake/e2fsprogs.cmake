set(e2fsprogs_cflags
        "-Wall"
        # Some warnings that Android's build system enables by default are not
        # supported by upstream e2fsprogs.  When such a warning shows up,
        # disable it below.  Please don't disable warnings that upstream
        # e2fsprogs is supposed to support; for those, fix the code instead.
        "-Wno-pointer-arith"
        "-Wno-sign-compare"
        "-Wno-type-limits"
        "-Wno-typedef-redefinition"
        "-Wno-unused-parameter"
        "-Wno-unused-but-set-variable"
        "-Wno-macro-redefined"
        # "-Wno-sign-compare" Better keep compare
)

if(CMAKE_SYSTEM_NAME STREQUAL "Darwin") 
    list(APPEND e2fsprogs_cflags "-Wno-error=deprecated-declarations")
endif()

set(e2fsprogs_includes "")
if(WIN32)
    list(APPEND e2fsprogs_cflags "-Wno-error=unused-parameter" "-Wno-error=unused-variable")
    list(APPEND e2fsprogs_includes "${CMAKE_SOURCE_DIR}/src/e2fsprogs/include/mingw")
    list(APPEND e2fsprogs_cflags "-DWINDOWS_IO_MANAGER_USE_MMAP_READ")
endif()

list(APPEND libext2_headers "${CMAKE_SOURCE_DIR}/src/e2fsprogs/lib")