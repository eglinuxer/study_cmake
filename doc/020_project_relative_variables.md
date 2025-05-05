# 第 020 讲：项目相关的变量详解
- [第 020 讲：项目相关的变量详解](#第-020-讲项目相关的变量详解)

本讲我们一起来学习 project() 命令相关的一些变量。我们在 CMake 项目中，通常需要对路径进行操作，比如我们需要知道源码的顶级目录，源码的构建目录，和某个 project 名字相关的一些目录等。

我们之前有讲过一个变量：CMAKE_SOURCE_DIR，这个变量的值代表的是源码的顶级目录。但是这个变量的值可能会发生变化。

比如我们现在有个项目 B，它的顶级目录是 /root/workspace/code/b。这个时候，我们在项目 B 中使用 CMAKE_SOURCE_DIR 变量的值，毫无疑问，它的值是：/root/workspace/code/b。

现在我们又有一个新的项目 A，它的顶级目录是 /root/workspace/code/a，同时我们的项目 A 依赖项目 B，所以我们通过某种方式将项目 B 作为项目 A 的依赖，假设这个时候项目 A 依赖的项目 B 的源码在 /root/workspace/code/b/3rd/b 目录中。那这个时候，我们在项目 B 中获取到的 CMAKE_SOURCE_DIR 的值就不是我们期望的 /root/workspace/code/a/3rd/b，而是变成了 /root/workspace/code/a。所以我们的项目如果可能会被作为第三方项目使用，那 CMAKE_SOURCE_DIR 的值可能就会不可靠。

同样 CMAKE_BINARY_DIR 变量也有这样的问题。

那 CMake 是怎么解决这个问题的呢？当我们调用 project() 命令的时候，CMake 会同时设置一些和 project 相关的变量的值。下面我们就一起来认识一下这些变量。

- PROJECT_SOURCE_DIR
    - 该变量的值是在当前作用域或者父作用域中最近的一处调用 project() 命令的那个 CMakeLists.txt 所在的目录。
- PROJECT_BINARY_DIR
    - PROJECT_SOURCE_DIR 目录对应的构建目录
- projectName_SOURCE_DIR
    - 前面的 projectName 是在调用 project() 命令时传入的名字，加上 _SOURCE_DIR 后缀可以特指某个项目的 CMakeLists.txt 所在的目录。
- projectName_BINARY_DIR
    - projectName_BINARY_DIR 目录对应的构建目录

下面我们通过一些例子来加深理解。

CMakeLists.txt
  ```cmake
  cmake_minimum_required(VERSION 3.26)

  project(topLevel)

  message("Top level:")
  message("  PROJECT_SOURCE_DIR  = ${PROJECT_SOURCE_DIR}")
  message("  topLevel_SOURCE_DIR = ${topLevel_SOURCE_DIR}")

  add_subdirectory(child)
  ```
child/CMakeLists.txt
  ```cmake
  message("Child:")
  message("  PROJECT_SOURCE_DIR (before) = ${PROJECT_SOURCE_DIR}")

  project(child)

  message("  PROJECT_SOURCE_DIR (after)  = ${PROJECT_SOURCE_DIR}")
  message("  child_SOURCE_DIR            = ${child_SOURCE_DIR}")

  add_subdirectory(grandchild)
  ```
child/grandchild/CMakeLists.txt
  ```cmake
  message("Grandchild:")
  message("  PROJECT_SOURCE_DIR  = ${PROJECT_SOURCE_DIR}")
  message("  child_SOURCE_DIR    = ${child_SOURCE_DIR}")
  message("  topLevel_SOURCE_DIR = ${topLevel_SOURCE_DIR}")
  ```

上述例子的输出可能是这样：
  ```shell
  Top level:
    PROJECT_SOURCE_DIR  = /somewhere/src
    topLevel_SOURCE_DIR = /somewhere/src
  Child:
    PROJECT_SOURCE_DIR (before) = /somewhere/src
    PROJECT_SOURCE_DIR (after)  = /somewhere/src/child
    child_SOURCE_DIR            = /somewhere/src/child
  Grandchild:
    PROJECT_SOURCE_DIR  = /somewhere/src/child
    child_SOURCE_DIR    = /somewhere/src/child
    topLevel_SOURCE_DIR = /somewhere/src
  ```

通过上面的例子，我们可以看到，使用 project() 命令相关的变量去获取相关路径是非常可靠的，我们的项目中也建议使用这种方式。

举个例子，我们在使用 ${CMAKE_SOURCE_DIR}/someFile 的时候最好使用 ${PROJECT_SOURCE_DIR}/someFile 或者 ${projectName_SOURCE_DIR}/someFile 代替。这样无论我们的项目是单独构建还是作为一个子项目构建都能保证我们期望的目录是对的。

我们经常看到一些开源项目的顶级目录的 CMakeLists.txt 中有类似下面的代码：
```cmake
if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    # do something.
endif()
```

这里通过比较 CMAKE_CURRENT_SOURCE_DIR 和 CMAKE_SOURCE_DIR 两个变量的值来判断当前项目是否是单独构建。如果相等，表明这个项目是单独构建的，没有作为任何其他项目的子模块。

上面这种方式还需要我们自己判断，CMake 3.21 版本开始，CMake 提供了一个变量：PROJECT_IS_TOP_LEVEL，如果这个变量为真，就代表当前项目是单独构建的，或者是项目中顶级 project。

同理，也有 ```projectName_IS_TOP_LEVEL``` 变量。每当我们调用 project() 命令的时候，就会创建对应的 ```projectName_IS_TOP_LEVEL``` 缓存变量。