# 第 009 讲：CMake 字符串
- [第 009 讲：CMake 字符串](#第-009-讲cmake-字符串)

## 1. 概述
之前我们有说过，CMake 也可以看作是一种编程语言。同其他编程语言一样，CMake 中也有字符串的概念。

随着我们的项目变得复杂起来，CMake 需要一种管理变量的方式来实现复杂的逻辑。CMake 提供了 string() 命令，该命令有许多有用的功能，本讲我们就一起来学习和使用 CMake 的 string() 命令。

先来看看 string() 命令的形式：
```cmake
# 字符串查找和替换
  string(FIND <string> <substring> <out-var> [...])
  string(REPLACE <match-string> <replace-string> <out-var> <input>...)
  string(REGEX MATCH <match-regex> <out-var> <input>...)
  string(REGEX MATCHALL <match-regex> <out-var> <input>...)
  string(REGEX REPLACE <match-regex> <replace-expr> <out-var> <input>...)

# 操作字符串
  string(APPEND <string-var> [<input>...])
  string(PREPEND <string-var> [<input>...])
  string(CONCAT <out-var> [<input>...])
  string(JOIN <glue> <out-var> [<input>...])
  string(TOLOWER <string> <out-var>)
  string(TOUPPER <string> <out-var>)
  string(LENGTH <string> <out-var>)
  string(SUBSTRING <string> <begin> <length> <out-var>)
  string(STRIP <string> <out-var>)
  string(GENEX_STRIP <string> <out-var>)
  string(REPEAT <string> <count> <out-var>)

# 字符串比较
  string(COMPARE <op> <string1> <string2> <out-var>)

# 计算字符串的 hash 值
  string(<HASH> <out-var> <input>)

# 生成字符串
  string(ASCII <number>... <out-var>)
  string(HEX <string> <out-var>)
  string(CONFIGURE <string> <out-var> [...])
  string(MAKE_C_IDENTIFIER <string> <out-var>)
  string(RANDOM [<option>...] <out-var>)
  string(TIMESTAMP <out-var> [<format string>] [UTC])
  string(UUID <out-var> ...)

# json 相关的字符串操作
  string(JSON <out-var> [ERROR_VARIABLE <error-var>]
         {GET | TYPE | LENGTH | REMOVE}
         <json-string> <member|index> [<member|index> ...])
  string(JSON <out-var> [ERROR_VARIABLE <error-var>]
         MEMBER <json-string>
         [<member|index> ...] <index>)
  string(JSON <out-var> [ERROR_VARIABLE <error-var>]
         SET <json-string>
         <member|index> [<member|index> ...] <value>)
  string(JSON <out-var> [ERROR_VARIABLE <error-var>]
         EQUAL <json-string1> <json-string2>)
```

我们可以看到，CMake 字符串的功能非常的多，我们今天只学习一些常用的，对于不常用的，大家可以自行选择学习，如果有不懂的地方，可以随时问我。

## 2. CMake string() 命令功能讲解
### 2.1 字符串查找
```cmake
string(FIND inputString subString outVar [REVERSE])
```
- 在 inputString 中查找 subString，将查找到的索引存在 outVar 中，索引从 0 开始。
- 如果没有 REVERSE 选项，则保存第一个查找到的索引，否则保存最后一个查找到的索引。
- 如果没有找到则保存 -1。

需要注意的是，string(FIND) 将所有字符串都作为 ASCII 字符，outVar 中存储的索引也会以字节为单位计算，因此包含多字节字符的字符串可能会导致意想不到的结果。

```cmake
string(FIND abcdefabcdef def fwdIndex)
string(FIND abcdefabcdef def revIndex REVERSE)
message("fwdIndex = ${fwdIndex}\n"
        "revIndex = ${revIndex}")
```

### 2.2 替换字符串
```cmake
string(REPLACE matchString replaceWith outVar input...)
```
- 将 input 中所有匹配 matchString 的都用 replaceWith 替换，并将结果保存到 outVar 中。
- 如果有多个 input，它们是直接连接在一起的，没有任何分隔符。
  - 这有时可能会有问题，所以通常建议只提供一个 input 字符串。


我们还可以使用 string() 命令的正则方式替换字符串。
```cmake
string(REGEX MATCH    regex outVar input...)
string(REGEX MATCHALL regex outVar input...)
string(REGEX REPLACE  regex replaceWith outVar input...)
```
- input 字符串同样会在开始匹配正则表达式前进行串联。
- MATCH 只查找第一个匹配的字符串，并保存到 outVar 中。
- MATCHALL 会查找所有匹配的字符串，并保存到 outVar 中，如果匹配到多个，outVar 将是一个列表，列表我们后面会讲。
- REPLACE 会将每一个匹配到的字符串用 replaceWith 替换后，将替换后的完整字符串放到 outVar 中。

```cmake
string(REGEX MATCH    "[ace]"           matchOne abcdefabcdef)
string(REGEX MATCHALL "[ace]"           matchAll abcdefabcdef)
string(REGEX REPLACE  "([de])" "X\\1Y"  replVar1 abc def abcdef)
string(REGEX REPLACE  "([de])" [[X\1Y]] replVar2 abcdefabcdef)
message("matchOne = ${matchOne}\n"
        "matchAll = ${matchAll}\n"
        "replVar1 = ${replVar1}\n"
        "replVar2 = ${replVar2}")
```

### 2.3. 截取字符串
```cmake
string(SUBSTRING input index length outVar)
```
- 将 input 字符串从 index 处截取 length 长度放到 outVar 中。
- 如果 length 为 -1 的话，将从 index 到 input 结尾的字符串串保存到 outVar 中。

### 2.4. 常用操作
```cmake
string(LENGTH  input outVar)
string(TOLOWER input outVar)
string(TOUPPER input outVar)
string(STRIP   input outVar)
```
- LENGTH 获取 input 字符串的长度，保存到 outVar 中。
- TOLOWER 将 input 字符串转换成小写保存到 outVar 中。
- TOUPPER 将 input 字符串转换成大写保存到 outVar 中。
- STRIP 将 input 字符串的头尾空格去掉。


### 2.5. 其他字符串操作
由于 CMake string() 命令的功能非常丰富，我们没有必要都去记住，只需要浏览一下官网 CMake 对 string() 命令的描述，知道大概有哪些功能就行了。

官网地址:https://cmake.org/cmake/help/latest/command/string.html