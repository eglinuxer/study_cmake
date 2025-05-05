cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

#[[
ON、YES、TRUE、Y 视为真
OFF、NO、FALSE、N、IGNORE、NOTFOUND、空字符串、以 -NOTFOUND 结尾的字符串被视为假。
]]

if(ON)
    message(STATUS "xxx这里执行到了")
else()
    message(STATUS "yyy这里执行到了")
endif()

message(STATUS "-----------------------")

if(OFF)
    message(STATUS "xxx这里执行到了")
else()
    message(STATUS "yyy这里执行到了")
endif()

message(STATUS "-----------------------")

if(-5)
    message(STATUS "xxx这里执行到了")
else()
    message(STATUS "yyy这里执行到了")
endif()

message(STATUS "-----------------------")

if("Y")
    message(STATUS "xxx这里执行到了")
else()
    message(STATUS "yyy这里执行到了")
endif()

message(STATUS "----------$ENV{PATH}-------------")

if($ENV{PATH})
    message(STATUS "xxx这里执行到了")
else()
    message(STATUS "yyy这里执行到了")
endif()


#[[
# Logical operators
if(NOT expression)
if(expression1 AND expression2)
if(expression1 OR expression2)

# Example with parentheses
if(NOT (expression1 AND (expression2 OR expression3)))
]]

message(STATUS "-----------------------")

if(NOT OFF)
    message(STATUS "xxx这里执行到了")
else()
    message(STATUS "yyy这里执行到了")
endif()

message(STATUS "-----------------------")

if(1 AND -5)
    message(STATUS "xxx这里执行到了")
else()
    message(STATUS "yyy这里执行到了")
endif()


message(STATUS "-----------------------")

if(OFF OR 1)
    message(STATUS "xxx这里执行到了")
else()
    message(STATUS "yyy这里执行到了")
endif()

message(STATUS "-----------------------")

if(NOT (ON AND (OFF OR 0)))
    message(STATUS "xxx这里执行到了")
else()
    message(STATUS "yyy这里执行到了")
endif()


message(STATUS "-----------------------")

if(1 GREATER 5)
    message(STATUS "xxx这里执行到了")
else()
    message(STATUS "yyy这里执行到了")
endif()

message(STATUS "-----------------------")

set(who "Fred")

if("Hi from ${who}" MATCHES "Hi from (Fred|Barney).*")
	message(STATUS "${CMAKE_MATCH_1} says hello")
else()
    message(STATUS "-----这里执行到了")
endif()

message(STATUS "-----------------------")
set(firstFile "/Users/eg/workspace/code/eglinux/study_cmake/course/012/if.cmake")
set(secondFile "/Users/eg/workspace/code/eglinux/study_cmake/course/012/test.txt")

if(NOT EXISTS ${firstFile})
    message(FATAL_ERROR "${firstFile} is missing")
elseif((NOT EXISTS ${secondFile}) OR (NOT ${secondFile} IS_NEWER_THAN ${firstFile}))
    message(STATUS "-----这里执行到了")
endif()

# WARNING: Very likely to be wrong
if(NOT ${firstFile} IS_NEWER_THAN ${firstFile})
    message(STATUS "---xxx--这里执行到了")
endif()

#[[
if(DEFINED name)
if(COMMAND name)
if(POLICY name)
if(TARGET name)
if(TEST name)               # Available since CMake 3.4
if(value IN_LIST listVar)   # Available since CMake 3.3


if(DEFINED SOMEVAR)           # Checks for a CMake variable (regular or cache)
if(DEFINED CACHE{SOMEVAR})    # Checks for a CMake cache variable
if(DEFINED ENV{SOMEVAR})      # Checks for an environment variable
]]

message(STATUS "-----------------------")
set(MYVAR "")
if(DEFINED MYVAR)
    message(STATUS "-----这里执行到了")
else()
    message(STATUS "---xxx--这里执行到了")
endif()