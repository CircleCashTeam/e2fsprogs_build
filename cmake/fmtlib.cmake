set(target_name "fmtlib")

set(fmtlib_dir "${CMAKE_SOURCE_DIR}/src/fmtlib")

set(fmtlib_srcs
    "${fmtlib_dir}/src/format.cc"
)

set(cflags 
        "-fno-exceptions"
        # If built without exceptions libfmt uses assert.
        # The tests *require* exceptions so we can't win here.
        # (This is also why we have two cc_defaults in this file.)
        # Unless proven to be a bad idea let's at least have some run-time
        # checking.
        "-UNDEBUG"
)


add_library(${target_name} STATIC ${fmtlib_srcs})
target_compile_options(${target_name} PRIVATE ${cflags})
target_include_directories(${target_name} PUBLIC ${fmtlib_headers})