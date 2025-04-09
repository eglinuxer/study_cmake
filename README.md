# study_cmake
CMake 已经来到了 4.0 时代，让我们重学 CMake 吧！

## 开始使用 CMake

在这个部分，主要展示一些常用的 cmake 命令。

### cmake

- 配置和构建项目

    ```bash
    # 先进入项目顶级目录
    cmake -S <source tree> -B <build tree>
    cmake --build <build tree>
    ```

    - -S 指定源码目录
    - -B 指定构建目录

### ctest

### cpack

## CMake 基础语法

- 一个最小项目所必须的三个命令

    - 指定 CMake 最小版本
        - [cmake_minimum_required()](https://cmake.org/cmake/help/latest/command/cmake_minimum_required.html)
    - 定义项目
        - [project()](https://cmake.org/cmake/help/latest/command/project.html)

    - 定义目标
        - [add_executable()](https://cmake.org/cmake/help/latest/command/add_executable.html)
        - [add_library()](https://cmake.org/cmake/help/latest/command/add_library.html)
        - [add_custom_target()](https://cmake.org/cmake/help/latest/command/add_custom_target.html)

- [CMake 变量](<./readme/CMake 变量.md>)

- [CMake 逻辑判断及循环](<./readme/CMake 逻辑判断及循环.md>)

- [CMake 项目目录结构组织](<./readme/CMake 项目目录结构组织.md>)

## CMake 进阶
