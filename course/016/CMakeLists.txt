cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

project(project016
    VERSION 0.0.1
    LANGUAGES CXX
    DESCRIPTION "project demo"
    HOMEPAGE_URL "eglinux.com"
)


message("top: CMAKE_SOURCE_DIR              = ${CMAKE_SOURCE_DIR}")
message("top: CMAKE_BINARY_DIR              = ${CMAKE_BINARY_DIR}")
message("top: CMAKE_CURRENT_SOURCE_DIR      = ${CMAKE_CURRENT_SOURCE_DIR}")
message("top: CMAKE_CURRENT_BINARY_DIR      = ${CMAKE_CURRENT_BINARY_DIR}")


add_subdirectory(subdir)


message("top: CMAKE_CURRENT_SOURCE_DIR      = ${CMAKE_CURRENT_SOURCE_DIR}")
message("top: CMAKE_CURRENT_BINARY_DIR      = ${CMAKE_CURRENT_BINARY_DIR}")