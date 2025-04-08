#ifndef __HEADER_ONLY_H__
#define __HEADER_ONLY_H__

#include <iostream>
#include <string>

namespace header_only
{
    inline void print_hello(const std::string& name) {
        std::cout << "Hello " << name << " from a header only library" << std::endl;
    }
}

#endif // !__HEADER_ONLY_H__

