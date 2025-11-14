set(target_name "fmtlib")

set(fmtlib_dir "${CMAKE_SOURCE_DIR}/src/fmtlib")

set(libfmt_srcs "${fmtlib_dir}/src/format.cc")

SET(fmtlib_cflags
        "-fno-exceptions"
        # If built without exceptions, libfmt uses assert.
        # The tests *require* exceptions, so we can't win here.
        # (This is also why we have two cc_defaults in this file.)
        # Unless proven to be a bad idea, let's at least have some run-time
        # checking.
        "-UNDEBUG"
)

add_library(${target_name} STATIC ${libfmt_srcs})
target_compile_options(${target_name} PRIVATE ${fmtlib_cflags})
target_include_directories(${target_name} PRIVATE ${fmtlib_headers})