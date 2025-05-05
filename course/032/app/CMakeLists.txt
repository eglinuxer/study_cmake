cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

get_directory_property(LIB_VERSION_DEFINITION DIRECTORY "${CMAKE_SOURCE_DIR}/lib" DEFINITION LIB_VERSION)

message("Library version: ${LIB_VERSION_DEFINITION}")