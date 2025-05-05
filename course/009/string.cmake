cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

string(FIND "abcdefabcdef" "def" fwdIndex)
string(FIND "abcdefabcdef" "def" revIndex REVERSE)
message("fwdIndex = ${fwdIndex}\n"
        "revIndex = ${revIndex}")


message(STATUS "------------------------------")

string(REPLACE "abc" "cba" outVar "abc-abc-abc")
message(STATUS "outVar=${outVar}")

message(STATUS "------------------------------")

string(REGEX MATCH    "[ace]"           matchOne abcdefabcdef)
string(REGEX MATCHALL "[ace]"           matchAll abcdefabcdef)
string(REGEX REPLACE  "([de])" "X\\1Y"  replVar1 abc def abc def)
string(REGEX REPLACE  "([de])" [==[X\1Y]==] replVar2 abcdefabcdef)
message("matchOne = ${matchOne}\n"
        "matchAll = ${matchAll}\n"
        "replVar1 = ${replVar1}\n"
        "replVar2 = ${replVar2}")

message(STATUS "------------------------------")
string(SUBSTRING "abcdef" 2 -1 outVar)
message(STATUS "outVar=${outVar}")


message(STATUS "------------------------------")
string(LENGTH  "abcdef" outVar)
message(STATUS "outVar=<${outVar}>")
string(TOLOWER "abSGJDKcdef" outVar)
message(STATUS "outVar=<${outVar}>")
string(TOUPPER "abcAAAdef" outVar)
message(STATUS "outVar=<${outVar}>")
string(STRIP   "   abcdef   " outVar)
message(STATUS "outVar=<${outVar}>")


message(STATUS "------------------------------")
string(TIMESTAMP TIMESTAMP)
message(STATUS "TIMESTAMP=${TIMESTAMP}")