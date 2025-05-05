# 第 019 讲：CMake 命令之 include
- [第 019 讲：CMake 命令之 include](#第-019-讲cmake-命令之-include)

我们之前讲 ```add_subdirectory()``` 命令的时候，大家已经知道，CMake 可以通过这个命令引入子目录，然后子目录中必须有一个 CMakeLists.txt，这相当于给顶层的 CMakeLists.txt 引入了新的 CMake 内容。

本讲我们一起来学习一个新的命令：include() 这个命令也是将一个新的 CMake 内容引入到当前 CMake 内容中。它有如下两种形式：
```cmake
include(fileName [OPTIONAL] [RESULT_VARIABLE myVar] [NO_POLICY_SCOPE])
include(module   [OPTIONAL] [RESULT_VARIABLE myVar] [NO_POLICY_SCOPE])
```

第一种形式有点类似于 ```add_subdirectory()``` 命令，但是有着重要的区别：
- ```include()``` 期望读取文件的名称，而 ```add_subdirectory()``` 期望一个目录，并将在该目录中查找 CMakeLists.txt文件。
- 传递给 ```include()``` 的文件名通常具有扩展名 ```.cmake```，但它可以是任何东西。
- ```include()``` 不会引入新的变量作用域，而 ```add_subdirectory()``` 会引入。
- 默认情况下，这两个命令都引入了一个新的策略作用域，但可以使用 ```NO_POLICY_SCOPE``` 选项告诉 ```include()``` 命令不要这样做（ ```add_subdirectory()``` 没有此类选项 ）。
- ```CMAKE_CURRENT_SOURCE_DIR``` 和 ```CMAKE_CURRENT_BINARY_DIR``` 变量的值在处理由 ```include()``` 命名引入的文件时不会改变，而会为 ```add_subdirectory()``` 引入子目录而改变。

第二种形式具有完全不同的目的。它用于加载模块，关于 CMake 的模块，我们后面会详细讲解。讲到 CMake 模块的时候我们再详细讨论这种形式。

由于在调用 ```include()``` 时，```CMAKE_CURRENT_SOURCE_DIR``` 的值不会改变，因此包含的文件我们很难计算出它所在的目录。```CMAKE_CURRENT_SOURCE_DIR``` 表示的是调用 ```include()``` 命令所在的目录，而不是被 include 的文件的所在的目录。

此外，与 ```add_subdirectory()``` 不同，文件名将始终是 CMakeLists.txt，当使用 ```include()``` 时，文件的名称可以是任何东西，因此包含的文件可能很难确定自己的名称。好在 CMake 给我们提供了另外一组变量：

**CMAKE_CURRENT_LIST_DIR：** 类似于 ```CMAKE_CURRENT_SOURCE_DIR```，只是在处理 include 的文件时会更新。这是需要处理的当前文件的目录时使用的变量，无论它是如何添加到构建的。它将永远是一个绝对路径。

**CMAKE_CURRENT_LIST_FILE：** 始终提供当前正在处理的文件的名称。它始终持有文件的绝对路径，而不仅仅是文件名。

**CMAKE_CURRENT_LIST_LINE：** 保存当前正在处理的文件的行号。这个变量很少需要，但在某些调试场景中是很有用的。

请注意，上述三个变量适用于 CMake 正在处理的任何文件，而不仅仅是那些由 ```include()```命令引入的文件。

即使通过 ```add_subdirectory()``` 引入的 CMakeLists.txt 文件，它们也具有与上述相同的值，在这种情况下，```CMAKE_CURRENT_LIST_DIR``` 将与 ```CMAKE_CURRENT_SOURCE_DIR``` 具有相同的值。

下面我们通过一些例子来帮助理解这些知识点。

- CMakeLists.txt
    ```cmake
    add_subdirectory(subdir)
    message("")
    include(subdir/CMakeLists.txt)
    ```
- subdir/CMakeLists.txt
    ```cmake
    message("CMAKE_CURRENT_SOURCE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}")
    message("CMAKE_CURRENT_BINARY_DIR = ${CMAKE_CURRENT_BINARY_DIR}")
    message("CMAKE_CURRENT_LIST_DIR   = ${CMAKE_CURRENT_LIST_DIR}")
    message("CMAKE_CURRENT_LIST_FILE  = ${CMAKE_CURRENT_LIST_FILE}")
    message("CMAKE_CURRENT_LIST_LINE  = ${CMAKE_CURRENT_LIST_LINE}")
    ```