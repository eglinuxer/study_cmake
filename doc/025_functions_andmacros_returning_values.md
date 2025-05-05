# 第 025 讲：函数和宏返回值详解
- [第 025 讲：函数和宏返回值详解](#第-025-讲函数和宏返回值详解)

在本讲开始之前，我们先回忆下 CMake 函数和宏的主要区别。函数会创建一个新的作用域，而宏不会；函数内部定义或者修改变量对函数外部同名的变量没有影响，除非明确需要传播出去。宏和其调用者共享变量和作用域，因此在宏内部定义变量或者修改变量会影响到外部同名的变量。

在知道了这个前提后，我们继续学习本讲的内容，如何从函数和宏返回一个值。

## 1. 从函数返回值
从 CMake 3.25 开始，我们可以在 return() 命令中使用 PROPAGATE 关键字来轻松返回值。所以要使用这个语法，我们必须将 CMP0140 这个策略设置为 NEW。现在我们还没有学习到 CMake 策略，我们只需要安装 CMake 3.25 及其以上版本，然后使用 ```cmake_minimum_required(VERSION 3.25 FATAL_ERROR)``` 命令声明最小 CMake 版本就行，这条命令会自动为我们讲 CMP0140 这个策略设置为 NEW。

下面看一个例子：
```cmake
# This ensures that we have a version of CMake that supports
# PROPAGATE and that the CMP0140 policy is set to NEW
cmake_minimum_required(VERSION 3.25)

function(doSomething outVar)
    set(${outVar} 42)
    return(PROPAGATE ${outVar})
endfunction()

doSomething(result)
# Here, a variable named result now holds the value 42
```

上面的例子，函数调用者希望通过 outVar 这个变量返回一个值。所以我们只需要在函数内部对这个变量赋值后通过 return() 命令的 PROPAGATE 关键字返回就行。

这里有个技巧，为了不让函数中自己定义的变量覆盖调用者作用域内的变量，通常在 return() 命令中使用 PROPAGATE 关键字传播出去的变量都要求定义成函数的命名变量，这样变量的名字和作用完全由调用者决定，函数只是对其值做操作。

如果函数内部还有新的作用域，return() 命令是从函数内部新的作用域调用的，会是什么情况呢？我们看看下面这个例子：
```cmake
cmake_minimum_required(VERSION 3.25)

function(doSomething outVar)
    set(${outVar} 42)
    block()
        set(${outVar} 27)
        return(PROPAGATE ${outVar})
    endblock()
endfunction()

doSomething(result)
# Here, a variable named result now holds the value 27
```

上面使用的 return() 命令在 CMake 3.25 以及更新的版本才支持。那如果使用的 CMake 版本小于 3.25 版本该怎么实现这个功能呢？不知道大家还记得我们在讲 CMake 变量的时候，set() 命令有一个 PARENT_SCOPE 关键字，我们可以借助这个关键字完整相同的功能。如下：
```cmake
function(func resultVar1 resultVar2)
    set(${resultVar1} "First result" PARENT_SCOPE)
    set(${resultVar2} "Second result" PARENT_SCOPE)
endfunction()

func(myVar otherVar)
message("myVar: ${myVar}")
message("otherVar: ${otherVar}")
```

## 2. 从宏返回值
宏可以像函数那样 return 特定变量，通过将它们作为参数传入，来指定要设置的变量的名称。唯一的区别是，在调用 set() 命令时不应该在宏中使用 PARENT_SCOPE 关键字，因为宏已经修改了调用者范围内的变量。

下面是一个例子：
```cmake
macro(func resultVar1 resultVar2)
    set(${resultVar1} "First result")
    set(${resultVar2} "Second result")
endmacro()
```

在宏中使用 return() 命令一定要非常小心，因为宏相当于直接将宏主体粘贴到调用的地方，所以 return() 命令在宏中使用产生的效果与在什么地方调用宏有很大的关系，我们通过一个例子来学习其行为：
```cmake
macro(inner)
    message("From inner")
    return() # Usually dangerous within a macro
    message("Never printed")
endmacro()

function(outer)
    message("From outer before calling inner")
    inner()
    message("Also never printed")
endfunction()

outer()
```

上述例子宏展开后等同于：
```cmake
function(outer)
    message("From outer before calling inner")
    
    # === Pasted macro body ===
    message("From inner")
    return()
    message("Never printed")
    # === End of macro body ===
    
    message("Also never printed")
endfunction()

outer()
```

所以，```message("Also never printed")``` 这条打印永远也不会打印。

上面的例子说明，我们在函数内部调用了宏，然后在宏的内部调用 return() 命令，我们实际上是从函数中返回了。这就是为什么在宏中使用 return() 命令要非常小心的原因。