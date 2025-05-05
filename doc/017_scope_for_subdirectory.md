# 第 017 讲：子目录相关的作用域详解
- [第 017 讲：子目录相关的作用域详解](#第-017-讲子目录相关的作用域详解)

add_subdirectory() 命令引入一个新的子目录的同时，也引入了新的作用域，相对于调用 add_subdirectory() 命令的 CMakeLists.txt 所在的作用域来说，通过 add_subdirectory() 命令引入的新的作用域叫做子作用域。其行为类似于 C/C++ 语言中调用一个新的函数。

- 调用 add_subdirectory() 命令的时候，当前作用域内的变量均会复制一份到子作用域，子作用域中对这些复制的变量进行操作不会影响到当前作用域中这些变量的值。
- 在子作用域中定义的新的变量对父作用域是不可见的。

下面我们看一个例子，加深一下理解：
- CMakeLists.txt
  ```cmake
  set(myVar foo)

  message("Parent (before): myVar    = ${myVar}")
  message("Parent (before): childVar = ${childVar}")

  add_subdirectory(subdir)

  message("Parent (after):  myVar    = ${myVar}")
  message("Parent (after):  childVar = ${childVar}")
  ```
- subdir/CMakeLists.txt
  ```cmake
  message("Child  (before): myVar    = ${myVar}")
  message("Child  (before): childVar = ${childVar}")

  set(myVar bar)
  set(childVar fuzz)

  message("Child  (after):  myVar    = ${myVar}")
  message("Child  (after):  childVar = ${childVar}")
  ```

我们之前在讲 set() 命令的时候，有提到 PARENT_SCOPE 关键字，在 add_subdirectory() 命令使用的时候，PARENT_SCOPE 关键字通常就可以派上用场了，下面我们一起来看一个例子：
- CMakeLists.txt
  ```cmake
  set(myVar foo)
  message("Parent (before): myVar = ${myVar}")
  add_subdirectory(subdir)
  message("Parent (after):  myVar = ${myVar}")
  ```
- subdir/CMakeLists.txt
  ```cmake
  message("Child  (before): myVar = ${myVar}")
  set(myVar bar PARENT_SCOPE)
  message("Child  (after):  myVar = ${myVar}")
  ```

