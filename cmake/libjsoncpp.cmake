set(target_name "jsoncpp")

set(jsoncpp_dir "${CMAKE_SOURCE_DIR}/src/jsoncpp")

set(cppflags
        "-DJSON_USE_EXCEPTION=0"
        "-DJSONCPP_NO_LOCALE_SUPPORT"
        "-Wall"
        "-Wno-implicit-fallthrough"
        # src/lib_json/json_reader.cpp:210  has -Wno-implicit-fallthrough
)

set(libjsoncpp_srcs
        "${jsoncpp_dir}/src/lib_json/json_reader.cpp"
        "${jsoncpp_dir}/src/lib_json/json_value.cpp"
        "${jsoncpp_dir}/src/lib_json/json_writer.cpp"
)

add_library(${target_name} STATIC ${libjsoncpp_srcs})
target_compile_options(${target_name} PRIVATE ${cppflags})
target_include_directories(${target_name} PUBLIC
    ${libjsoncpp_headers}
)