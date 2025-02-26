cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

project(hello_object
    VERSION         1.0.0
    DESCRIPTION     "A simple C++ project to demonstrate creating executables and libraries in CMake"
    LANGUAGES       CXX
)

add_library(hello_object OBJECT)

target_sources(hello_object
    PRIVATE
        src/hello_object.cpp
)

target_include_directories(hello_object
    PRIVATE
        src
    PUBLIC
        include
)
