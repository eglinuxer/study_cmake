# 第 028 讲：复用 CMake 代码的其他方法
- [第 028 讲：复用 CMake 代码的其他方法](#第-028-讲复用-cmake-代码的其他方法)

通过前几讲的学习，我们已经能够为重用 CMake 代码定义函数和宏，本讲我们继续来学习另一种达到 CMake 代码重用的手段。

CMake 3.18 版本开始，添加了 ```cmake_language()``` 命令，通过这个命令，我们可以直接调用任意的 CMake 代码，无须将这些可重用的代码使用函数或者宏包装起来。

当然 ```cmake_language()``` 命令不是为了替代函数和宏而设计的，而是希望通过该命令可以以一种更简洁的方式来调用可重用的 CMake 代码，作为函数和宏的补充。

下面是这个命令的签名：
```cmake
cmake_language(CALL command [args...])
cmake_language(EVAL CODE code...)
```

CALL 方式可以调用 CMake 命令，同时可以以传入参数。但是某些内置的命令不能通过这种方式调用，特别是那些处理逻辑的命令，例如：```if(), endif(), foreach(), endforeach()``` 等等。

下面来看一个例子：
```cmake
function(qt_generate_moc)
    set(cmd qt${QT_DEFAULT_MAJOR_VERSION}_generate_moc)
    
    cmake_language(CALL ${cmd} ${ARGV})
endfunction()
```

这个例子中，我们通过 QT 的 QT_DEFAULT_MAJOR_VERSION 变量组成了一个 叫做 ```qt${QT_DEFAULT_MAJOR_VERSION}_generate_moc``` 的命令，其实这个命令是由 Qt 的 CMake 模块提供的，我们使用的时候就可以通过 ```cmake_language(CALL ${cmd} ${ARGV})``` 去调用 ```qt${QT_DEFAULT_MAJOR_VERSION}_generate_moc``` 命令，而无需将其包装成函数或者宏。

当然 CALL 字命令的用处相当有限，```EVAL CODE``` 子命令提供了更强大的功能。它几乎可以执行任何有效的 CMake 脚本。

我们还是通过一个示例来学习它的用法：
```cmake
set(myProjTraceCall [=[
    message("Called ${CMAKE_CURRENT_FUNCTION}")
    set(__x 0)
    while(__x LESS ${ARGC})
        message(" ARGV${__x} = ${ARGV${__x}}")
        math(EXPR __x "${__x} + 1")
    endwhile()
    unset(__x)
]=])

function(func)
    cmake_language(EVAL CODE "${myProjTraceCall}")
    # ...
endfunction()
    
func(one two three)
```

在这个例子中，我们通过把一个 CMake 脚本放在一个变量中，然后使用 ```EVAL CODE``` 子命令去调用这个 CMake 脚本。

CMake 3.19 版本对 ```cmake_language()``` 命令做了扩展，添加了 DEFER 子命令的支持。不过这个命令的使用非常复杂，通常不建议使用，所以本讲我们不对其进行学习。

CMake 3.24 版本对 ```cmake_language()``` 命令做了扩展，添加了 字命令的支持。SET_DEPENDENCY_PROVIDER 字命令的支持。

CMake 3.25 版本对 ```cmake_language()``` 命令做了扩展，添加了 GET_MESSAGE_LOG_LEVEL 字命令的支持。

以上这个三个子命令目前我们都使用不到，所以本讲不会对其展开讲解。后续我们需要使用到的时候会对其展开。如果现在你对这三个子命令也感兴趣，可以参考：https://cmake.org/cmake/help/latest/command/cmake_language.html#defer