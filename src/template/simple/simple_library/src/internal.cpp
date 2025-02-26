#include "internal.h"

#include <iostream>

namespace hello::details { 
    void print_impl(const std::string& name)
    {
        std::cout << "Hello " << name << " from a shared library" << std::endl;
    }
}
