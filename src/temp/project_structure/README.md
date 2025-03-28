# 项目结构

开始一个新的项目的时候，一定要先想好，项目现在以及将来是要作为单独的项目使用还是会依赖其他项目或者被其他项目依赖。想好这个问题后，就可以选择使用 CMake 的哪种项目结构组织项目了。

## 超级构建

- 依赖的项目没有使用 CMake 管理构建系统

    - 超级构建自己构建所有依赖项，并管理构建顺序

        - 使用 [ExternalProject](https://cmake.org/cmake/help/latest/module/ExternalProject.html) 引入依赖项目

        ```cmake
        cmake_minimum_required(VERSION 4.0 FATAL_ERROR)
        
        project(SuperbuildExample)
        
        include(ExternalProject)
        
        set(install_dir ${CMAKE_CURRENT_BINARY_DIR}/install)
        
        ExternalProject_Add(someDep1
            ...
            INSTALL_DIR ${install_dir}
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        )
        
        ExternalProject_Add(someDep2
            ...
            INSTALL_DIR ${install_dir}
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            -DCMAKE_PREFIX_PATH:PATH=<INSTALL_DIR>
        )
        
        ExternalProject_Add_StepDependencies(someDep2 configure someDep1)
        
        ExternalProject_Add(someDep3
            INSTALL_DIR ${install_dir}
            CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix <INSTALL_DIR>
            ...
        )
        ```

- 如果有打包需求，可以参照 [ExternalProject_Add_Step](https://cmake.org/cmake/help/latest/module/ExternalProject.html#explicit-step-management)

## 非超级构建

- 参考顶级目录的 CMakeLists.txt

## IDE 项目

```cmake
# CMake 3.26 set USE_FOLDERS to YES default
set_property(GLOBAL PROPERTY USE_FOLDERS YES)

add_executable(Foo ...)
add_executable(Bar ...)
add_executable(test_Foo ...)
add_executable(test_Bar ...)

set_target_properties(Foo Bar PROPERTIES FOLDER "Main apps")
set_target_properties(test_Foo test_Bar PROPERTIES FOLDER "Main apps/Tests")
```

- CMake 3.12 前，FOLDER 默认值为空，从 CMake 3.12 开始，从 CMAKE_FOLDER 取值

