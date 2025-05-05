# 第 022 讲：CMake 函数和宏基础
- [第 022 讲：CMake 函数和宏基础](#第-022-讲cmake-函数和宏基础)

开始本讲前，我们一起回忆一下之前学习的内容，我们学习了 CMake 如何定义变量，如何操作变量；我们还学习了 CMake 的流程控制，包括 if 条件判断，foreach 和 while 循环等。

通过前面知识的学习，我们发现 CMake 越来越像一门编程语言了，所以 CMake 支持函数和宏也就不那么意外了。

本讲我们就一起来学习 CMake 函数和宏基础，学习 CMake 怎么定义和使用函数和宏。

CMake 里面的函数和宏，其行为和 C/C++ 中很像。下面是定义函数和宏的形式：

```cmake
function(name [arg1 [arg2 [...]]])
    # Function body (i.e. commands) ...
endfunction()

macro(name [arg1 [arg2 [...]]])
    # Macro body (i.e. commands) ...
endmacro()
```

我们定义了函数和宏以后，这些函数和宏就能像调用 CMake 内置命令一样调用。我们一起来看一个例子：

```cmake
function(print_me)
    message("Hello from inside a function")
    message("All done")
endfunction()

# Called like so:
print_me()
```

你可能注意到了，CMake 函数没有返回值，如果要返回某个值，需要特殊的方法，我们后续会详细讲。除了这个，CMake 在定义函数和宏的时候，对于函数和宏的名字是不区分大小写的，但是有一个约定俗成的习惯，都使用小写字母🏠下划线的形式命名。

本讲我们简单的认识了 CMake 的函数和宏，知道如何定义简单的函数和宏。但只知道这些是远远不够的，我们接下来的几讲会逐步深入，讲解 CMake 函数和宏的参数解析等。