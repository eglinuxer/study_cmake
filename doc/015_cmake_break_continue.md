# 第 015 讲：CMake 流程控制之跳出循环和继续下一次循环
- [第 015 讲：CMake 流程控制之跳出循环和继续下一次循环](#第-015-讲cmake-流程控制之跳出循环和继续下一次循环)

while 循环和 foreach 循环都支持提前退出循环，使用 break() 命令实现，也支持跳过当前循环，进入下一次循环，使用 continue() 命令实现。这两个命令的行为和 C/C++ 中同名的关键字的行为是相同的。

下面看一个例子：
```cmake
foreach(outerVar IN ITEMS a b c)
    unset(s)
    foreach(innerVar IN ITEMS 1 2 3)
        # Stop inner loop once string s gets long
        list(APPEND s "${outerVar}${innerVar}")
        string(LENGTH "${s}" length)
        if(length GREATER 5)
            # End the innerVar foreach loop early
            break()
        endif()
        # Do no more processing if outerVar is "b"
        if(outerVar STREQUAL "b")
            # End current innerVar iteration and move on to next innerVar item
            continue()
        endif()
        message("Processing ${outerVar}-${innerVar}")
    endforeach()
    message("Accumulated list: ${s}")
endforeach()
```

block() 和 endblock() 命令定义的块内也允许 break() 和 continue() 命令, 下面是一个例子：
```cmake
set(log "Value: ")
set(values one two skipMe three stopHere four)
set(didSkip FALSE)
while(NOT values STREQUAL "")
    list(POP_FRONT values next)
    # Modifications to "log" will be discarded
    block(PROPAGATE didSkip)
        string(APPEND log "${next}")
        if(next MATCHES "skip")
            set(didSkip TRUE)
            continue()
        elseif(next MATCHES "stop")
            break()
        elseif(next MATCHES "t")
            string(APPEND log ", has t")
        endif()
        message("${log}")
    endblock()
endwhile()
message("Did skip: ${didSkip}")
message("Remaining values: ${values}")
```