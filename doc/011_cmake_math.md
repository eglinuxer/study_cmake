# 第 011 讲：CMake 数学计算操作
- [第 011 讲：CMake 数学计算操作](#第-011-讲cmake-数学计算操作)

有时候，我们需要对 CMake 变量之间进行数学运算，这时候 CMake 提供了 math() 这个命令，命令格式如下：

```cmake
math(EXPR outVar mathExpr [OUTPUT_FORMAT format])
```

这个命令也很简单，直接通过 CMake 变量结合数学运算符组成 mathExpr，然后计算结果会保存到 outVar 中。

OUTPUT_FORMAT 是可选参数，代表输出结果的格式，可以是 HEXADECIMAL：输出 16 进制结果，DECIMAL：输出 10 进制结果。

下面看几个例子：

```cmake
set(x 3)
set(y 7)
math(EXPR zDec "(${x}+${y}) * 2")
message("decimal = ${zDec}")

# Requires CMake 3.13 or later for HEXADECIMAL
math(EXPR zHex "(${x}+${y}) * 2" OUTPUT_FORMAT HEXADECIMAL)
message("hexadecimal = ${zHex}")
```