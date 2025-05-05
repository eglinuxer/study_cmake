# 第 008 讲：CMake 变量总结

- [第 008 讲：CMake 变量总结](#第-008-讲cmake-变量总结)

通过前面三讲关于 CMake 变量的学习，我们已经对变量的基础知识非常熟悉了，本讲我们对 CMake 变量做一个总结。把一些 CMake 变量的异常行为做一个说明。

首先我们来看看普通变量和缓存变量同名会发生什么呢？

- 如果使用 option() 命令设置缓存变量之前已经存在同名的普通变量了，会发生什么？反之呢？
- 如果使用 set() 命令设置缓存变量之前已经存在同名的普通变量了，会发生什么呢？反之呢？存在 INTERNAL 或者 FORCE 关键字呢？

接着我们辨析一下如下 CMake 代码：
```cmake
unset(foo)
set(foo)
set(foo "")
```
- 如果要将一个变量的值设置为空字符串，请使用第三行的方式。

除了在 CMakeLists.txt 中定义缓存变量，我们还有其他方式定义缓存变量吗？
```shell
cmake -D myVar:type=someValue ...
```

- 使用上述 cmake 命令 -D 的方式定义缓存变量，只需要第一次运行时指定就行了，如果每次都指定，该缓存变量的值也每次都会更新。
- 可以使用多个 -D 指定多个缓存变量
- 如果 -D 设置一个忽略类型的缓存变量，在 CMakeLists.txt 中也定义了一个同名的缓存变量，并指定类型为 FILEPATH 或者 PATH，那从不同的目录运行 cmake 会有什么不同？

我们可以使用 cmake 命令 -D 的方式定义缓存变量，那有没有类似方式取消缓存变量的定义呢？
```shell
cmake -U 'help*' -U foo ...
```
- 支持通配符 * 和 ?

我们再来通过 CMake 图形化界面工具加深对 CMake 变量的理解：
- cmake-gui
- ccmake
- 高级变量
  ```cmake
  mark_as_advanced([CLEAR|FORCE] var1 [var2...])
  ```
  - CLEAR：不标记为高级变量
  - FORCE：标记为高级变量
  - 如果这两个关键字都没有，那只有在该变量从未标记过高级变量或非高级变量时才将其标记为高级变量
- Grouped 选项，前缀相同的变量组合在一起

最后我们看看如何打印变量的值。
```cmake
set(myVar HiThere)
message("The value of myVar = ${myVar}\nAnd this "
"appears on the next line")
```
- message() 命令，后续会详细讲解其用法，本讲只需要会简单的使用即可