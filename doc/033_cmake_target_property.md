# 第 033 讲：Target 属性

- [第 033 讲：Target 属性](#第-033-讲target-属性)
  - [Target 属性的作用](#target-属性的作用)
  - [Target 属性的设置和获取](#target-属性的设置和获取)

CMake 是一个强大的跨平台构建系统，它的主要作用是生成 Makefile 或其他构建系统所需的文件，以便于将源代码转化为可执行文件、库等。

CMake 的一个重要的概念是 Target（目标），它是要构建的文件的抽象，可以是可执行文件、库文件或其他类型的文件。每个 Target 都可以有一些属性，这些属性控制着它们的编译和链接方式、输出类型和路径等。

本讲将详细介绍 CMake 中的 Target 属性，包括其作用、如何设置和获取 Target 属性，以及与 Target 属性相关的命令。

## Target 属性的作用

在 CMake 中，Target 属性对于控制如何将源代码转化为目标文件（可执行文件、库文件或其他类型的文件）至关重要。Target 属性控制了从源代码到最终输出的所有步骤，包括源代码的编译、链接器的选项和输出文件的路径等。

在 CMake 中，Target 属性具有以下作用：
- 控制如何编译源代码，例如使用哪些编译器选项、预处理器定义、包含路径等。
- 控制如何链接目标文件，例如使用哪些库、库的搜索路径、链接器选项等。
- 控制输出文件的类型和路径，例如是否为库、可执行文件或其他类型文件，以及输出路径。

此外，Target 属性还可以影响如何在开发人员的 IDE 项目中呈现目标，包括如何组织和显示文件、图标和其他属性。

总之，Target 属性是将源代码转化为目标文件的关键，几乎涵盖了所有将源代码转化为目标文件所需的详细信息。

## Target 属性的设置和获取

在 CMake 中，设置 Target 属性有多种方法。除了通用的 ```set_property()``` 和 ```get_property()``` 命令之外，还提供了一些针对 Target 的命令，如 ```set_target_properties()``` 和 ```get_target_property()```。

```set_target_properties()``` 命令用于设置 Target 的属性，它的语法如下：

```cmake
set_target_properties(target1 [target2...]
    PROPERTIES
        propertyName1 value1
        [propertyName2 value2] ...
)
```

其中，target1 和 target2 是 Target 的名称，propertyName1 和 propertyName2 是 Target 属性的名称，value1 和 value2 是相应属性的值。

例如，可以通过以下命令来设置一个目标的输出名称和输出路径：
```cmake
set_target_properties(MyTarget
  PROPERTIES
    OUTPUT_NAME "mylib"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)
```

该命令将 MyTarget 目标的输出名称设置为 mylib，输出路径设置为 ${CMAKE_BINARY_DIR}/bin。

get_target_property() 命令用于获取一个目标的属性值。其语法如下：

```cmake
get_target_property(resultVar target propertyName)
```

其中，resultVar 表示获取到的属性值将会存储在该变量中，target 表示需要获取属性的目标，propertyName 表示需要获取的属性名。

例如，可以通过以下命令来获取一个目标的输出路径：

```cmake
get_target_property(output_path MyTarget RUNTIME_OUTPUT_DIRECTORY)
```

该命令将会把 MyTarget 目标的 RUNTIME_OUTPUT_DIRECTORY 属性值存储到 output_path 变量中。

总之，目标属性是 CMake 中非常重要的一部分，它们控制着目标的编译、链接、输出路径等各个方面。在编写 CMakeLists.txt 文件时，需要对目标属性有一定的了解，并且可以使用相关命令来获取和设置它们。

关于 CMake Target 属性就先学到这里，我们后续还会经常使用到。