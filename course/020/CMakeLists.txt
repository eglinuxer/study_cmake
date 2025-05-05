cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

project(topLevel)

message("Top level:")
message("  PROJECT_SOURCE_DIR  = ${PROJECT_SOURCE_DIR}")
message("  topLevel_SOURCE_DIR = ${topLevel_SOURCE_DIR}")

add_subdirectory(child)