#ifndef __HELLO_H__
#define __HELLO_H__

#include <string>

namespace hello {
    class Hello {
    public:
        Hello(const std::string& name) : m_name {name} {}

        void greet() const; 
        
    private:
        const std::string m_name;
    };
}

#endif // !__HELLO_H__

