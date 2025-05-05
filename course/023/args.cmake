cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

function(func arg)
    if(DEFINED arg)
        message("Function arg is a defined variable")
    else()
        message("Function arg is NOT a defined variable")
    endif()
endfunction()

macro(macr arg)
    if(DEFINED arg)
        message("Macro arg is a defined variable")
    else()
        message("Macro arg is NOT a defined variable")
    endif()
endmacro()

func(foobar)
macr(foobar)

message("--------------------")

function(func myArg)
    message("myArg = ${myArg}")
endfunction()

macro(macr myArg)
    message("myArg = ${myArg}")
endmacro()

func(foobar)
macr(foo+bar)


message("--------------------")

# WARNING: This macro is misleading
macro(dangerous)
    # Which ARGN?
    foreach(arg IN LISTS ARGN)
        message("Argument: ${arg}")
    endforeach()
endmacro()

function(func)
    dangerous(1 2)
endfunction()

func(3)

message("--------------------")

function(func)
    # Now it is clear, ARGN here will use the arguments from func
    foreach(arg IN LISTS ARGN)
        message("Argument: ${arg}")
    endforeach()
endfunction()

func(3)


message("--------------------")

function(dangerous1)
    # Which ARGN?
    foreach(arg IN LISTS ARGN)
        message("Argument: ${arg}")
    endforeach()
endfunction()

function(func1)
    dangerous1(1 2)
endfunction()

func1(3)

message("--------------------")


function(func2)
    # Define the supported set of keywords
    set(prefix ARG)
    set(noValues ENABLE_NET COOL_STUFF)
    set(singleValues TARGET)
    set(multiValues SOURCES IMAGES)
    
    # Process the arguments passed in
    # include(CMakeParseArguments)
    # cmake_parse_arguments(
    #     ${prefix}
    #     "${noValues}" "${singleValues}" "${multiValues}"
    #     ${ARGN}
    # )

    cmake_parse_arguments(
        PARSE_ARGV 0
        ${prefix}
        "${noValues}" "${singleValues}" "${multiValues}"
    )
    
    # Log details for each supported keyword
    message("Option summary:")
    
    foreach(arg IN LISTS noValues)
        if(${prefix}_${arg})
            message(" ${arg} enabled")
        else()
            message(" ${arg} disabled")
        endif()
    endforeach()
    
    foreach(arg IN LISTS singleValues multiValues)
        # Single argument values will print as a string
        # Multiple argument values will print as a list
        message(" ${arg} = ${${prefix}_${arg}}")
    endforeach()
endfunction()

# Examples of calling with different combinations
# of keyword arguments

func2(SOURCES foo.cpp bar.cpp
    TARGET MyApp
    ENABLE_NET
)

func2(COOL_STUFF
    TARGET dummy
    IMAGES here.png there.png gone.png
)

message("--------------------")

function(demoArgs)
    set(noValues "")
    set(singleValues SPECIAL)
    set(multiValues EXTRAS)
    
    # cmake_parse_arguments(
    #     PARSE_ARGV 0
    #     ARG
    #     "${noValues}" "${singleValues}" "${multiValues}"
    # )

    include(CMakeParseArguments)
    cmake_parse_arguments(
        ARG
        "${noValues}" "${singleValues}" "${multiValues}"
        ${ARGN}
    )
    
    message("Left-over args: ${ARG_UNPARSED_ARGUMENTS}")
    
    foreach(arg IN LISTS ARG_UNPARSED_ARGUMENTS)
        message("${arg}")
    endforeach()
endfunction()

demoArgs(burger fries "cheese;tomato" SPECIAL secretSauce)

message("--------------------")

function(demoArgs1)
    set(noValues "")
    set(singleValues SPECIAL)
    set(multiValues ORDINARY EXTRAS)
    
    cmake_parse_arguments(
        PARSE_ARGV 0
        ARG
        "${noValues}" "${singleValues}" "${multiValues}"
    )
    
    message("Keywords missing values: ${ARG_KEYWORDS_MISSING_VALUES}")
endfunction()

demoArgs1(burger fries SPECIAL ORDINARY EXTRAS high low)


message("--------------------")

function(libWithTest)
    # First level of arguments
    set(groups LIB TEST)
    cmake_parse_arguments(GRP "" "" "${groups}" ${ARGN})
    
    # Second level of arguments
    set(args SOURCES PRIVATE_LIBS PUBLIC_LIBS)
    cmake_parse_arguments(LIB "" "TARGET" "${args}" ${GRP_LIB})
    cmake_parse_arguments(TEST "" "TARGET" "${args}" ${GRP_TEST})
    
    add_library(${LIB_TARGET} ${LIB_SOURCES})
    target_link_libraries(${LIB_TARGET}
        PUBLIC ${LIB_PUBLIC_LIBS}
        PRIVATE ${LIB_PRIVATE_LIBS}
    )
    
    add_executable(${TEST_TARGET} ${TEST_SOURCES})
    target_link_libraries(${TEST_TARGET}
        PUBLIC ${TEST_PUBLIC_LIBS}
        PRIVATE ${LIB_TARGET} ${TEST_PRIVATE_LIBS}
    )
endfunction()

libWithTest(
    LIB
        TARGET Algo
        SOURCES algo.cpp algo.h
        PUBLIC_LIBS SomeMathHelpers
    TEST
        TARGET AlgoTest
        SOURCES algoTest.cpp
        PRIVATE_LIBS gtest_main
)