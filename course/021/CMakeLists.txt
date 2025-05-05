cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

project(021)

set(x 1)
set(y 2)

message(STATUS "TOP before: x = [${x}]")
message(STATUS "TOP before: y = [${y}]")

# block()
    add_subdirectory(subdir)
    # message(STATUS "TOP after return: x = [${x}]")
    # message(STATUS "TOP after return: y = [${y}]")
# endblock()
# include(test_include.cmake)

message(STATUS "TOP after: x = [${x}]")
message(STATUS "TOP after: y = [${y}]")

# Here, x will have the value 3 and y will be unset