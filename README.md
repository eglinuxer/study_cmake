# CMake 工程实践指南


本仓库是我(公众号：Eglinux)为了配合出 CMake 视频教程而建立的仓库，旨在记录一些 CMake 的基础知识以及视频教程中用到的例子。

CMake 学习交流群（如果二维码失效，请加我微信：eglinuxer，备注：CMake学习）：

<img src="./doc/picture/wechat.JPG" width="50%" height="50%">

## 0. 声明
本人知识有限，其中难免有不足之处。如果你发现什么地方有问题，欢迎指正，欢迎提 pull request。

本教程使用当前最新的 CMake 版本（VERSION 3.26.3）进行讲解，如果视频更新的过程中 CMake 更新了，那我也会同步使用最新的版本进行讲解。

课程对应的文档已全面转向我的个人网站，大家可以访问 https://www.eglinux.com/cmake/ 阅读文字版本教程。

---
以下目录内容会暂停一段时间，后续更新到 https://www.eglinux.com/cmake/。

## 1. 课程计划

### **第一部分：如何构建简单的可执行文件和库文件，这部分内容足以让你快速入门 CMake**
- [第 000 讲：工欲善其事必先利其器：CMake 最佳安装方法](./doc/000_how_to_install_cmake.md)
- [第 001 讲：使用 GitHub+ vscode + CMake 快速搭建一个 CMake 管理的项目仓库](./doc/001_github+vscode+cmake_to_build_a_repo.md)
- [第 002 讲：让 CMake 管理的项目真正工作起来：vscode + CMake 调试 C/C++ 项目](./doc/002_vscode+cmake_to_debug.md)
- [第 003 讲：CMake Targets 入门：CMake 如何构建简单的 Target](./doc/003_cmake_target_basic.md)

<font color="#dddd00">第一部分视频已全部更新，大家可以前往 [B站](https://www.bilibili.com/video/BV1vL41117xz/?spm_id_from=333.788&vd_source=70001201af6c9b750ff79c4703a168a6) 进行学习。</font> 

### **第二部分：全面介绍 CMake 的基础知识，为在大型项目中使 CMake 发挥最大的价值打下坚实的基础**
<font color="#dddd00">从第二部分开始，如果和平台无关的用法，我只会在一个平台演示，如果和平台相关的用法则会到用法支持的平台进行演示。</font> 

- [第 004 讲：CMake 变量之普通变量](./doc/004_cmake_var_basic.md)
- [第 005 讲：CMake 变量之环境变量](./doc/005_cmake_var_env.md)
- [第 006 讲：CMake 变量之缓存变量](./doc/006_cmake_var_cache.md)
- [第 007 讲：CMake 变量之作用域](./doc/007_cmake_var_scope.md)
- [第 008 讲：CMake 变量总结](./doc/008_cmake_var_summarize.md)
- [第 009 讲：CMake 字符串](./doc/009_cmake_string.md)
- [第 010 讲：CMake 列表](./doc/010_cmake_list.md)
- [第 011 讲：CMake 数学计算操作](./doc/011_cmake_math.md)
- [第 012 讲：CMake 流程控制之 if() 命令](./doc/012_cmake_if.md)
- [第 013 讲：CMake 流程控制之 for 循环](./doc/013_cmake_foreach.md)
- [第 014 讲：CMake 流程控制之 while 循环](./doc/014_cmake_while.md)
- [第 015 讲：CMake 流程控制之跳出循环和继续下一次循环](./doc/015_cmake_break_continue.md)
- [第 016 讲：如何使用子目录](./doc/016_cmake_add_subdirectory.md)
- [第 017 讲：子目录相关的作用域详解](./doc/017_scope_for_subdirectory.md)
- [第 018 讲：子目录中定义 project](./doc/018_project_for_subdirectory.md)
- [第 019 讲：CMake 命令之 include](./doc/019_cmake_include.md)
- [第 020 讲：项目相关的变量详解](./doc/020_project_relative_variables.md)
- [第 021 讲：CMake 提前结束处理命令：return](./doc/021_cmake_return.md)
- [第 022 讲：CMake 函数和宏基础](./doc/022_the_basics_of_functions_and_macros.md)
- [第 023 讲：CMake 函数和宏的参数处理基础](./doc/023_argument_handling_essentials.md)
- [第 024 讲：CMake 函数和宏之关键字参数](./doc/024_keyword_arguments.md)
- [第 025 讲：函数和宏返回值详解](./doc/025_functions_andmacros_returning_values.md)
- [第 026 讲：CMake 命令覆盖详解](./doc/026_overriding_commands.md)
- [第 027 讲：函数相关的特殊变量](./doc/027_special_variables_for_functions.md)
- [第 028 讲：复用 CMake 代码的其他方法](./doc/028_othrer_ways_of_invoking_cmake_code.md)
- [第 029 讲：CMake 处理参数时的一些问题说明](./doc/029_problems_with_argument_handling.md)
- [第 030 讲：CMake 属性通用命令](./doc/030_cmake_general_property_cmd.md)
- [第 031 讲：CMake 全局属性](./doc/031_cmake_global_property.md)
- [第 032 讲：目录属性](./doc/032_cmake_directory_property.md)
- [第 033 讲：Target 属性](./doc/033_cmake_target_property.md)
- [第 034 讲：源文件属性](./doc/034_cmake_source_property.md)
- [第 035 讲：CMake 其他属性](./doc/035_cmake_other_property.md)
- 
- 努力更新中...

### **第三部分：深入 CMake，探讨 CMake 精髓**
- 待更新
### **第四部分：CMake 工程实践，你要的这里都有**
- 待更新
### **第五部分：CMake 管理的开源项目带读，TA 有，我也要有**
- 待更新
### **第六部分：CMake 项目模板**
- 待更新
## 2. 如何学习

后续课程更新提醒，答疑等都会在知识星球上进行。为什么选择知识星球，因为知识星球是一个很好的可以将问答沉淀记录下来的地方。这样同样的问题，如果其他人遇到就不用再次提问了。

<img src="./doc/picture/zhishixingqiu.jpeg" width="100%" height="100%">

答疑：优先解答付费用户的疑问，当然免费用户的疑问我也会全部解答的，只是同一时间，如果有付费用户也在问问题，我将优先解答付费用户的问题。

## 3. 其他

其他未尽事宜，待后续补充。