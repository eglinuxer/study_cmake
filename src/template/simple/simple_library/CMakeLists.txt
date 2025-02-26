cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

project(simple_library
    VERSION         1.0.0
    DESCRIPTION     "A simple C++ project to demonstrate creating executables and libraries in CMake"
    LANGUAGES       CXX
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_library(hello)
add_library(hello::hello ALIAS hello)

target_sources(hello
    PRIVATE
        src/hello.cpp
)

target_include_directories(hello
    PRIVATE
        src
    PUBLIC
        include
)
