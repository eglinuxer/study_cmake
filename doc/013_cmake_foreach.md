# 第 013 讲：CMake 流程控制之 for 循环
- [第 013 讲：CMake 流程控制之 for 循环](#第-013-讲cmake-流程控制之-for-循环)

有些项目，我们需要对一个列表的元素进行遍历，或者需要对一堆的值进行相似的操作，这个时候 CMake 的 foreach() 命令就可以派上用场，其格式如下：
```cmake
foreach(loopVar arg1 arg2 ...)
    # ...
endforeach()

foreach(loopVar IN [LISTS listVar1 ...] [ITEMS item1 ...])
    # ...
endforeach()
```

第一种形式很简单，每一次循环，loopVar 都将从 arg1 arg2 ... 中取出一个值，然后在循环体中使用。

第二种形式比较通用，但是只要有 IN 关键字，那后面的 [LISTS listVar1 ...] [ITEMS item1 ...] 就必须有其一或者都有，当两者都有的时候，[ITEMS item1 ...] 需要全部放在 [LISTS listVar1 ...] 后面。

还有一点需要注意的是，[ITEMS item1 ...] 中的 item1 ... 都不会作为变量使用，就仅仅是字符串或者值。

下面看一个例子：
```cmake
set(list1 A B)
set(list2)
set(foo WillNotBeShown)

foreach(loopVar IN LISTS list1 list2 ITEMS foo bar)
    message("Iteration for: ${loopVar}")
endforeach()
```

Cmake 3.17 中添加了一种特殊的形式，可以在一次循环多个列表，其形式如下：
```cmake
foreach(loopVar... IN ZIP_LISTS listVar...)
    # ...
endforeach()
```
如果只给出一个 loopVar，则该命令将在每次迭代时设置 loopVar_N 形式的变量，其中 N 对应于 listVarN 变量。编号从 0 开始。如果每个 listVar 都有一个 loopVar，那么该命令会一对一映射它们，而不是创建 loopVar_N 变量。以下示例演示了这两种情况：
```cmake
set(list0 A B)
set(list1 one two)

foreach(var0 var1 IN ZIP_LISTS list0 list1)
    message("Vars: ${var0} ${var1}")
endforeach()

foreach(var IN ZIP_LISTS list0 list1)
    message("Vars: ${var_0} ${var_1}")
endforeach()
```

以这种方式“压缩”的列表不必长度相同。当迭代超过较短列表的末尾时，关联的迭代变量将未定义。取未定义变量的值会导致空字符串。下一个示例演示了行为：
```cmake
set(long  A B C)
set(short justOne)

foreach(varLong varShort IN ZIP_LISTS long short)
    message("Vars: ${varLong} ${varShort}")
endforeach()
```

CMake 的 for 循环还有一种类似于 C 语言的 for 循环的形式，如下：
```cmake
foreach(loopVar RANGE start stop [step])

foreach(loopVar RANGE value)
```

第一种形式，在 start 到 stop 之间迭代，可以指定步长 step。
第二种形式等价于：
```cmake
foreach(loopVar RANGE 0 value)
```

为了清晰，我们应该避免第二种形式，只使用第一种形式。