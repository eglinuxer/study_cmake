cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

project(019)

message("topdir CMAKE_CURRENT_SOURCE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}")
message("topdir CMAKE_CURRENT_BINARY_DIR = ${CMAKE_CURRENT_BINARY_DIR}")

message("topdir CMAKE_CURRENT_LIST_DIR   = ${CMAKE_CURRENT_LIST_DIR}")
message("topdir CMAKE_CURRENT_LIST_FILE  = ${CMAKE_CURRENT_LIST_FILE}")
message("topdir CMAKE_CURRENT_LIST_LINE  = ${CMAKE_CURRENT_LIST_LINE}")

message("-------------------------------------")

add_subdirectory(subdir)

message("-------------------------------------")

include(cmake/test.cmake)