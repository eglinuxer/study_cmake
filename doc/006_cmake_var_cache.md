# 第 006 讲：CMake 变量之缓存变量

- [第 006 讲：CMake 变量之缓存变量](#第-006-讲cmake-变量之缓存变量)

与普通变量不同，缓存变量的值可以缓存到 CMakeCache.txt 文件中，当再次运行 cmake 时，可以从中获取上一次的值，而不是重新去评估。所以缓存变量的作用域是全局的。

CMake 定义缓存变量的格式如下：
```cmake
set(varName value... CACHE type "docstring" [FORCE])
```
和普通变量比起来，缓存变量携带了更多的信息。缓存变量有类型了，而且可以为缓存变量添加一个说明信息。

从上面的 CMake 定义缓存变量的命令中，我们可以看到，第一个参数依然是变量的名字，第二个参数是变量的值。缓存变量不同于普通变量是从第三个参数开始的，第三个参数是固定 CACHE 这个关键字，表示这条命令定义的是缓存变量。

第四个参数 type 是必选参数，而且其值必须是下列值之一。
- BOOL
  - BOOL 类型的变量值如果是 ON、TRUE、1 则被评估为真，如果是 OFF、FALSE、0 则被评估为假。
  - 当然除了上面列出的值还有其他值，但是判断真假就没那么清晰了，所以建议定义 BOOL 类型的缓存变量的时候，其值就采用上述列出的值。虽然不区分大小写，但是我建议统一使用大写。
- FILEPATH
  - 文件路径
- STRING
  - 字符串
- INTERNAL
  - 内部缓存变量不会对用户可见，一般是项目为了缓存某种内部信息时才使用，cmake 图形化界面工具也对其不可见。
  - 内部缓存变量默认是 FORCE 的。
    - FORCE 关键字代表每次运行都强制更新缓存变量的值，如果没有该关键字，当再次运行 cmake 的时候，cmake 将使用 CMakeCache.txt 文件中缓存的值，而不是重新进行评估。

CMake 自身是将所有变量的值均视为字符串的，这里指定类型只是为了提高 cmake 图形界面工具的用户体验。

第五个参数是一个说明性的字符串，可以为空，只在图形化 cmake 界面会展示。

由于 BOOL 类型的变量使用频率非常高，CMake 为其单独提供了一条命令。

```cmake
option(optVar helpString [initialValue])
```
第一个参数是变量的名字，第二个参数是提供帮助信息的字符串，可以为空字符串。
initialValue 是可选参数，代表缓存变量的值，如果没有提供，那该缓存变量的值默认为 OFF。

上述命令等价于：
```cmake
set(optVar initialValue CACHE BOOL helpString)
```

不过上述两个命令定义缓存变量是有一点点区别的，option() 命令没有 FORCE 关键字。

到目前为止，我们已经把 CMake 的三种变量都学习了，上一讲我们讲解了 CMake 环境变量的用途。那 CMake 什么时候该使用普通变量？什么时候该使用缓存变量呢？

普通变量适用于变量的值相对固定，而且只在某一个很小的作用域生效的场景。

缓存变量适用于其值可以随时更改，作用域为全局的情况。经常在 CMake 中定义缓存变量，给一个默认值，如果用户想要更改缓存变量的值，可以通过 cmake -D 的形式去更改。

随着我们课程慢慢深入，很多同学已经遇到了一些问题。为了方便答疑，我建立有知识星球专门用于答疑。知识星球是按年付费的，知识星球的付费用户享受本门课程付费部分免费学习的权限。欢迎有条件的同学加入我的知识星球，尽早享受答疑服务，以及可以和志同道合的朋友一起学习 CMake，相互监督，共同进步。

<img src="./picture/zhishixingqiu.jpeg" width="100%" height="100%">