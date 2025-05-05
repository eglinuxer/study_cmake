cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

include(FetchContent)
include(ExternalProject)

FetchContent_Declare(json
    URL             ${CMAKE_CURRENT_LIST_DIR}/tar/json-3.11.2.tar.gz
    URL_HASH        SHA256=d69f9deb6a75e2580465c6c4c5111b89c4dc2fa94e3a85fcd2ffcd9a143d9273
)
# target_link_libraries(<your-target> PRIVATE nlohmann_json::nlohmann_json)

FetchContent_Declare(gtest
    URL             ${CMAKE_CURRENT_LIST_DIR}/tar/googletest-1.13.0.tar.gz
    URL_HASH        SHA256=ad7fdba11ea011c1d925b3289cf4af2c66a352e18d4c7264392fead75e919363
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
# disable gtest install
set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(json gtest)