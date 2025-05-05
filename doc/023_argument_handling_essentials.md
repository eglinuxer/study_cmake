# 第 023 讲：CMake 函数和宏的参数处理基础
- [第 023 讲：CMake 函数和宏的参数处理基础](#第-023-讲cmake-函数和宏的参数处理基础)

本讲我们详细地学习 CMake 函数和宏在处理参数的时候的一些重要知识。CMake 函数和宏的参数在处理上基本相同，但是有一个非常重要的区别。

CMake 函数把每个参数都当作是 CMake 变量，并且这些参数也都有 CMake 变量的行为。

CMake 宏把每个参数都当作是字符串，这和 C/C++ 中的宏是一致的，宏调用就相当于把宏参数当作字符串替换到宏主体中这些参数出现的地方。

下面我们一起来看一个例子：

```cmake
function(func arg)
    if(DEFINED arg)
        message("Function arg is a defined variable")
    else()
        message("Function arg is NOT a defined variable")
    endif()
endfunction()

macro(macr arg)
    if(DEFINED arg)
        message("Macro arg is a defined variable")
    else()
        message("Macro arg is NOT a defined variable")
    endif()
endmacro()

func(foobar)
macr(foobar)
```

```txt
Function arg is a defined variable
Macro arg is NOT a defined variable
```

从输出我们可以看到，通过 if(DEFINED ...) 命令分别判断 CMake 函数和宏的参数是不是一个已经定义了的变量，只有 CMake 函数打印了 arg 是一个已经定义的变量，CMake 的宏没有，这说明 CMake 宏只把其参数当作字符串处理。

除了上面这个区别外，CMake 函数和宏参数的处理都支持相同的特性。我们可以使用访问变量的方式在 CMake 函数和宏主体中访问其参数，虽然 CMake 宏把参数当作字符串，但也是可以通过变量的方式访问的。下面是一个例子：

```cmake
function(func myArg)
    message("myArg = ${myArg}")
endfunction()

macro(macr myArg)
    message("myArg = ${myArg}")
endmacro()

func(foobar)
macr(foobar)
```

上面 CMake 函数和宏调用后，打印均为：```myArg = foobar```。

从上面两个例子，我们可以看到，调用 CMake 函数和宏都需要传入命名的参数。除了我们传入的命名参数，CMake 还会为我们生成一些默认的参数，下面我们就一起来看看这些默认的参数。

- ARGC
    - 这个默认参数是一个值，代表的是传递给函数或者宏的所有参数的个数。
- ARGV
    - 这个默认参数是一个列表，其中保存的是传递给函数或者宏的所有参数。
- ARGN
    - 这个默认参数和 ARGV 一样，但是它只包含命名参数之外的参数（也就是可选参数和未命名的参数）。

除了上述三个默认参数外，每个参数还可以使用 ARGVx 的形式引用，其中 x 代表的是参数的编号，例如：ARGV0、ARGV1 等等。

我们还是来看个例子：

```cmake
# Use a named argument for the target and treat all other
# (unnamed) arguments as the source files for the test case
function(add_mytest targetName)
    add_executable(${targetName} ${ARGN})
    
    target_link_libraries(${targetName} PRIVATE foobar)
    
    add_test(NAME ${targetName}
        COMMAND ${targetName}
    )
endfunction()

# Define some test cases using the above function
add_mytest(smallTest small.cpp)
add_mytest(bigTest big.cpp algo.cpp net.cpp)
```

这个例子，我们定义了一个叫做 add_mytest 的函数，这个函数有一个命名参数。第一个参数代表添加单元测试的名字，后续的未命名参数是编译这个单元测试需要的源文件，可以是一个或者多个。

CMake 宏在使用 ARGN 的时候，需要特别注意，下面我们看一个容易出错的例子：

```cmake
# WARNING: This macro is misleading
macro(dangerous)
    # Which ARGN?
    foreach(arg IN LISTS ARGN)
        message("Argument: ${arg}")
    endforeach()
endmacro()

function(func)
    dangerous(1 2)
endfunction()

func(3)
```

cmake 执行配置的时候，上述代码输出为:

```txt
Argument: 3
```

是不是有点诧异，但是当我们回到宏的本质，宏就是一段可以直接粘贴到调用处的代码，当我们把它修改成下面这个样子，一切就明了了。

```cmake
function(func)
    # Now it is clear, ARGN here will use the arguments from func
    foreach(arg IN LISTS ARGN)
        message("Argument: ${arg}")
    endforeach()
endfunction()
```

如果非要用第一种形式，那建议使用函数替换宏，函数就不会有上述问题。

本讲我们主要认识了 CMake 函数和宏的命名参数、未命名参数和默认参数。下一讲我们继续学习 CMake 函数和宏的关键字参数。