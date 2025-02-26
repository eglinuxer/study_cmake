cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

project(simple
    VERSION         1.0.0
    DESCRIPTION     "A collection of sample C++ applications and libraries to demonstrate creating libraries and executables"
    LANGUAGES       CXX
)

add_subdirectory(hello_world)
add_subdirectory(simple_library)
add_subdirectory(simple_library_static)
add_subdirectory(simple_library_shared)
add_subdirectory(hello_header_only)
add_subdirectory(hello_object_lib)

add_executable(simple)

target_sources(simple
    PRIVATE
        src/main.cpp
)

target_link_libraries(simple
    PRIVATE
        hello_header_only
        hello_object
        hello_shared
)
