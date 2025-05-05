message(STATUS "PATH=$ENV{PATH}")
message("PATH=${PATH}")


set(ENV{PATH} "/usr/bin:$ENV{PATH}")
message(STATUS "PATH=$ENV{PATH}")