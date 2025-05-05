cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

add_subdirectory(study)

add_executable(main)
target_sources(main
    PRIVATE
        main.cpp
)

target_link_libraries(main
    PRIVATE
        study
        nlohmann_json::nlohmann_json
)

install(TARGETS main
    RUNTIME
        DESTINATION
            ${CMAKE_INSTALL_BINDIR}
)