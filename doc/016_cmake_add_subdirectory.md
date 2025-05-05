# 第 016 讲：如何使用子目录
- [第 016 讲：如何使用子目录](#第-016-讲如何使用子目录)

如果项目很小的话，我们将所有的源码文件都放在一个目录里面是没有问题的，但当项目变得越来越大，越来越复杂的时候，如果还是把所有源码都放在一个目录里面是不太现实的。

大多数真实的项目往往都不是 demo 级别的，都需要使用目录结构来管理项目的源码。将项目文件放在不同的目录中，这就会影响到 CMake 管理的构建系统。

CMake 提供了两个命令来解决多级目录的问题，它们分别是 ```add_subdirectory()``` 和 ```include()```。本讲我们主要介绍 ```add_subdirectory()```。

```add_subdirectory()``` 将另一个目录引入构建系统，通过 ```add_subdirectory()``` 引入一个新的目录，这个新的目录中必须有它自己的 CMakeLists.txt 文件。

```add_subdirectory()``` 的格式如下：
```cmake
add_subdirectory(sourceDir [binaryDir] [EXCLUDE_FROM_ALL] [SYSTEM])
# [SYSTEM] 需要 CMake >= 3.25
```
sourceDir 通常是当前 CMakeLists.txt 所在目录的子目录，但是它也可以是其它路径下的目录。可以指定绝对路径或者相对路径，如果是相对路径的话，是相对于当前目录的。

通常 binaryDir 不需要指定，不指定的情况下，CMake 会在构建目录中对应的位置创建和源码目录对应的目录，用于存放构建输出。但是当 sourceDir 是源外路径的话，binaryDir 需要明确指定。

CMake 管理的项目默认会生成一个叫做 ALL 的目标，当使用 ```cmake --build build``` 命令进行构建的时候，默认构建的就是这个目标，通常这个目标会依赖其它所有 CMake 命令定义的目标，但是在使用 ```add_subdirectory()``` 命令引入新的目录的时候，我们可以使用 EXCLUDE_FROM_ALL 关键字，将这个目录从 ALL 目标中排除，这样这个目录中定义的目标就不会是 ALL 目标的依赖，构建 ALL 目标的时候就不会构建这个目录中定义的目标。

但是非常的不幸，对于某些 CMake 版本和生成器，EXCLUDE_FROM_ALL 的行为并不符合预期，所以建议在 ```add_subdirectory()``` 命令引入新目录的时候不要使用 EXCLUDE_FROM_ALL 关键字，我们后面会讲其它替代方案。

SYSTEM 关键字我们在后面在讲系统头文件搜索路径的时候会讲，本讲不要使用这个关键字。

有时候开发人员需要知道与当前源代码目录对应的构建目录的位置，例如在复制运行时需要的文件或执行自定义构建任务时。通过 ```add_subdirectory()``` 命令，源代码和构建树的目录结构都可以任意复杂。

甚至可能有多个使用相同源代码树的构建树。因此，开发人员需要一些 CMake 的帮助来确定感兴趣的目录。为此，CMake 提供了一些变量来跟踪当前正在处理的 CMakeLists.txt 文件的源和二进制目录。以下是一些只读变量，随着每个文件被 CMake 处理，这些变量会自动更新。它们始终包含绝对路径。

- CMAKE_SOURCE_DIR
    - 源代码的最顶级目录（即最顶级 CMakeLists.txt 文件所在的位置）。这个变量的值永远不会改变。
- CMAKE_BINARY_DIR
    - 构建目录的最顶级目录。这个变量的值永远不会改变。
- CMAKE_CURRENT_SOURCE_DIR
    - 当前正在被 CMake 处理的 CMakeLists.txt 文件所在的目录。每当由 ```add_subdirectory()``` 调用处理新文件时，它都会更新，当处理该目录完成时，它会被还原回原来的值。
- CMAKE_CURRENT_BINARY_DIR
    - 由 CMake 处理的当前 CMakeLists.txt 文件所对应的构建目录。每次调用 ```add_subdirectory()``` 时都会更改该目录，当 ```add_subdirectory()``` 返回时将其恢复。

为了弄明白上面所说的，我们来看一个例子：
- 定义 CMakeLists.txt
    ```cmake
    cmake_minimum_required(VERSION 3.26)

    project(MyApp)

    message("top: CMAKE_SOURCE_DIR              = ${CMAKE_SOURCE_DIR}")
    message("top: CMAKE_BINARY_DIR              = ${CMAKE_BINARY_DIR}")
    message("top: CMAKE_CURRENT_SOURCE_DIR      = ${CMAKE_CURRENT_SOURCE_DIR}")
    message("top: CMAKE_CURRENT_BINARY_DIR      = ${CMAKE_CURRENT_BINARY_DIR}")

    add_subdirectory(subdir)

    message("top: CMAKE_CURRENT_SOURCE_DIR      = ${CMAKE_CURRENT_SOURCE_DIR}")
    message("top: CMAKE_CURRENT_BINARY_DIR      = ${CMAKE_CURRENT_BINARY_DIR}")
    ```

- subdir/CMakeLists.txt
    ```cmake
    message("mysub: CMAKE_SOURCE_DIR            = ${CMAKE_SOURCE_DIR}")
    message("mysub: CMAKE_BINARY_DIR            = ${CMAKE_BINARY_DIR}")
    message("mysub: CMAKE_CURRENT_SOURCE_DIR    = ${CMAKE_CURRENT_SOURCE_DIR}")
    message("mysub: CMAKE_CURRENT_BINARY_DIR    = ${CMAKE_CURRENT_BINARY_DIR}")
    ```

好了，通过本讲的学习，我们知道了 ```add_subdirectory()``` 的作用以及它会影响到相关的 CMake 内置变量的值，这对后续我们在真实的项目中使用 ```add_subdirectory()``` 非常有用。希望大家多多理解上面列出的这些变量，到了真实的项目中会非常的有用。