cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

project(study_cmake
    VERSION     1.0.0
    DESCRIPTION "This is my cmake study project."
    HOMEPAGE_URL "www.eglinux.com/cmake/"
    LANGUAGES C CXX
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(src)
