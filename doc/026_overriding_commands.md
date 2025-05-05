# 第 026 讲：CMake 命令覆盖详解
- [第 026 讲：CMake 命令覆盖详解](#第-026-讲cmake-命令覆盖详解)

本讲我们来学习一个在 C/C++ 中也会遇到的问题，就是我们定义的新的函数或者宏与已经的函数或者宏重名的情况。

在 C/C++ 中，我们可以使用作用域来区分，在 CMake 中我们是完全允许这样的操作，因为我们可能会有这样的需求：我们需要包装已有的函数或者宏。但是在使用的时候会有些坑，需要注意。

我们现在看一个例子：
```cmake
function(someFunc)
    # Do something...
endfunction()

# Later in the project...
function(someFunc)
    if(...)
        # Override the behavior with something else...
    else()
        # WARNING: Intended to call the original command, but it is not safe
        _someFunc()
    endif()
endfunction()
```

在这个例子中，我们先定义了 someFunc() 这个函数，然后紧接着又定义了一个同名的 someFunc() 函数，这时候，第二个定义的地方就会覆盖之前定义的地方。

CMake 内部实现在遇到这种情况的时候会将第一处定义的 someFunc() 函数改成 _someFunc() 函数。这样，新的 someFunc() 函数就覆盖了旧的 someFunc() 函数，然后要访问旧的 someFunc() 函数就可以通过 _someFunc() 函数来访问。如上面的例子所示。

在只覆盖一次的情况下，没有什么大问题。但是当覆盖多次的时候，我们就会陷入死循环。如下：
```cmake
function(printme)
    message("Hello from first")
endfunction()

function(printme)
    message("Hello from second")
    _printme()
endfunction()

function(printme)
    message("Hello from third")
    _printme()
endfunction()

printme()
```

在这个例子中，printme() 函数被覆盖了两次，根据我们的直觉，我们期望上述例子的输出是:
```txt
Hello from third
Hello from second
Hello from first
```

然而，我们输出 ```Hello from third``` 后，就陷入了输出 ```Hello from second``` 的死循环。

所以在有需要覆盖已有命令的情况下，一定记得只能覆盖一次，千万不要覆盖多次。最佳实践就是不要试图去覆盖已有的命令。