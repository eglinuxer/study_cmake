cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

add_library(study)

message(STATUS "generate ${CMAKE_CURRENT_BINARY_DIR}/study_export.h")
generate_export_header(study)

set_target_properties(study
    PROPERTIES
        VERSION
            ${PROJECT_VERSION}
        SOVERSION
            ${PROJECT_VERSION_MAJOR}
)

target_sources(study
    PRIVATE
        add.cpp
)

target_include_directories(study
    PUBLIC
        ${CMAKE_CURRENT_BINARY_DIR}
        ${CMAKE_CURRENT_LIST_DIR}/include
)

install(TARGETS study
    LIBRARY
        DESTINATION
            ${CMAKE_INSTALL_LIBDIR}
)

install(FILES ${CMAKE_CURRENT_LIST_DIR}/include/add.h ${CMAKE_CURRENT_BINARY_DIR}/study_export.h
    DESTINATION
        ${CMAKE_INSTALL_INCLUDEDIR}
)