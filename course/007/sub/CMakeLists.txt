cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

set(A "aaaaa" PARENT_SCOPE)
set(B "bbb")

message(STATUS "sub A=${A}")
message(STATUS "sub B=${B}")