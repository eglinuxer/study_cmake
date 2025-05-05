# 第 032 讲：目录属性

- [第 032 讲：目录属性](#第-032-讲目录属性)

本讲我们学习 CMake 目录属性。在 CMake 项目中，除了项目的顶级目录，我们还可能添加一些子目录，这些目录也是可以设置属性和获取属性的。

通过对目录设置和获取属性，可以方便我们对项目的组织和管理。

除了属性通用的命令可以设置和获取目录属性外，CMake 也为我们提供了专门用于设置和获取目录属性的命令。

```cmake
set_directory_properties(PROPERTIES prop1 value1 [prop2 value2] ...)
```

CMake 设置目录属性的通用命令如下：

```cmake
set_property(DIRECTORY [<dir>]
    [APPEND] [APPEND_STRING]
    PROPERTY <name> [<value1> ...]
)
```

这两个命令用于设置一个目录的属性，影响该目录下的所有子目录和目标。该命令可以设置一些常用的目录属性，如编译器选项、编译器特性、链接选项等。

例如：
```cmake
set_directory_properties(PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
    COMPILE_OPTIONS "-Wall;-Wextra;-pedantic"
)
```

```cmake
set_property(DIRECTORY
    PROPERTY CXX_STANDARD 17
)
```

有设置目录属性的命令，也就有获取目录属性的命令。

```cmake
get_directory_property(<variable> [DIRECTORY <dir>] <prop-name>)
get_directory_property(<variable> [DIRECTORY <dir>] DEFINITION <var-name>)
```

第一种形式非常简单，对应获取由设置目录属性的命令设置的目录属性，例如：

```cmake
get_directory_property(CXX_STANDARD_USED DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} CXX_STANDARD)
message("CXX_STANDARD_USED: ${CXX_STANDARD_USED}")
```

对于第二种形式，看上去和目录属性没有太大关系，但是非常有用，比如我们在 lib 目录设置了一个变量，然后想在 app 目录使用这个变量的值，就可以使用第二种形式获取到。

lib 目录

```cmake
cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

set(LIB_VERSION "1.0.0")
```

app 目录

```cmake
cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

get_directory_property(LIB_VERSION_DEFINITION DIRECTORY "${CMAKE_SOURCE_DIR}/lib" DEFINITION LIB_VERSION)

message("Library version: ${LIB_VERSION_DEFINITION}")
```

关于 CMake 目录属性，掌握这些知识点就能够很好地帮助我们组织 CMake 项目了，大家记得自己动手练习消化哦，我们下期见。