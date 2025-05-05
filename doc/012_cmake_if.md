# 第 012 讲：CMake 流程控制之 if() 命令
- [第 012 讲：CMake 流程控制之 if() 命令](#第-012-讲cmake-流程控制之-if-命令)
  - [1. if() 命令](#1-if-命令)

随着项目越来越复杂，我们要写的 CMake 命令也越来越多。但是某些命令其实我们只想它在特定的条件下才执行，要满足这个需求，CMake 也像其他编程语言一样提供了流程控制相关的命令。本讲我们就来学习 CMake 的 if() 命令。

## 1. if() 命令

现代 CMake 的 if() 命令格式如下：
```cmake
if(expression1)
    # commands ...
elseif(expression2)
    # commands ...
else()
    # commands ...
endif()
```
上述命令格式中，elseif 和 else 是可选的，而且 elseif 可以有多个，但都必须在 else 之前列出。

其中最重要的就是括号中的表达式，这个是用来判断要走哪个分支的关键。它有很多中形式，我们依次进行学习。

- 基本条件表达式
  
    ```cmake
    if(value)
    ```
    
    - ON、YES、TRUE、Y 被视为真
    - OFF、NO、FALSE、N、IGNORE、NOTFOUND、空字符串、以 -NOTFOUND 结尾的字符串被视为假。
    - 如果是一个数字，将根据 C 语言的规则转换成 bool 值。
    - 如果上述三种情况都不适用，那该条件表达式将被当作一个变量的名字。
        - 如果没有使用引号，那该变量的值会和为假的值对比，如果匹配上则为假，否则为真。如果其值是空字符串则为假。
        - 如果使用引号
            - cmake 3.1 及以后，如果该字符串不匹配任何为真的值，那该条件表达式为假。
            - cmake 3.1 以前，如果该字符串匹配到任何存在的变量名字，则会按照变量处理。
    - if(ENV{some_var}) 这种形式的条件表达式永远为假，所以不要使用环境变量。

- 逻辑表达式
  
    ```cmake
    # Logical operators
    if(NOT expression)
    if(expression1 AND expression2)
    if(expression1 OR expression2)
    
    # Example with parentheses
    if(NOT (expression1 AND (expression2 OR expression3)))
    ```
- 比较表达式
  
    ```cmake
    if(value1 OPERATOR value2)
    ```
    
    - OPERATOR
      
      
        | Numeric | String | Version numbers | Path |
        | --- | --- | --- | --- |
        | LESS | STRLESS | VERSION_LESS |  |
        | GREATER | STRGREATER | VERSION_GREATER |  |
        | EQUAL | STREQUAL | VERSION_EQUAL | PATH_EQUAL |
        | LESS_EQUAL | STRLESS_EQUAL | VERSION_LESS_EQUAL |  |
        | GREATER_EQUAL | STRGREATER_EQUAL | VERSION_GREATER_EQUAL |  |
        - major[.minor[.patch[.tweak]]]

- 正则表达式
  
    ```cmake
    if(value MATCHES regex)
    ```
    
    ```cmake
    if("Hi from ${who}" MATCHES "Hi from (Fred|Barney).*")
    		message("${CMAKE_MATCH_1} says hello")
    endif()
    ```

- 文件系统相关表达式
  
    ```cmake
    if(EXISTS pathToFileOrDir)
    if(IS_DIRECTORY pathToDir)
    if(IS_SYMLINK fileName)
    if(IS_ABSOLUTE path)
    if(file1 IS_NEWER_THAN file2)
    ```
    
    - 在没有变量引用符号时，不会执行任何变量替换。
    
        ```cmake
        set(firstFile "/full/path/to/somewhere")
        set(secondFile "/full/path/to/another/file")
        
        if(NOT EXISTS ${firstFile})
                message(FATAL_ERROR "${firstFile} is missing")
        elseif(NOT EXISTS ${secondFile} OR NOT ${secondFile} IS_NEWER_THAN ${firstFile})
                # ... commands to recreate secondFile
        endif()
        ```
    
    - 为什么要用 NOT IS_NEWER_THAN？
      
        ```cmake
        # WARNING: Very likely to be wrong
        if(${firstFile} IS_NEWER_THAN ${secondFile})
        		# ... commands to recreate secondFile
        endif()
        ```

- 判断是否存在表达式
  
    ```cmake
    if(DEFINED name)
    if(COMMAND name)
    if(POLICY name)
    if(TARGET name)
    if(TEST name)               # Available since CMake 3.4
    if(value IN_LIST listVar)   # Available since CMake 3.3
    ```
    
    ```cmake
    if(DEFINED SOMEVAR)           # Checks for a CMake variable (regular or cache)
    if(DEFINED CACHE{SOMEVAR})    # Checks for a CMake cache variable
    if(DEFINED ENV{SOMEVAR})      # Checks for an environment variable
    ```