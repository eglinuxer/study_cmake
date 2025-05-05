# 第 010 讲：CMake 列表
- [第 010 讲：CMake 列表](#第-010-讲cmake-列表)

本讲我们认识一个新的 CMake 命令，叫做 list()，这个命令同上一讲的 string() 命令一样，都是在操作 CMake 的变量，但是 list() 命令只操作值为列表的变量，当然只有一个值或者一个值都没有的变量也是列表。

下面是 CMake 官网给出的 list() 命令的格式：

```cmake
# 读取
  list(LENGTH <list> <out-var>)
  list(GET <list> <element index> [<index> ...] <out-var>)
  list(JOIN <list> <glue> <out-var>)
  list(SUBLIST <list> <begin> <length> <out-var>)

# 搜索
  list(FIND <list> <value> <out-var>)

# 修改
  list(APPEND <list> [<element>...])
  list(FILTER <list> {INCLUDE | EXCLUDE} REGEX <regex>)
  list(INSERT <list> <index> [<element>...])
  list(POP_BACK <list> [<out-var>...])
  list(POP_FRONT <list> [<out-var>...])
  list(PREPEND <list> [<element>...])
  list(REMOVE_ITEM <list> <value>...)
  list(REMOVE_AT <list> <index>...)
  list(REMOVE_DUPLICATES <list>)
  list(TRANSFORM <list> <ACTION> [...])

# 排序
  list(REVERSE <list>)
  list(SORT <list> [...])
```

可以看出一共有四大类功能，分别是读取列表信息、搜索列表信息、修改列表信息、对列表进行排序。

这些功能通过名字都能看出是什么意思，我这里就不一一举例了，具体的功能描述大家如果不清楚可以查看官方文档或者我针对本讲专门录制的视频教程。

官方文档：https://cmake.org/cmake/help/latest/command/list.html