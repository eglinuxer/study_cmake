cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

function(someCommand)
    message("=====[${ARGC}]=======")
    message("=====[${ARGV}]=======")
    message("xxxxxxxxxxxxxxxxxxxxxxxxxxx")
endfunction()




set(containsSpace "b b")
set(containsSemiColon "b;b")

someCommand(a ${containsSpace} c)
someCommand(a ${containsSemiColon} c)

message("---------------------")

set(empty                 "")
set(space                 " ")
set(semicolon             ";")
set(semiSpace             "; ")
set(spaceSemi             " ;")
set(spaceSemiSpace        " ; ")
set(spaceSemiSemi         " ;;")
set(semiSemiSpace         ";; ")
set(spaceSemiSemiSpace    " ;; ")

someCommand(${empty})                # 0 arg
someCommand(${space})                # 1 arg
someCommand(${semicolon})            # 0 arg
someCommand(${semiSpace})            # 1 arg
someCommand(${spaceSemi})            # 1 arg
someCommand(${spaceSemiSpace})       # 2 arg
someCommand(${spaceSemiSemi})        # 1 arg
someCommand(${semiSemiSpace})        # 1 arg
someCommand(${spaceSemiSemiSpace})   # 2 args 

message("---------------------")

function(inner)
    message("inner:\n"
            "ARGC = ${ARGC}\n"
            "ARGN = ${ARGN}"
    )
endfunction()

function(outer)
    message("outer:\n"
            "ARGC = ${ARGC}\n"
            "ARGN = ${ARGN}"
    )
    cmake_parse_arguments(PARSE_ARGV 0 FWD "" "" "")
    
    set(quotedArgs "")
    foreach(arg IN LISTS FWD_UNPARSED_ARGUMENTS)
        string(APPEND quotedArgs " [===[${arg}]===]")
    endforeach()
    
    cmake_language(EVAL CODE "inner(${quotedArgs})")

endfunction()

outer("a;b;c" "d;e;f" "" " ;; ")