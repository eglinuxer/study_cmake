cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

project(study_cmake
    VERSION         1.0.0
    DESCRIPTION     "Study CMake 4.0"
    HOMEPAGE_URL    "https://github.com/eglinuxer/study_cmake"
    LANGUAGES       CXX
)

set(CMAKE_EXPORT_COMPILE_COMMANDS       ON)

# cmake --log-context
list(APPEND CMAKE_MESSAGE_CONTEXT "${CMAKE_PROJECT_NAME}")

if(NOT PROJECT_IS_TOP_LEVEL)
    message(FATAL_ERROR "The ${CMAKE_PROJECT_NAME} project is intended to be a standalone, top-level project. Do not vendor this directory.")
endif()

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(FATAL_ERROR "In-source builds are not allowed")
endif()

include (TestBigEndian)
test_big_endian(IS_BIG_ENDIAN)

if(IS_BIG_ENDIAN)
    message(STATUS "BIG_ENDIAN")
else()
    message(STATUS "LITTLE_ENDIAN")
endif()

# Check if the current generator is a multi-configuration generator or not
get_property(IsMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

if(IsMultiConfig)
    message(STATUS "Configuring for [${CMAKE_CONFIGURATION_TYPES}]")
else()
    set(AllowedBuildTypes Debug Release RelWithDebugInfo MinSizeRel)
    set_property(
        CACHE CMAKE_BUILD_TYPE
        PROPERTY STRINGS "${AllowedBuildTypes}"
    )

    # if the build type is not set force it to debug
    if(NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE Debug CACHE STRING "" FORCE)
    elseif(NOT CMAKE_BUILD_TYPE IN_LIST AllowedBuildTypes)
        message(FATAL_ERROR "Unknown build type: ${CMAKE_BUILD_TYPE}")
    endif()
endif()

message(STATUS "Configuring on/for [${CMAKE_SYSTEM_NAME}]")
message(STATUS "Current build type is [${CMAKE_BUILD_TYPE}]")

set(CMAKE_CXX_STANDARD                  20)
set(CMAKE_CXX_STANDARD_REQUIRED         ON)
set(CMAKE_CXX_EXTENSIONS                OFF)

add_subdirectory(src)

if(PROJECT_IS_TOP_LEVEL)
    add_subdirectory(tests)
    add_subdirectory(packaging)
endif()
