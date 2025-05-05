# 第 027 讲：函数相关的特殊变量
- [第 027 讲：函数相关的特殊变量](#第-027-讲函数相关的特殊变量)

本讲我们一起来学习一些和函数相关的 CMake 内置变量，这些变量对于调试 CMake 代码非常有用。

不过这些变量在 CMake 3.17 版本才开始支持的，所有要使用这些变量，请确保你的 CMake 最小版本要求是 3.17。

- CMAKE_CURRENT_FUNCTION
    - 这个变量会保存当前正在执行的函数的名字
- CMAKE_CURRENT_FUNCTION_LIST_FILE
    - 这个变量会保存当前正在执行的函数所在文件的绝对路径
- CMAKE_CURRENT_FUNCTION_LIST_DIR
    - 这个变量会保存当前正在执行的函数所在文件的目录的绝对路径
- CMAKE_CURRENT_FUNCTION_LIST_LINE
    - 这个变量会保存当前正在执行的函数的行号

除了在调试的时候用这些变量，我们在调用函数的时候，如果在函数内部需要使用路径的时候，这些变量也是非常有用的，我们来看一个例子：
```cmake
function(writeSomeFile toWhere)
    configure_file(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/template.cpp.in ${toWhere} @ONLY)
endfunction()
```

这里的 ```configure_file()``` 命令作用是把 ```${CMAKE_CURRENT_FUNCTION_LIST_DIR}/template.cpp.in``` 文件通过一些规则转化成另一个文件：```${toWhere}```。在这个例子中，我们就能够通过 CMAKE_CURRENT_FUNCTION_LIST_DIR 这个变量准确地定位 template.cpp.in 的路径，如果没有这个变量的支持，一种可能的实现如下：
```cmake
set(__writeSomeFile_DIR ${CMAKE_CURRENT_LIST_DIR})

function(writeSomeFile toWhere)
    configure_file(${__writeSomeFile_DIR}/template.cpp.in ${toWhere} @ONLY)
endfunction()
```

这种实现就严重依赖于 __writeSomeFile_DIR 变量，使用起来灵活性有所下降。

本讲主要讲解了几个与函数和宏相关的 CMake 内置变量的用法。虽然名字都带了 FUNCTION 字眼，但是在宏里面也是可以使用的，只是在宏里面使用的时候，这些变量的值会依赖于调用宏的位置。大家不妨自己写一些简单的测试例子，看看在宏里面使用这些变量时，它们的值有什么样的行为。