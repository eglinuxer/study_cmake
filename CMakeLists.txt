cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

project(study_cmake
    VERSION         0.0.1
    DESCRIPTION     "Eglinux's cmake study repo"
    HOMEPAGE_URL    "公众号: eglinux"
    LANGUAGES       CXX
)

# 可以在每个新的作用域添加，这样 cmake 运行的时候加上 --log-context 参数可以清晰的看到输出的日志属于哪个作用域
list(APPEND CMAKE_MESSAGE_CONTEXT study_cmake)

# 将编译命令导出，便于 debug
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 用新的变量记录该项目的顶级目录路径，如果本项目会被其他项目通过 external 的方式添加会非常有帮助
set(STUDY_CMAKE_TOP_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# 设置编译类型
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR AND NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# 禁止源内构建
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
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

# 设置全局 C++ 标准
set(CMAKE_CXX_STANDARD          20 )
set(CMAKE_CXX_STANDARD_REQUIRED ON )
set(CMAKE_CXX_EXTENSIONS        OFF)

# 如果编译器支持过程间优化（interprocedural optimization）则打开它
if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
    include(CheckIPOSupported)
    check_ipo_supported(RESULT ipo_supported)
    if(ipo_supported)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION True)
    endif()
endif()

add_subdirectory(src)