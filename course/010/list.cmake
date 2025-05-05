cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

#[===[

list(LENGTH listVar outVar)
list(GET listVar index [index...] outVar)

list(INSERT listVar index item [item...])
list(APPEND listVar item [item...])
list(PREPEND listVar item [item...]) # Requires CMake 3.15 or later

list(FIND myList value outVar)

list(REMOVE_ITEM myList value [value...])
list(REMOVE_AT myList index [index...])
list(REMOVE_DUPLICATES myList)

# Requires CMake 3.15 or later
list(POP_FRONT myList [outVar1 [outVar2...]])
list(POP_BACK myList [outVar1 [outVar2...]])

list(REVERSE myList)
list(SORT myList [COMPARE method] [CASE case] [ORDER order])
# method 必须是如下之一：
STRING
FILE_BASENAME
NATURAL：和 STRING 类似，只不过连续的数字要按照数字的大小来排序
# CASE 是 SENSITIVE 或者 INSENSITIVE
# ORDER 是 ASCENDING 或者 DESCENDING

]===]


set(listVar a;b;c;d;e;f;g)
list(LENGTH listVar outVar)
message(STATUS "outVar=${outVar}")

message(STATUS "------------------------------")

list(GET listVar -7 outVar)
message(STATUS "outVar=${outVar}")

message(STATUS "------------------------------")
list(INSERT listVar 0 "H" "E" "K")
message(STATUS "listVar=${listVar}")

list(APPEND listVar "C" "M" "a" "k" "e")
list(PREPEND listVar "H" "E" "L" "L" "O")
message(STATUS "listVar=${listVar}")

message(STATUS "------------------------------")
list(FIND listVar "H" outVar)
message(STATUS "outVar=${outVar}")

message(STATUS "------------------------------")
message(STATUS "listVar=${listVar}")
list(REMOVE_ITEM listVar a b c d)
message(STATUS "listVar=${listVar}")
list(REMOVE_AT listVar 2 3)
message(STATUS "listVar=${listVar}")
list(REMOVE_DUPLICATES listVar)
message(STATUS "listVar=${listVar}")

message(STATUS "------------------------------")
message(STATUS "listVar=${listVar}")
list(POP_FRONT listVar)
message(STATUS "listVar=${listVar}")
list(POP_FRONT listVar outVar1 outVar2)
message(STATUS "listVar=${listVar}")
message(STATUS "outVar1=${outVar1}")
message(STATUS "outVar2=${outVar2}")

list(POP_BACK listVar)
list(POP_BACK listVar outVar1 outVar2)
message(STATUS "listVar=${listVar}")
message(STATUS "outVar1=${outVar1}")
message(STATUS "outVar2=${outVar2}")

message(STATUS "------------------------------")
set(listVar a A B b C c D d 1 2 3)
message(STATUS "listVar=${listVar}")
list(REVERSE listVar)
message(STATUS "listVar=${listVar}")

# list(SORT listVar [COMPARE method] [CASE case] [ORDER order])
list(SORT listVar)
message(STATUS "listVar=${listVar}")

message(STATUS "------------------------------")
list(SORT listVar COMPARE NATURAL)
message(STATUS "listVar=${listVar}")

message(STATUS "------------------------------")
list(SORT listVar CASE INSENSITIVE)
message(STATUS "listVar=${listVar}")

message(STATUS "------------------------------")
list(SORT listVar ORDER DESCENDING)
message(STATUS "listVar=${listVar}")

message(STATUS "------------------------------")
set(noBrackets "a_a" "b_b")
set(withBrackets "a[a" "b]b")

list(LENGTH noBrackets lenNo)
list(LENGTH withBrackets lenWith)

list(GET noBrackets 0 firstNo)
list(GET withBrackets 0 firstWith)
message("No brackets: Length=${lenNo} --> First_element=${firstNo}")
message("With brackets: Length=${lenWith} --> First_element=${firstWith}")

