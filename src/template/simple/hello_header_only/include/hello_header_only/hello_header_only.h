#ifndef __HELLO_HEADER_ONLY_H__
#define __HELLO_HEADER_ONLY_H__

#include <iostream>
#include <string>

namespace hello_header_only
{
    void print_hello(const std::string& name) {
        std::cout << "Hello " << name << " from a header only library" << std::endl;
    }
}

#endif // !__HELLO_HEADER_ONLY_H__
