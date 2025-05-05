# 第 024 讲：CMake 函数和宏之关键字参数
- [第 024 讲：CMake 函数和宏之关键字参数](#第-024-讲cmake-函数和宏之关键字参数)

通过上一讲的学习，我们已经能写出非常好的函数和宏了，这对需要抽象成函数或者宏的功能非常有用。不过上一讲的知识还不足以让我们写出像 CMake 内置的一些命令那样功能强大的函数和宏，比如：

```cmake
target_link_libraries(targetName
    <PRIVATE|PUBLIC|INTERFACE> item1 [item2 ...]
    [<PRIVATE|PUBLIC|INTERFACE> item3 [item4 ...]]
    ...
)
```

对于 CMake 内置的 target_link_libraries() 命令，它的作用就是在链接阶段，将某个 target 依赖的 target 链接上。比如我们的一个可执行程序依赖一个库，这个时候就需要用到这个命令。

从这个命令（也可以叫做函数）的签名可以看出，它是有关键字参数的，这些关键字是：```<PRIVATE|PUBLIC|INTERFACE>```。

如果我们需要编写这样的函数或者宏，如果只是上一讲的知识是不够的，CMake 给我们提供了另一个内置的命令：```cmake_parse_arguments()```，在这个内置命令的帮助下，我们也能写出 ```target_link_libraries()``` 这样的函数或者宏。

```cmake_parse_arguments()``` 命令有两种形式，第一种形式所有的 CMake 版本都支持。

```cmake
# Needed only for CMake 3.4 and earlier
include(CMakeParseArguments)

cmake_parse_arguments(
    prefix
    valuelessKeywords singleValueKeywords multiValueKeywords
    argsToParse...
)
```

在 CMake 3.5 以前的版本，```cmake_parse_arguments()``` 命令是 CMakeParseArguments 这个模块提供的命令，关于 CMake 模块，我们后面会讲，现在可以理解成他是一个可选的功能，如果我们要用其中的功能，就的先 include 它。

不过在 CMake 3.5 版本开始，```cmake_parse_arguments()``` 命令已经是一个默认的命令，不需要再 ```include(CMakeParseArguments)``` 了。

第二种形式是在 CMake 3.7 版本中引入的，而且只有 CMake 函数可以使用，CMake 宏是不支持这种形式的。

```cmake
# Available with CMake 3.7 or later, do not use in macros
cmake_parse_arguments(
    PARSE_ARGV startIndex
    prefix
    valuelessKeywords singleValueKeywords multiValueKeywords
)
```

- valuelessKeywords
    - 这种关键字参数没有额外的参数，只是一个独立的关键字，在调用函数的时候，有这个关键字和没有这个关键字代表着两种不同的情况，功能类似于传递了一个 BOOL 类型的命名参数。
- singleValueKeywords
    - 这种关键字参数需要一个额外的参数，而且只能有一个。
- multiValueKeywords
    - 这种关键字参数后面可以有零个或者多个额外的参数。

以上三个关键字参数在命名方面，虽然官方没有约定，但建议都是用大写字母加下划线的形式。另外关键字参数的名字不要太长，否则可能带来意想不到的后果。

下面我们先看一个例子，然后继续学习 ```cmake_parse_arguments()``` 命令的使用。

```cmake
function(func)
    # Define the supported set of keywords
    set(prefix ARG)
    set(noValues ENABLE_NET COOL_STUFF)
    set(singleValues TARGET)
    set(multiValues SOURCES IMAGES)
    
    # Process the arguments passed in
    include(CMakeParseArguments)
    cmake_parse_arguments(
        ${prefix}
        "${noValues}" "${singleValues}" "${multiValues}"
        ${ARGN}
    )
    
    # Log details for each supported keyword
    message("Option summary:")
    
    foreach(arg IN LISTS noValues)
        if(${prefix}_${arg})
            message(" ${arg} enabled")
        else()
            message(" ${arg} disabled")
        endif()
    endforeach()
    
    foreach(arg IN LISTS singleValues multiValues)
        # Single argument values will print as a string
        # Multiple argument values will print as a list
        message(" ${arg} = ${${prefix}_${arg}}")
    endforeach()
endfunction()

# Examples of calling with different combinations
# of keyword arguments

func(SOURCES foo.cpp bar.cpp
    TARGET MyApp
    ENABLE_NET
)

func(COOL_STUFF
    TARGET dummy
    IMAGES here.png there.png gone.png
)
```

上面的例子的输出如下:

```txt
Option summary:
    ENABLE_NET enabled
    COOL_STUFF disabled
    TARGET = MyApp
    SOURCES = foo.cpp;bar.cpp
    IMAGES =
Option summary:
    ENABLE_NET disabled
    COOL_STUFF enabled
    TARGET = dummy
    SOURCES =
    IMAGES = here.png;there.png;gone.png
```

上述例子，我们使用了 ```cmake_parse_arguments()``` 命令的第一种形式，当然因为这个例子是封装的一个 CMake 函数，自然也就可以使用 ```cmake_parse_arguments()``` 命令的第二种形式，如下:

```cmake
cmake_parse_arguments(
    PARSE_ARGV 0
    ${prefix}
    "${noValues}" "${singleValues}" "${multiValues}"
)
```

如果传入的参数通过 ```valuelessKeywords singleValueKeywords multiValueKeywords``` 三种关键字参数都不能解析，那就会保存在一个叫做 ```<prefix>_UNPARSED_ARGUMENTS``` 的变量中，这个变量是一个列表。

我们一起来看一个例子：

```cmake
function(demoArgs)
    set(noValues "")
    set(singleValues SPECIAL)
    set(multiValues EXTRAS)
    
    cmake_parse_arguments(
        PARSE_ARGV 0
        ARG
        "${noValues}" "${singleValues}" "${multiValues}"
    )
    
    message("Left-over args: ${ARG_UNPARSED_ARGUMENTS}")
    
    foreach(arg IN LISTS ARG_UNPARSED_ARGUMENTS)
        message("${arg}")
    endforeach()
endfunction()

demoArgs(burger fries "cheese;tomato" SPECIAL secretSauce)
```

上述例子输出如下：
```txt
Left-over args: burger;fries;cheese\;tomato
burger
fries
cheese;tomato
```

上面这个例子，我们特意传入了一个包含分号的参数 ```"cheese;tomato"```，我们使用的是 ```cmake_parse_arguments()``` 命令的第二种形式去解析参数，所有它有效地识别出 ```"cheese;tomato"``` 是一个参数，而不是两个，如果使用 ```cmake_parse_arguments()``` 命令的第一种形式，就会不一样，大家不妨自己试一下。

singleValueKeywords 关键字参数需要一个额外的参数，如果在调用的时候没有给它传递额外的参数会发生什么呢？

从 CMake 3.15 版本开始，如果没有给需要额外参数的关键字参数传递额外的参数，那一个默认的变量：```<prefix>_KEYWORDS_MISSING_VALUES ``` 将会保存这个关键字。来看一个例子：

```cmake
function(demoArgs)
    set(noValues "")
    set(singleValues SPECIAL)
    set(multiValues ORDINARY EXTRAS)
    
    cmake_parse_arguments(
        PARSE_ARGV 0
        ARG
        "${noValues}" "${singleValues}" "${multiValues}"
    )
    
    message("Keywords missing values: ${ARG_KEYWORDS_MISSING_VALUES}")
endfunction()

demoArgs(burger fries SPECIAL ORDINARY EXTRAS high low)
```

在这个例子中，因为 SPECIAL 关键字参数是明确需要一个额外的参数的，如果没有传递，可能会导致错误，但是 CMake 不会报错，所以我们要特别注意。

```cmake_parse_arguments()``` 命令的第一种形式其实还有其他用途，我们再来看一个使用 ```cmake_parse_arguments()``` 命令的第一种形式的例子：

```cmake
function(libWithTest)
    # First level of arguments
    set(groups LIB TEST)
    cmake_parse_arguments(GRP "" "" "${groups}" ${ARGN})
    
    # Second level of arguments
    set(args SOURCES PRIVATE_LIBS PUBLIC_LIBS)
    cmake_parse_arguments(LIB "" "TARGET" "${args}" ${GRP_LIB})
    cmake_parse_arguments(TEST "" "TARGET" "${args}" ${GRP_TEST})
    
    add_library(${LIB_TARGET} ${LIB_SOURCES})
    target_link_libraries(${LIB_TARGET}
        PUBLIC ${LIB_PUBLIC_LIBS}
        PRIVATE ${LIB_PRIVATE_LIBS}
    )
    
    add_executable(${TEST_TARGET} ${TEST_SOURCES})
    target_link_libraries(${TEST_TARGET}
        PUBLIC ${TEST_PUBLIC_LIBS}
        PRIVATE ${LIB_TARGET} ${TEST_PRIVATE_LIBS}
    )
endfunction()

libWithTest(
    LIB
        TARGET Algo
        SOURCES algo.cpp algo.h
        PUBLIC_LIBS SomeMathHelpers
    TEST
        TARGET AlgoTest
        SOURCES algoTest.cpp
        PRIVATE_LIBS gtest_main
)
```

这个例子很好的展示了通过 ```cmake_parse_arguments()``` 命令解析多级参数的方式。

虽然这些功能相当强大，但该命令仍然有一些限制。内置命令能够支持重复关键字。例如，像target_link_libraries（）这样的命令允许在同一个命令中多次使用PRIVATE、PUBLIC和INTERFACE关键字。cmake_parse_arguments（）命令不支持这一点。它只会返回与关键字最后一次出现相关的值，并丢弃较早的值。只有当使用多级关键字集并且关键字在任何给定的正在处理的参数集中只出现一次时，关键字才能重复。