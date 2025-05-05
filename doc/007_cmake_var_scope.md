# 第 007 讲：CMake 变量之作用域

- [第 007 讲：CMake 变量之作用域](#第-007-讲cmake-变量之作用域)

做 C/C++ 开发，作用域大家都很清楚是什么样的一个概念。作用域和变量是密切相关的。CMake 有变量的概念，自然也有作用域的概念。不过 CMake 中的作用域可不简简单单针对变量。

CMake 有策略这么一个概念，策略也有作用域。不过我们本讲不会讲解 CMake 策略，只会在讲 CMake 变量作用域的时候提及 CMake 策略的作用域。

在 C/C++ 中，我们可以使用 {}、函数、类等产生新的作用域，同时也有全局作用域的概念。在 CMake 中，通常只有在使用 ```add_subdirectory()``` 命令或者定义函数的时候产生新的作用域。自 CMake 3.25 开始，可以使用 ```block()``` 在任意位置产生新的作用域。

我们上一讲有讲到 CMake 的缓存变量，CMake 缓存变量的作用域是全局的。

CMake 环境变量的作用域也是全局的，只有 CMake 普通变量的作用域受到不同 CMake 命令的影响。

我们在定义 CMake 普通变量的时候，如果没有 PARENT_SCOPE 选项，那该变量的作用域就在当前的 CMakeLists.txt 中或者在当前的函数，或者当前的 block() 中。

视频演示：

1、在同一个 CMakeLists.txt 中定义普通变量，并使用其值。

2、在 add_subdirectory() 作用下，产生的新作用域

3、在函数作用下，产生的新作用域

4、PARENT_SCOPE 的作用

下面学习 block() 命令：

```cmake
block([SCOPE_FOR [VARIABLES] [POLICIES]] [PROPAGATE var...])
endblock()
```
- 该命令需要 cmake >= 3.25 版本
- 该命令用于创建新的作用域（变量作用域、策略作用域）

下面看一些例子：

```cmake
set(x 1)

block()
    set(x 2)   # Shadows outer "x"
    set(y 3)   # Local, not visible outside the block
endblock()

# Here, x still equals 1, y is not defined
```

```cmake
set(x 1)
set(y 3)

block()
    set(x 2 PARENT_SCOPE)
    unset(y PARENT_SCOPE)
    # x still has the value 1 here
    # y still exists and has the value 3
endblock()

# x has the value 2 here and y is no longer defined
```

```cmake
set(x 1)
set(z 5)

block(PROPAGATE x z)
    set(x 2) # Gets propagated back out to the outer "x"
    set(y 3) # Local, not visible outside the block
    unset(z) # Unsets the outer "z" too
endblock()

# Here, x equals 2, y and z are undefined
```

```cmake
set(x 1)
set(z 5)

block(SCOPE_FOR VARIABLES PROPAGATE x z)
    set(x 2) # Gets propagated back out to the outer "x"
    set(y 3) # Local variable, not visible outside the block
    unset(z) # Unsets the outer "z" too
endblock()

# Here, x equals 2, y and z are undefined
```

看了上面这些 CMake 变量作用域的例子，大家对 CMake 变量作用域应该有了一定的了解。不过现在没有在真实的项目案例中体现，大家可能没有那么容易吸收。不过不用担心，我们后面会经常使用到 CMake 变量作用域的知识，通过不断的重复知识点，就能轻松掌握的。

随着我们课程慢慢深入，很多同学已经遇到了一些问题。为了方便答疑，我建立有知识星球专门用于答疑。知识星球是按年付费的，知识星球的付费用户享受本门课程付费部分免费学习的权限。欢迎有条件的同学加入我的知识星球，尽早享受答疑服务，以及可以和志同道合的朋友一起学习 CMake，相互监督，共同进步。

<img src="./picture/zhishixingqiu.jpeg" width="100%" height="100%">

