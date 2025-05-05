cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

project(test)

# option(test "test" OFF)


set(test OFF CACHE BOOL "test" FORCE)

set(test ON)

message(STATUS "test=${test}")

message(STATUS "----------------------------")


message(STATUS "foo=<${foo}>")
unset(foo)
message(STATUS "foo=<${foo}>")
set(foo)
message(STATUS "foo=<${foo}>")
set(foo "")
message(STATUS "foo=<${foo}>")

message(STATUS "----------------------------")
message(STATUS "myVar=${myVar}")

message(STATUS "----------------------------")

set(TEMP_PATH "/tmp" CACHE PATH "tmp path")
message(STATUS "TEMP_PATH=${TEMP_PATH}")
mark_as_advanced(TEMP_PATH)

message(STATUS "----------------------------")

set(myVar HiThere)
message("The value of myVar = ${myVar}\nAnd this "
"appears on the next line")