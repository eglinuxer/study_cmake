# 第 014 讲：CMake 流程控制之 while 循环
- [第 014 讲：CMake 流程控制之 while 循环](#第-014-讲cmake-流程控制之-while-循环)

CMake 也支持 while 循环，当一个条件表达式为真的时候，while 循环将执行其中的语句，然后再次检测条件表达式是否为假，否则将重复执行 while 循环体中的命令。CMake while() 命令的形式如下：
```cmake
while(condition)
    # ...
endwhile()
```

condition 的判断规则同 if() 命令，如果对 if() 命令条件表达式判断忘记了，可以查看：[CMake if() 命令](./012_cmake_if.md)

下面看一个例子：
```cmake
set(num 10)

while(num GREATER 0)
    message(STATUS "current num = ${num}")
    math(EXPR num "${num} - 1")
endwhile()
```