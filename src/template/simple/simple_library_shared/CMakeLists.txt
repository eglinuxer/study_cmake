cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

project(simple_library_shared
    VERSION         1.0.0
    DESCRIPTION     "A simple C++ project to demonstrate creating executables and libraries in CMake"
    LANGUAGES       CXX
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_library(hello_shared SHARED)

set_target_properties(hello_shared
    PROPERTIES
        OUTPUT_NAME hello
)


set_target_properties(hello_shared
    PROPERTIES
        VERSION ${PROJECT_VERSION}
        SOVERSION ${PROJECT_VERSION_MAJOR}
)

target_sources(hello_shared
    PRIVATE
        src/hello.cpp
        src/internal.cpp
)

target_include_directories(hello_shared
    PRIVATE
        src
    PUBLIC
        include
)

include(GenerateExportHeader)
set_property(
    TARGET
        hello_shared
    PROPERTY
        CXX_VISIBILITY_PRESET "hidden"
)

set_property(
    TARGET
        hello_shared
    PROPERTY
        VISIBILITY_INLINES_HIDDEN TRUE
)

generate_export_header(hello_shared
    EXPORT_FILE_NAME
        export/hello/export_hello.h
)

target_include_directories(hello_shared
    PUBLIC
        "${CMAKE_CURRENT_BINARY_DIR}/export"
)

