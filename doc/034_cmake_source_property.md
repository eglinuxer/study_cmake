# 第 034 讲：源文件属性
- [第 034 讲：源文件属性](#第-034-讲源文件属性)

CMake 是一个跨平台的构建工具，可以管理和构建各种软件项目。上一讲，我们讲过 CMake 可以对 Target 进行属性的设置和获取，CMake 支持更细粒度的对单个源文件进行属性设置，这些属性可以在源文件级别对编译器标志进行精细调整，而不是对整个目标的所有源文件进行设置。

此外，属性还可以提供有关源文件的其他信息，以修改 CMake 或构建工具如何处理该文件，例如，它们可以指示该文件是否作为构建的一部分生成，使用哪个编译器，与文件一起使用的非编译器工具选项等。

开发者可以使用 ```set_source_files_properties()``` 和 ```get_source_file_property()``` 命令来设置和获取源文件属性。例如，可以使用以下命令设置源文件属性，以防止将其与其他源文件组合在一个 Unity Build 中：

```cmake
add_executable(MyApp small.cpp big.cpp tall.cpp thin.cpp)

set_source_files_properties(big.cpp PROPERTIES SKIP_UNITY_BUILD_INCLUSION YES)
```

其中，SKIP_UNITY_BUILD_INCLUSION 属性用于防止该文件被包含到 Unity Build 中。

此外，CMake 3.18 或更高版本还提供了其他选项来指定应该在哪个目录范围内搜索或应用源文件属性。例如，DIRECTORY 选项可以用于指定应该设置源文件属性的一个或多个目录，TARGET_DIRECTORY 选项可以指定要设置源文件属性的目标的名称。

```cmake
set_property(SOURCE sources...
    [DIRECTORY dirs...]
    [TARGET_DIRECTORY targets...]
    [APPEND | APPEND_STRING]
    PROPERTY propertyName values...
)
set_source_files_properties(sources...
    [DIRECTORY dirs...]
    [TARGET_DIRECTORY targets...]
    PROPERTIES
        propertyName1 value1
        [propertyName2 value2] ...
)

get_property(resultVar SOURCE source
    [DIRECTORY dir | TARGET_DIRECTORY target]
    PROPERTY propertyName
    [DEFINED | SET | BRIEF_DOCS | FULL_DOCS]
)

get_source_file_property(resultVar source
    [DIRECTORY dir | TARGET_DIRECTORY target]
    propertyName
)
```

需要注意的是，对于一些 CMake 生成器（特别是 Unix Makefiles 生成器），源文件和源文件属性之间的依赖关系比较强。如果使用源文件属性来修改特定源文件的编译器标志而不是整个目标的标志，那么更改源文件的编译器标志将导致所有目标源文件被重新构建，而不仅仅是受影响的源文件。

这是由于在 Makefile 中，测试每个单独源文件的编译器标志是否发生了变化会带来很大的性能损失。因此，相关的 Makefile 依赖关系是在目标级别实现的。

通常情况下，开发者可能会使用源文件属性将版本信息传递给一个或两个源文件作为编译器定义。但是，如上所述，使用源文件属性也可能会降低构建性能，因为这些文件不会参与 Unity Build。因此，在使用源文件属性时，开发者需要注意潜在的性能问题，并考虑其他替代方案。

最后我们再来看一个例子：

假设有一个 CMake 项目，其中有一个 src 目录，其中包含以下源文件：

```shell
src/
├── main.cpp
├── helper.cpp
├── helper.h
├── utils.cpp
└── utils.h
```

现在，我们希望在编译 main.cpp 时使用一个特定的编译器选项，而在编译 helper.cpp 时不使用该选项，并且在编译 utils.cpp 时禁用 Unity 构建（即不将其与其他文件合并到一个单独的源文件中）。

为了实现这些要求，我们可以在 CMakeLists.txt 文件中添加以下代码：

```cmake
cmake_minimum_required(VERSION 3.18)
project(MyProject)

# 添加可执行文件
add_executable(MyApp src/main.cpp src/helper.cpp src/utils.cpp)

# 为 main.cpp 添加一个编译器选项
set_source_files_properties(src/main.cpp PROPERTIES COMPILE_FLAGS "-O2")

# 禁用 utils.cpp 的 Unity 构建
set_source_files_properties(src/utils.cpp PROPERTIES SKIP_UNITY_BUILD_INCLUSION YES)
```

这样，CMake 将为 src/main.cpp 添加 -O2 选项，而对于 src/helper.cpp，CMake 将使用默认选项。而 src/utils.cpp 将被标记为不参与 Unity 构建。

需要注意的是，如果在项目中定义多个目标，那么 SKIP_UNITY_BUILD_INCLUSION 属性可能会影响所有使用了该文件的目标，而不仅仅是与当前目标相关的文件。因此，需要谨慎地使用该属性。

对于大多数项目，我们都不需要这么细粒度的控制，所以几乎不会用到源码属性。所以本讲内容如果没有理解，不必担心，它不会影响我们后续的学习。通过后续对统一构建的深入学习，本讲的例子就能够轻松理解了。