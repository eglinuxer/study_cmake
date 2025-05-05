# This ensures that we have a version of CMake that supports
# PROPAGATE and that the CMP0140 policy is set to NEW.

cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

message(STATUS "sub before: x = [${x}]")
message(STATUS "sub before: y = [${y}]")
block()
    set(x 3)
    unset(y)

    message(STATUS "sub after: x = [${x}]")
    message(STATUS "sub after: y = [${y}]")

    return(PROPAGATE x y)
endblock()


message(STATUS "sub after return: x = [${x}]")
message(STATUS "sub after return: y = [${y}]")