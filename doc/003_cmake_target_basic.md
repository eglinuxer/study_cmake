# 第 003 讲：CMake Targets 入门：CMake 如何构建简单的 Target

- [第 003 讲：CMake Targets 入门：CMake 如何构建简单的 Target](#第-003-讲cmake-targets-入门cmake-如何构建简单的-target)
  - [1、add\_executable()](#1add_executable)
  - [2、add\_library()](#2add_library)
  - [3、add\_custom\_target()](#3add_custom_target)
  - [4、关于 Target 链接](#4关于-target-链接)
  - [5、最佳实践](#5最佳实践)

要我说一种现代 CMake 最核心的特性，当属 Target。现代 CMake 围绕着 Target 这一核心特性组织 C/C++ 项目的结构，管理其配置、编译、单元测试、打包等。

CMake 有三个基本命令，用于定义 CMake Target，它们分别是：

- add_executable()
- add_library()
- add_custom_target()

下面我分别介绍这三条命令的用途和用法。

## 1、add_executable()

```cmake
add_executable(<name> [WIN32] [MACOSX_BUNDLE]
    [EXCLUDE_FROM_ALL]
    [source1] [source2 ...]
)
```

该命令用于定义一个可以构建成可执行程序的 Target。

第一个参数是 Target 的名字，这个参数必须提供。

第二个参数 WIN32 是可选参数，Windows 平台特定的参数，现在你不用管它的意思，不要使用它即可。后续我们需要使用到它的时候会说明其含义。

第三个参数 MACOSX_BUNDLE 同第二个参数，是 Apple 平台的特定参数，先忽略。

第四个参数 EXCLUDE_FROM_ALL 如果存在，那 CMake 默认构建的时候就不会构建这个 Target。

后续可选参数均为构建该可执行文件所需的源码，在这里可以省略，通过其他命令单独指定源码。但是对于入门，我们直接在这里指定源码文件即可。

下面是一个例子：

```cmake
cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

add_executable(main main.cpp)
```

参考：https://github.com/eglinuxer/test/blob/main/src/CMakeLists.txt

上面的例子，我们定义了一个编译成可执行程序的 Target，名字为 main，其源码只有一个 main.cpp。

## 2、add_library()

```cmake

add_library(<name> [STATIC | SHARED | MODULE]
    [EXCLUDE_FROM_ALL]
    [<source>...]
)
```

签名和 add_executable() 非常相似，该命令用于定义构建成库文件的 Target。

这里只讲差异，add_library() 命令支持可选的三个互斥参数：STATIC | SHARED | MODULE。

这三个参数要么都没有，要么只能有一个。对于简单的例子，我们可以指定构建库为 STATIC（静态库）、SHARED（动态库）、MODULE（类似于动态库，不过不会被其他库或者可执行程序链接，用于插件式框架的软件的插件构建）。

当然最佳实践是不要自己在 CMakeLists.txt 中指定这几个参数，而是把主动权交给构建者，通过 cmake -DBUILD_SHARED_LIBS=YES 的形式传值告诉其需要构建哪种库。这个现在不用管，忽略即可，后续更深入的课程会详细介绍。

看个例子：

```cmake
cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

add_library(study)


target_sources(study
    PRIVATE
        add.cpp
)

target_include_directories(study
    PUBLIC
        ${CMAKE_CURRENT_BINARY_DIR}
        ${CMAKE_CURRENT_LIST_DIR}/include
)
```

可以参考：https://github.com/eglinuxer/study_cmake/blob/main/src/study/CMakeLists.txt

参考链接的例子对于初学者看起来还很复杂，看不懂没关系，我们后面会详细介绍。

## 3、add_custom_target()

```cmake
add_custom_target(Name [ALL] [command1 [args1...]]
    [COMMAND command2 [args2...] ...]
    [DEPENDS depend depend depend ... ]
    [BYPRODUCTS [files...]]
    [WORKING_DIRECTORY dir]
    [COMMENT comment]
    [JOB_POOL job_pool]
    [VERBATIM] [USES_TERMINAL]
    [COMMAND_EXPAND_LISTS]
    [SOURCES src1 [src2...]]
)
```

这个命令属于 CMake 高级用法中才会涉及的命令，这里只是为了说明 CMake 有哪些定义 Target 的方式才给它放在这里。从上面的命令签名你应该能看到，参数非常的多，也非常的复杂。所以这个命令的具体使用我们会在高级部分讲解。

## 4、关于 Target 链接

Target 之间在构建的时候可能会出现 A 依赖 B，B 依赖 C 等情况。一般这种依赖都是因为某个 Target 需要链接另一个 Target。用 C/C++ 的知识来说就是编译器在链接阶段需要链接的库。

在 CMake 中我们使用 target_link_libraries() 命令来实现这一点。

看到没有，CMake 中有许许多多的 target_ 开头的命令，这主要是因为现代 CMake 是围绕着  Target 这一核心特性组织编译构建的。

下面是 target_lin_libraries() 命令的签名：

```cmake
target_link_libraries(targetName
    <PRIVATE|PUBLIC|INTERFACE> item1 [item2 ...]
    [<PRIVATE|PUBLIC|INTERFACE> item3 [item4 ...]]
    ...
)
```

第一个参数必须指定，该名字必须是一个由 add_executable() 或者 add_library() 命令创建的 Target 的名字。

后续可以接多个 PRIVATE、PUBLIC、INTERFACE 选项，这三个选项类似于 C++ 类定义中的 PUBLIC、PRIVATE、PROTECT。

这三个选项后面跟着的 iterms 一般是一些库的名字，这些库可以是由 add_library() 命令创建的 Target 的名字，也可以是其他方式引入的库的名字。

PRIVATE 选项的含义是：targetName 这个 target 会链接 PRIVATE 选项后的 iterms 指定的这些库，这些库只有 targetName 这个 Target 本身需要，其他任何链接 targetName 这个 Target 的其他 Target 都不知道这些 iterms 的存在。

PUBLIC 选项的含义是：不止 targetName 本身这个 Target 需要这些 iterms，其他链接到 targetName 的 Target 也需要依赖这些 iterms，并链接这些 iterms。

INTERFACE 选项的含义是：targetName 本身不需要这些 iterms，但是其他链接 targetName 的 Target 需要依赖这些 iterms，并链接这些 iterms。

例子：

```cmake
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
```

参考：https://github.com/eglinuxer/study_cmake/blob/main/src/CMakeLists.txt

## 5、最佳实践
- 不要将 Target 的名字设置为 ${projectName}
- 给库命名的时候避免 lib 前缀
- 如果没有足够的理由，在定义库目标的时候，不要使用 STATIC 或者 SHARED 关键字，控制权应该交给构建时的开发者（BUILD_SHARED_LIBS）
- target_link_libraries() 总是指明 PRIVATE、PUBLIC 、INTERFACE
