cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

project(hello_header_only
    VERSION         1.0.0
    DESCRIPTION     "A header only example"
    LANGUAGES       CXX
)

add_library(hello_header_only INTERFACE)

target_include_directories(hello_header_only
    INTERFACE
        include
)

