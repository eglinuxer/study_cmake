#include <hello/hello.h>

#include "internal.h"

namespace hello {
    void Hello::greet() const {
        details::print_impl(m_name);
    }
}
