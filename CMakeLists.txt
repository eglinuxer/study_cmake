cmake_minimum_required(VERSION 4.0)

project(study_cmake
    VERSION         1.0.0
    DESCRIPTION     "Study CMake 4.0"
    HOMEPAGE_URL    "https://github.com/eglinuxer/study_cmake"
    LANGUAGES       CXX
)

set(CMAKE_EXPORT_COMPILE_COMMANDS       ON)

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    message(STATUS "Configuring on/for Linux")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    message(STATUS "Configuring on/for macOS")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "Configuring on/for Windows")
elseif(CMAKE_SYSTEM_NAME STREQUAL "AIX")
    message(STATUS "Configuring on/for IBM AIX")
else()
    message(STATUS "Configuring on/for ${CMAKE_SYSTEM_NAME}")
endif()
