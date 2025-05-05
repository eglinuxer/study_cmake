cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

set(myProjTraceCall [=[
    message("Called ${CMAKE_CURRENT_FUNCTION}")
    set(__x 0)
    while(__x LESS ${ARGC})
        message(" ARGV${__x} = ${ARGV${__x}}")
        math(EXPR __x "${__x} + 1")
    endwhile()
    unset(__x)
]=])

function(func)
    cmake_language(EVAL CODE "${myProjTraceCall}")
    # ...
endfunction()
    
func(one two three)