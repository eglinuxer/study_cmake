#ifndef __HELLO_H__
#define __HELLO_H__

#include "hello/export_hello.h"

#include <string>

namespace hello {
    /// Example class that is explicitly exported into a dll
    class HELLO_SHARED_EXPORT Hello {
    public:
        Hello(const std::string& name) : m_name { name } {}

        void greet() const; 
    private:
        const std::string m_name;
    };
}

#endif // !__HELLO_H__

