cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

project(header_only
    VERSION         1.0.0
    DESCRIPTION     "A header only CMake project example"
    HOMEPAGE_URL    "https://github.com/eglinuxer/study_cmake/src/example/header_only"
    LANGUAGES       CXX
)

set(CMAKE_EXPORT_COMPILE_COMMANDS       ON)

# cmake --log-context
list(APPEND CMAKE_MESSAGE_CONTEXT "${CMAKE_PROJECT_NAME}")

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(FATAL_ERROR "In-source builds are not allowed")
endif()

include(GNUInstallDirs)
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

option(header_only_SystemInclude        "Include as system headers (skip for clang-tidy)." OFF)

if (header_only_SystemInclude)
    set(EGLINUX_HEADER_ONLY_SYSTEM_INCLUDE "SYSTEM")
endif()

add_library(header_only INTERFACE)
add_library(eglinux::header_only ALIAS header_only)

target_include_directories(header_only ${EGLINUX_HEADER_ONLY_SYSTEM_INCLUDE}
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Install a pkg-config file, so other tools can find this.
CONFIGURE_FILE(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/pkg-config.pc.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc"
    @ONLY
)

include(CMakePackageConfigHelpers)

write_basic_package_version_file(
    "header_only-config-version.cmake"
    COMPATIBILITY SameMajorVersion
)

install(
    DIRECTORY
        ${CMAKE_CURRENT_SOURCE_DIR}/include/
    DESTINATION
        ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/header_only-config-version.cmake
    DESTINATION
        ${CMAKE_INSTALL_DATADIR}/cmake/${PROJECT_NAME}
)

install(
    TARGETS
       header_only 
    EXPORT
        header_only_export
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
    EXPORT
        header_only_export
    FILE
        header_only-config.cmake
    NAMESPACE
        eglinux::
    DESTINATION
        ${CMAKE_INSTALL_DATADIR}/cmake/${PROJECT_NAME}
)

install(
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc
    DESTINATION
        ${CMAKE_INSTALL_DATADIR}/pkgconfig
)

if(PROJECT_IS_TOP_LEVEL)
    add_subdirectory(tests)
    add_subdirectory(packaging)
endif()
