cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

project(simple_library_static
    VERSION         1.0.0
    DESCRIPTION     "A simple C++ project to demonstrate creating executables and libraries in CMake"
    LANGUAGES       CXX
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_library(hello_static STATIC)

set_target_properties(hello_static
    PROPERTIES
        OUTPUT_NAME hello
)


set_target_properties(hello_static
    PROPERTIES
        VERSION ${PROJECT_VERSION}
        SOVERSION ${PROJECT_VERSION_MAJOR}
)

target_sources(hello_static
    PRIVATE
        src/hello.cpp
        src/internal.cpp
)

target_include_directories(hello_static
    PRIVATE
        src
    PUBLIC
        include
)

