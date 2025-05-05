cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

project(project017
    VERSION 0.0.1
    LANGUAGES CXX
    DESCRIPTION "project demo"
    HOMEPAGE_URL "eglinux.com"
)


set(myVar foo)

message("Parent (before): myVar    = ${myVar}")
message("Parent (before): childVar = ${childVar}")

add_subdirectory(subdir)

message("Parent (after):  myVar    = ${myVar}")
message("Parent (after):  childVar = ${childVar}")