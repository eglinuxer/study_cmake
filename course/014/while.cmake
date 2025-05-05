cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

set(num 10)

while(num GREATER 0)
    message(STATUS "current num = ${num}")
    math(EXPR num "${num} - 1")
endwhile()