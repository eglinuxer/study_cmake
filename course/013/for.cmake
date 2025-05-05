cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

foreach(num 1 2 3 4 5 6)
    message(STATUS "num = ${num}")
endforeach()

message(STATUS "---------------------------")

set(list1 A B)
set(list2)
set(foo WillNotBeShown)

foreach(loopVar IN LISTS list1 list2 ITEMS ${foo} bar)
    message("Iteration for: ${loopVar}")
endforeach()

message(STATUS "---------------------------")

set(list0 A B)
set(list1 one two)

foreach(var0 var1 IN ZIP_LISTS list0 list1)
    message("Vars: ${var0} ${var1}")
endforeach()

foreach(var IN ZIP_LISTS list0 list1)
    message("Vars: ${var_0} ${var_1}")
endforeach()

message(STATUS "---------------------------")

set(long  A B C)
set(short justOne)

foreach(varLong varShort IN ZIP_LISTS long short)
    message("Vars: ${varLong} ${varShort}")
endforeach()


message(STATUS "---------------------------")
foreach(loopVar RANGE 0 9 4)
    message(STATUS "loopVar=${loopVar}")
endforeach()