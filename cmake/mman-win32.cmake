set(target_name "mman-win32")

set(target_dir "${CMAKE_SOURCE_DIR}/src/mman-win32")
set(target_srcs "${target_dir}/mman.c")

add_library(${target_name} ${target_srcs})
target_compile_options(${target_name} PRIVATE
        "-Wall"
        "-Wpedantic"
)
target_include_directories(${target_name} PRIVATE "${target_dir}")