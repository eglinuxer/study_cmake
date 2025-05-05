# 第 029 讲：CMake 处理参数时的一些问题说明
- [第 029 讲：CMake 处理参数时的一些问题说明](#第-029-讲cmake-处理参数时的一些问题说明)

通过前面几讲的学习，我们已经能够自己定义函数和宏了，而且我们可以使用关键字参数，定义较为复杂的函数。

但是我们在处理函数和宏的参数的时候，如果不小心，会遇到很多的坑，本讲我们就来看一些常见的参数处理的坑。

先来看一个例子：
```cmake
someCommand(a b c)
someCommand(a   b c)
```
因为 CMake 中使用空格或者分号作为分隔符，所以上面的代码等价于：
```cmake
someCommand(a b;c)
someCommand(a;;;;b;c)
```

如果我们想要参数的值包含空格或者分号，就需要使用引号将其引起来，例如：
```cmake
someCommand(a "b b" c)
someCommand(a "b;b" c)
someCommand(a;"b;b";c)
```

使用空格和分号作为分隔符还有一点区别，当涉及到变量求值并且参数未使用引号的时候，例如：
```cmake
set(containsSpace "b b")
set(containsSemiColon "b;b")

someCommand(a ${containsSpace} c)
someCommand(a ${containsSemiColon} c)
```

```someCommand(a ${containsSpace} c)``` 实际上会传递三个参数，而 ```someCommand(a ${containsSemiColon} c)``` 会传递四个参数。

为了弄明白它们之间的区别，我们再来看一些例子：
```cmake
set(empty                 "")
set(space                 " ")
set(semicolon             ";")
set(semiSpace             "; ")
set(spaceSemi             " ;")
set(spaceSemiSpace        " ; ")
set(spaceSemiSemi         " ;;")
set(semiSemiSpace         ";; ")
set(spaceSemiSemiSpace    " ;; ")

someCommand(${empty})                # 0 arg
someCommand(${space})                # 1 arg
someCommand(${semicolon})            # 0 arg
someCommand(${semiSpace})            # 1 arg
someCommand(${spaceSemi})            # 1 arg
someCommand(${spaceSemiSpace})       # 2 arg
someCommand(${spaceSemiSemi})        # 1 arg
someCommand(${semiSemiSpace})        # 1 arg
someCommand(${spaceSemiSemiSpace})   # 2 args 
```

通过上面的例子，我们可以总结出一些结论：

1. 当参数是变量求值的结果的时候，空格不会被丢弃，也不会充当分隔符。
2. 当参数没有加引号的时候，其值开头和结尾的一个或者多个分号会被丢弃。
3. 当参数没有加引号的时候，其值中间的连续分号会被合并成一个分号。

通常，如果我们传递的参数如果是一个变量求值的结果，那建议使用引号，这样能避免大多数的困惑，但是并不总是这样的，也有明确需要参数不使用引号的情况。

我们之前在讲关键字参数的时候，看过这样的例子：
```cmake
function(func)
    set(noValues ENABLE_A ENABLE_B)
    set(singleValues FORMAT ARCH)
    set(multiValues SOURCES IMAGES)
    
    cmake_parse_arguments(
        ARG
        "${noValues}" "${singleValues}" "${multiValues}"
        ${ARGV}
    )
endfunction()
```

在这个例子中，```"${noValues}" "${singleValues}" "${multiValues}"``` 我们都用了引号，但是 ```${ARGV}``` 就不需要引号，这是为什么呢？

我们先来看一个例子：
```cmake
func(a "" c)
func("a;b;c" "1;2;3")
```

对于第一条命令，```${ARGV}``` 的求值是：```a;;c```，根据上述结论3，因为中间的多个分号会被合并成一个，所以 ```cmake_parse_arguments()``` 命令实际上只会把 ```a``` 和 ```c``` 作为要解析的参数。

对于第二条命令，```${ARGV}``` 的求值是：```a;b;c;1;2;3```，本来是想把 ```a;b;c``` 当作第一个参数，把 ```1;2;3``` 当作第二个参数，但是 ```cmake_parse_arguments()``` 命令实际上会认为传入了 6 个参数。

上述两个问题都可以通过避免使用 ```${ARGV}``` 来解决，也就是使用下面的命令形式：
```cmake
cmake_parse_arguments(
    PARSE_ARGV 0 ARG
    "${noValues}" "${singleValues}" "${multiValues}"
)
```

这种方式可以是的参数完全按照传入的方式保留。

我们在自己定义函数或者宏的时候，一个相对常见的需求是围绕现有命令创建某种包装器。项目可能希望支持一些额外的选项或删除现有选项，或者它可能希望在调用之前或之后执行某些处理。保留参数并在不改变其结构或丢失信息的情况下转发它们可能会非常困难。

先来看一个例子：

```cmake
function(printArgs)
    message("ARGC = ${ARGC}\n"
            "ARGN = ${ARGN}"
    )
endfunction()

printArgs("a;b;c" "d;e;f")
```

输出如下：
```txt
ARGC = 2
ARGN = a;b;c;d;e;f
```

因为传入的参数是带引号的，所以 ```ARGC``` 的值是 2，但是 ```ARGV``` 却是一个包含 6 个值的列表。原始的参数形式在这里就丢失了，如果要做参数转发就会产生错误，例如：

```cmake
function(inner)
    message("inner:\n"
            "ARGC = ${ARGC}\n"
            "ARGN = ${ARGN}"
    )
endfunction()

function(outer)
    message("outer:\n"
            "ARGC = ${ARGC}\n"
            "ARGN = ${ARGN}"
    )
    inner(${ARGN}) # Naive forwarding, not robust
endfunction()

outer("a;b;c" "d;e;f")
```

输出的结果如下：
```txt
outer:
ARGC = 2
ARGN = a;b;c;d;e;f
inner:
ARGC = 6
ARGN = a;b;c;d;e;f
```

啊哈，不是我们期待的结果。

那我们应该怎么解决这个问题呢？其实很简单，使用 ```cmake_parse_arguments()``` 命令的 PARSE_ARGV 形式，如下：
```cmake
function(outer)
    cmake_parse_arguments(PARSE_ARGV 0 FWD "" "" "")
    inner(${FWD_UNPARSED_ARGUMENTS})
endfunction()
```

因为没有关键字需要解析，所有所有的参数都被保存到 ```FWD_UNPARSED_ARGUMENTS``` 中，这种方式转发参数就不会丢失参数的原始形式。

你以为这样就万事大吉了吗？很不幸，通过上述的结论 2 和结论 3，我们发现，这种方式不会保留任何空参数。为了避免空参数丢失，每个参数都应该单独列出，并加上引号。这就需要用到 CMake 3.18 版本开始提供的 ```cmake_language(EVAL CODE)``` 命令，如下：
```cmake
function(outer)
    cmake_parse_arguments(PARSE_ARGV 0 FWD "" "" "")
    
    set(quotedArgs "")
    foreach(arg IN LISTS FWD_UNPARSED_ARGUMENTS)
        string(APPEND quotedArgs " [===[${arg}]===]")
    endforeach()
    
    cmake_language(EVAL CODE "inner(${quotedArgs})")
endfunction()
```

上述解决方案因为用到了 ```cmake_parse_arguments()``` 命令的 PARSE_ARGV 形式，所以在宏里面是不能使用的。

还有一种特殊情况，就是参数带有不平衡的方括号的情况，需要特别注意，看下面这个例子：
```cmake
function(func)
    message("Number of arguments: ${ARGC}")
    math(EXPR lastIndex "${ARGC} - 1")
    
    foreach(n RANGE 0 ${lastIndex})
        message("ARGV${n} = ${ARGV${n}}")
    endforeach()
    
    foreach(arg IN LISTS ARGV)
        message("${arg}")
    endforeach()
endfunction()

func("a[a" "b]b" "c[c]c" "d[d" "eee")
```

其输出如下：
```txt
Number of arguments: 5
ARGV0 = a[a
ARGV1 = b]b
ARGV2 = c[c]c
ARGV3 = d[d
ARGV4 = eee
a[a;b]b
c[c]c
d[d;eee
```

func() 函数可以看到 5 个参数，但是对 ```ARGV``` 取值却只能取到三个值，这就是方括号不平衡的问题，我们在写 CMake 的代码的时候要特别注意，避免使用。

