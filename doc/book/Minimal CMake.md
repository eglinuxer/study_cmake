# Minimal CMake 读书笔记

# 序言

这部分，作者首先介绍了本书要讲的内容，然后引出为什么需要使用 CMake。

- 本书适合哪些人？
    - 学生
    - 经验丰富的 C/C++ 开发人员
    - 经验丰富的开发人员（其它语言）
    - 业余爱好者

- 本书配套源码仓库地址
    - https://github.com/PacktPublishing/Minimal-CMake

## 第 1 章 入门

- 在 Windows 上安装 CMake
- 在 MacOS 上安装 CMake
- 在 Linux（Ubuntu）上安装 CMake
- 安装 git
- 在 vscode 中设置 CMake C/C++ 开发环境

## 第 2 章 你好 CMake！

- 命令行使用 cmake

    ```bash
    # 配置生成阶段
    cmake -S . -B build
    # cmake [options] <path-to-source>
    # cmake [options] <path-to-existing-build>
    # cmake [options] -S <path-to-source> -B <path-to-build>
    
    # 编译阶段
    cmake --build build
    ```

    

- 第一个 CMakeLists.txt

    ```cmake
    cmake_minimum_required(VERSION 3.28)
    project(minimal-cmake LANGUAGES C)
    add_executable(${PROJECT_NAME})
    target_sources(${PROJECT_NAME} PRIVATE main.c)
    target_compile_features(${PROJECT_NAME} PRIVATE c_std_17)
    ```

    

- CMake 生成器

    - CMAKE_GENERATOR:INTERNAL=Unix Makefiles

        ```bash
        cmake -B build -G Ninja
        ```

- 构建类型

    ```bash
    cmake -B build -DCMAKE_BUILD_TYPE=Debug
    ```

- GLOB（有效搜索）

    ```cmake
    file(GLOB sources CONFIGURE_DEPENDS *.c)
    target_sources(foobar PRIVATE ${sources})
    ```

    - 不建议这样做，虽然很方便，但是很容易出问题
        - 编译不想编译的文件
        - 性能可能受到影响

## 第 3 章 使用 FetchContent 引入外部依赖

```cmake
include(FetchContent)
FetchContent_Declare(
    timer_lib
    GIT_REPOSITORY https://github.com/pr0g/timer_lib.git
    GIT_TAG v1.0
)
FetchContent_MakeAvailable(timer_lib)

target_link_libraries(${PROJECT_NAME} PRIVATE timer_lib)
```

- 导入自己编写的 CMake module

    ```cmake
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
    
    include(CMakeHelpers)
    ```

## 第 4 章 为 FetchContent 创建库

