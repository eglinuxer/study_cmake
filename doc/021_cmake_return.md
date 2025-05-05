# 第 021 讲：CMake 提前结束处理命令：return
- [第 021 讲：CMake 提前结束处理命令：return](#第-021-讲cmake-提前结束处理命令return)

有时候，我们有这样的需求：当处理到某个地方的时候，后面的逻辑我们都不想处理或者不需要处理的时候，就可以提前结束当前的处理逻辑，回到父级去处理。在 C/C++ 中，我们有 break 关键字跳出当前循环，continue 关键字进入下一次循环，return 关键字返回当前处理的函数。

CMake 也给我们提供了 break()、continue()、return() 命令，前两个命令我们呢之前在 015 讲已经详细讨论过了，本讲我们就重点来学习 CMake 中的 return() 命令。

- 如果调用 return() 命令的地方不在一个函数中，那将结束当前文件的处理，回到引入当前文件的地方。我们之前有讲过，引入一个 CMake 脚本文件的方式可以是 include() 命令，也可以是 add_subdirectory() 命令。
- 在函数中调用 return() 命令比较复杂，但很重要，所以我们会单独拿出一讲来讲解，本讲大家忽略在函数中调用 return() 命令。

在 CMake 3.25 版本以前，return() 命令是没有参数的，从 CMake 3.25 开始，return() 命令有了一个类似 block() 命令的参数关键字：PROPAGATE，在这个关键字后面我们可以给出列出一些变量，这些变量在调用 return() 命令的时候会更新其值。

为了兼容旧版本，我们在使用 return() 命令的时候如果使用了关键字参数：PROPAGATE，那我们通常需要把 CMP0140 这个策略设置为 NEW，关于 CMake 策略，我们后面会详细介绍，本讲实验大家只需要保证自己安装的 CMake 版本大于等于 3.25 就行，不用设置 CMP0140 策略。

下面我们通过例子来加深对 return() 命令的理解。

CMakeLists.txt
  ```cmake
  set(x 1)
  set(y 2)

  add_subdirectory(subdir)

  # Here, x will have the value 3 and y will be unset
  ```

subdir/CMakeLists.txt
  ```cmake
 # This ensures that we have a version of CMake that supports
  # PROPAGATE and that the CMP0140 policy is set to NEW.

  cmake_minimum_required(VERSION 3.25)

  set(x 3)
  unset(y)

  return(PROPAGATE x y)
  ```

我们之前讲过 block() 命令可以在任意地方产生新的作用域，return() 命令和 block() 命令结合使用会产生什么样的效果呢？我们一起来看一些例子：

CMakeLists.txt
  ```cmake
  set(x 1)
  set(y 2)

  block()
      add_subdirectory(subdir)
      # Here, x will have the value 3 and y will be unset
  endblock()

  # Here, x is 1 and y is 2
  ```

---
CMakeLists.txt
 ```cmake
  set(x 1)
  set(y 2)

  add_subdirectory(subdir)

  # Here, x will have the value 3 and y will be unset
 ```

subdir/CMakeLists.txt
  ```cmake
  cmake_minimum_required(VERSION 3.25)

  # This block does not affect the propagation of x and y to
  # the parent CMakeLists.txt file's scope
  block()
      set(x 3)
      unset(y)
      return(PROPAGATE x y)
  endblock()
  ```

通过上面的例子，我相信大家已经掌握了 return() 命令的用法。return() 命令用于提前结束处理，在本讲结束前，我想借着提前返回处理这个话题介绍 CMake 另一种类似于 C/C++ 头文件防御的方式，在引入新的 CMake 脚本文件的时候提前返回。

CMake 各版本通用的方式是这样：
```cmake
if(DEFINED cool_stuff_include_guard)
    return()
endif()

set(cool_stuff_include_guard 1)
# ...
```

CMake 3.10 开始，我们可以使用一条命令替代: ```include_guard()```。

include_guard() 命令支持两个关键字，GLOBAL 和 DIRECTORY。一般情况下不需要。
- GLOBAL 关键字表示在全局范围内如果曾经处理过这个文件，那就直接返回。
- DIRECTORY 关键字只在当前目录作用域或者其子目录作用域范围内曾经处理过该文件才直接返回。

从 016 讲开始，我们学习的主题都离不开子目录这个概念，直至本讲结束，我们基本把子目录相关的知识都引出并介绍了。后续当然还有更深入的知识点需要我们去学习。