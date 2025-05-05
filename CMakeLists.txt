cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

project(study_cmake
    VERSION         0.0.1
    DESCRIPTION     "Eglinux's cmake study repo"
    HOMEPAGE_URL    "公众号: eglinux"
    LANGUAGES       CXX
)

list(APPEND CMAKE_MESSAGE_CONTEXT       "study_cmake")
list(APPEND CMAKE_MODULE_PATH           "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(CMAKE_EXPORT_COMPILE_COMMANDS       ON)
set(STUDY_CMAKE_TOP_SOURCE_DIR          ${CMAKE_CURRENT_SOURCE_DIR})
set(STUDY_CMAKE_TOP_BINARY_DIR          ${CMAKE_CURRENT_BINARY_DIR})

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR AND NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(FATAL_ERROR
      "\n"
      "In-source builds are not allowed.\n"
      "Instead, provide a path to build tree like so:\n"
      "cmake -S . -B <destination>\n"
      "\n"
      "To remove files you accidentally created execute:\n"
      "please delete CMakeFiles and CMakeCache.txt\n"
    )
endif()

set(CMAKE_CXX_STANDARD              20 )
set(CMAKE_CXX_STANDARD_REQUIRED     ON )
set(CMAKE_CXX_EXTENSIONS            OFF)
set(CMAKE_CXX_VISIBILITY_PRESET     hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)
set(CMAKE_INSTALL_RPATH             $ORIGIN $ORIGIN/../lib)
set(CMAKE_INSTALL_PREFIX            "/usr/local")

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    message(STATUS "Configuring on/for Linux")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    message(STATUS "Configuring on/for macOS")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "Configuring on/for Windows")
else()
    message(STATUS "Configuring on/for ${CMAKE_SYSTEM_NAME}")
endif()

include (TestBigEndian)
test_big_endian(IS_BIG_ENDIAN)
if(IS_BIG_ENDIAN)
    message(STATUS "Configuring on/for BIG_ENDIAN")
else()
    message(STATUS "Configuring on/for LITTLE_ENDIAN")
endif()

include(GNUInstallDirs)
include(GenerateExportHeader)

include(BuildInfo)
GenerateBuildInfo(${CMAKE_CURRENT_LIST_DIR}/study_cmake_build_info.h.in ${CMAKE_CURRENT_BINARY_DIR}/study_cmake_build_info.h)

add_subdirectory(external)
add_subdirectory(src)
add_subdirectory(examples)

if(BUILD_TESTING AND PROJECT_IS_TOP_LEVEL)
    add_subdirectory(test)
endif()

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/study_cmake_build_info.h
    DESTINATION
        ${CMAKE_INSTALL_INCLUDEDIR}
)

add_subdirectory(packaging)
