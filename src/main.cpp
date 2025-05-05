#include <iostream>
#include <filesystem>
#include <fstream>
#include <vector>
#include <nlohmann/json.hpp>

#include "add.h"

using json_t = nlohmann::json;

int main()
{
    int a = 1;
    int b = 2;

    std::cout << study::add(a, b) << std::endl;

    auto j = R"(
    {
        "happy": true,
        "pi": 3.141
    }
    )"_json;

    std::string s = j.dump();

    std::cout << s << std::endl;
}