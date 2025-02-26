cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

project(hello_world
    VERSION         1.0.0
    DESCRIPTION     "A simple C++ project to demonstrate creating a standalone executables"
    LANGUAGES       CXX
)

add_executable(hello_world)

target_sources(hello_world
    PRIVATE src/main.cpp
)
