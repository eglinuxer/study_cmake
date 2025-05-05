# 第 018 讲：子目录中定义 project
- [第 018 讲：子目录中定义 project](#第-018-讲子目录中定义-project)

对于初学者，一定会有这样的疑问？project() 命令对于一个项目来说是必须的，那 project() 命令应该在哪里调用，可不可以多次调用呢？本讲我们就一起来把这个问题彻底弄清楚。

首先，project() 命令对于一个项目来说是必须的，如果开发人员没有显式的调用 project() 命令，在运行 cmake 进行项目配置的时候会收到警告信息，同时，cmake 会隐式地添加 project() 命令的调用。强烈建议在顶层 CMakeLists.txt 中适当的位置显式的调用 project() 命令。

虽然我们可以通过函数或者 cmake 脚本对 project() 命令进行封装，然后通过调用函数或者 include() cmake 脚本的方式间接地调用 project() 命令，但是这些都是强烈不建议的，最好的方式就是在顶层 CMakeLists.txt 中适当的位置显式地调用 project() 命令。

其次，porject() 命令可不可以调用多次？答案是可以的，但是需要有 add_subdirectory() 命令调用的情况下才行，也就是说，我们不能在同一个 CMakeLists.txt 中调用 project() 命令多次，但是可以在 add_subdirectory() 命令调用时引入的子目录中的 CMakeLists.txt 中再次调用 project() 命令。通常这样做没有什么坏处，但是会导致 CMake 生成更多的项目文件。

大多数时候，我们都没有必要在每个 add_subdirectory() 命令引入的子目录中的 CMakeLists.txt 中都调用 project() 命令。但是有的时候这会很有用。一般我们会把相对独立的模块放到一个单独的目录中，然后通过 add_subdirctory() 命令引入这个目录。这种功能相对独立的模块，我们就可以给他调用一次 project() 命令，让它成为一个单独的项目。

虽然在子目录中调用 project() 命令可以让其成为一个独立的项目，但是它依然在顶级或者上级项目的管理下，像 Visual Studio 这种 IDE，cmake 生成的解决方案打开后就可以看到每次 project() 命令调用都有一个解决方案，子目录中的解决方案可以单独打开。如果打开的是顶层目录的解决方案文件，所有的解决方案都能看到。

Visual Studio 如果打开子目录中的解决方案，在构建的时候会自动去构建其依赖项，但是像 xcode 就不会自动去构建依赖项。

本讲基本上都是理论知识，为了让大家更容易理解这些理论知识，我们一起来看一些列子：

- boost
- inotify-cpp

boost 每个 lib 都调用了 project() 命令，非常符合说明本讲的知识点。

inotify-cpp 的 CMake 非常简单，也在子目录中调用了 project() 命令，也能说明本讲的一些知识点。