# 第 030 讲：CMake 属性通用命令

- [第 030 讲：CMake 属性通用命令](#第-030-讲cmake-属性通用命令)
  - [1. set\_property() 命令](#1-set_property-命令)
  - [2. get\_property() 命令](#2-get_property-命令)

属性是 CMake 的关键概念，属性会影响构建过程的方方面面，从源文件如何编译成对象文件，到二进制文件的安装位置，再到打包安装程序的目录等。

为了方便理解 CMake 中的属性，我这里先举一个例子：我们可以把人当作是一个对象，人有姓名、性别、年龄、身高等，这些就可以称为人这个对象的属性。

在 CMake 中，我们可以把各种 CMake 实体也看作是一个对象，这些对象都可以有自己的属性。CMake 中的实体有**目录、target、SOURCE、TEST、缓存变量**等等，我们甚至可以把整个构建过程本身也看作是一种 CMake 的实体。

有时候我们很容易把属性和变量搞混淆，属性不像变量那样持有独立值，它提供特定于其附加实体的信息，这是属性和变量的根本区别。

了解了这些基本概念后，我们一起来学习和 CMake 属性相关的命令。

## 1. [set_property()](https://cmake.org/cmake/help/latest/command/set_property.html) 命令

签名如下：

```cmake
set_property(<GLOBAL                        |
    DIRECTORY [<dir>]                       |
    TARGET    [<target1> ...]               |
    SOURCE    [<src1> ...]
        [DIRECTORY <dirs> ...]
        [TARGET_DIRECTORY <targets> ...]    |
    INSTALL   [<file1> ...]                 |
    TEST      [<test1> ...]                 |
    CACHE     [<entry1> ...]    >
    [APPEND] [APPEND_STRING]
    PROPERTY <name> [<value1> ...])
```

set_property() 命令是设置属性的通用命令，第一个参数代表的是需要设置属性的实体，从上述命令的签名可以看出，可以设置属性的实体有：GLOBAL、TARGET、SOURCE、INSTALL、TEST、CACHE。

- GLOBAL 实体代表全局属性
- DIRECTORY 实体后面可以跟一个目录（这个目录必须是 CMake 已知的），如果没有明确指出，则是当前目录。
  - 相关特定于设置目录属性的命令：[set_directory_properties()](https://cmake.org/cmake/help/latest/command/set_directory_properties.html#command:set_directory_properties)
- TARGET 实体代表 CMake 已知的 target
  - 相关特定于设置 target 属性的命令：[set_target_properties()](https://cmake.org/cmake/help/latest/command/set_target_properties.html#command:set_target_properties)
- SOURCE 实体代表和源码文件相关的属性。如果没有跟子命令，那源码的属性只对当前目录中定义的 target 可见。
  - DIRECTORY 子命令用于指定目录，在这些指定的目录中定义的 target 均对设置的源码属性可见。
  - TARGET_DIRECTORY 子命令使得其指定的 target 目录对设置的源码属性可见。
  - 相关特定于设置源码文件属性的命令：[set_source_files_properties()](https://cmake.org/cmake/help/latest/command/set_source_files_properties.html#command:set_source_files_properties)
- INSTALL 实体指定安装的文件路径
- TEST 实体指定单元测试
  - 相关特定于设置单元测试属性的命令：[set_tests_properties()](https://cmake.org/cmake/help/latest/command/set_tests_properties.html#command:set_tests_properties)
- CACHE 实体指定缓存变量

PROPERTY 参数是必须的，用于制定需要设置的属性的名字，名字后面需要跟相应的值。

APPEND 和 APPEND_STRING 这两个可选的参数会影响到属性值追加时候的行为，通过一个表格来理解。

| 原始值 | 新的值 | 没有关键字 | APPEND  | APPEND_STRING |
|-----|-----|-------|---------|---------------|
| foo | bar | bar   | foo;bar | foobar        |
| a;b | c;d | c;d   | a;b;c;d | a;bc;d        |


## 2. [get_property()](https://cmake.org/cmake/help/latest/command/get_property.html) 命令

签名如下：
```cmake
get_property(<variable>
    <GLOBAL                                                 |
    DIRECTORY [<dir>]                                       |
    TARGET    <target>                                      |
    SOURCE    <source>
        [DIRECTORY <dir> | TARGET_DIRECTORY <target>]       |
    INSTALL   <file>                                        |
    TEST      <test>                                        |
    CACHE     <entry>                                       |
    VARIABLE           >
    PROPERTY <name>
    [SET | DEFINED | BRIEF_DOCS | FULL_DOCS])
```

可以获取属性值的实体有：GLOBAL、DIRECTORY、TARGET、SOURCE、INSTALL、TEST、CACHE、VARIABLE。

除了 VARIABLE 外，其他实体的含义在 ```set_property()``` 命令中已经讲过。VARIABLE 实体顾名思义，就是过去附着在变量上的属性。

SET 选项如果给定，那要获取的属性如果设置过值，则 variable 被设置为真。

DEFINED 选项如果给定，如果有要获取的这个属性名字，则 variable 被设置为真。

BRIEF_DOCS | FULL_DOCS 选项如果给定，那 variable 被设置为要获取的属性的文档字符串。

上述四个可选关键字，只有 SET 在实际项目中用到，其他三个几乎不用，除非明确使用 [define_property()](https://cmake.org/cmake/help/latest/command/define_property.html#command:define_property) 命令为某个属性设置过信息。

其签名如下：
```cmake
define_property(<GLOBAL | DIRECTORY | TARGET | SOURCE | TEST | VARIABLE | CACHED_VARIABLE>
    PROPERTY <name> [INHERITED]
    [BRIEF_DOCS <brief-doc> [docs...]]
    [FULL_DOCS <full-doc> [docs...]]
    [INITIALIZE_FROM_VARIABLE <variable>])
```