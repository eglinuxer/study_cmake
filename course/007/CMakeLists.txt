cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

project(007)

add_subdirectory(sub)

message(STATUS "top A=${A}")
message(STATUS "top B=${B}")

function(test_007)
    set(C "ccc")
    message(STATUS "test_007 C=${C}")
    message(STATUS "test_007 A=${A}")
endfunction()

test_007()

message(STATUS "top C=${C}")

#-------------------------------------------
# message(STATUS "-------------------------------------------")

# set(x 1)

# block()
#     set(x 2)   # Shadows outer "x"
#     set(y 3)   # Local, not visible outside the block

#     message(STATUS "x=${x}")
#     message(STATUS "y=${y}")
# endblock()

# message(STATUS "top x=${x}")
# message(STATUS "top y=${y}")

# # Here, x still equals 1, y is not defined


message(STATUS "-------------------------------------------")
# set(x 1)
# set(y 3)

# block()
#     set(x 2 PARENT_SCOPE)
#     unset(y PARENT_SCOPE)
#     # x still has the value 1 here
#     # y still exists and has the value 3

#     message(STATUS "x=${x}")
#     message(STATUS "y=${y}")
# endblock()

# # x has the value 2 here and y is no longer defined

# message(STATUS "top x=${x}")
# message(STATUS "top y=${y}")


# set(x 1)
# set(z 5)

# block(PROPAGATE x z)
#     set(x 2) # Gets propagated back out to the outer "x"
#     set(y 3) # Local, not visible outside the block
#     unset(z) # Unsets the outer "z" too

#     message(STATUS "x=${x}")
#     message(STATUS "y=${y}")
#     message(STATUS "z=${z}")
# endblock()

# # Here, x equals 2, y and z are undefined

# message(STATUS "top x=${x}")
# message(STATUS "top y=${y}")
# message(STATUS "top z=${z}")

set(x 1)
set(z 5)

block(SCOPE_FOR VARIABLES PROPAGATE x z)
    set(x 2) # Gets propagated back out to the outer "x"
    set(y 3) # Local variable, not visible outside the block
    unset(z) # Unsets the outer "z" too
    message(STATUS "x=${x}")
    message(STATUS "y=${y}")
    message(STATUS "z=${z}")
endblock()

# Here, x equals 2, y and z are undefined
message(STATUS "top x=${x}")
message(STATUS "top y=${y}")
message(STATUS "top z=${z}")