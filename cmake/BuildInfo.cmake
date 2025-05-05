cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

macro(GenerateBuildInfo info_in info_out)
    set(BUILDINFO_TEMPLATE_DIR ${CMAKE_CURRENT_LIST_DIR})
    set(DESTINATION "${info_out}")

    string(TIMESTAMP TIMESTAMP)
    find_program(GIT_PATH git REQUIRED)
    execute_process(
        COMMAND
            ${GIT_PATH} log --pretty=format:%H -n 1
        OUTPUT_VARIABLE
            COMMIT_SHA
    )

    execute_process(
        COMMAND
            ${GIT_PATH} branch --show-current
        OUTPUT_VARIABLE
            GIT_BRANCH
    )

    string(STRIP ${GIT_BRANCH} GIT_BRANCH)

    message(STATUS "generate ${info_out}")
    configure_file(
        "${info_in}"
        "${info_out}" @ONLY
    )
endmacro()
