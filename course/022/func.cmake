cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

function(print_me)
    message("Hello from inside a function")
    message("All done")
endfunction()

macro(test_macro)
    message("Hello from inside a function")
    message("All done")
endmacro()


# Called like so:
print_me()

message("-------------")

test_macro()