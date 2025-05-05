cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

set(x 3)
set(y 7)
math(EXPR zDec "(${x}+${y}) * 2")
message("decimal = ${zDec}")

# Requires CMake 3.13 or later for HEXADECIMAL
math(EXPR zHex "(${x}+${y}) * 2" OUTPUT_FORMAT HEXADECIMAL)
message("hexadecimal = ${zHex}")