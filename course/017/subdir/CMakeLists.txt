cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

message("Child  (before): myVar    = ${myVar}")
message("Child  (before): childVar = ${childVar}")

set(myVar bar PARENT_SCOPE)
set(childVar fuzz PARENT_SCOPE)

message("Child  (after):  myVar    = ${myVar}")
message("Child  (after):  childVar = ${childVar}")