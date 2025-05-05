cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

message("Child:")
message("  PROJECT_SOURCE_DIR (before) = ${PROJECT_SOURCE_DIR}")

project(child)

message("  PROJECT_SOURCE_DIR (after)  = ${PROJECT_SOURCE_DIR}")
message("  child_SOURCE_DIR            = ${child_SOURCE_DIR}")

add_subdirectory(grandchild)