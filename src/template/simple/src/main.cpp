#include <hello/hello.h>
#include <hello_header_only/hello_header_only.h>
#include <hello_object/hello_object.h>

int main(int argc, const char* argv[])
{
    hello_header_only::print_hello("Eglinux");
    hello::Hello hello("Eglinux");
    hello.greet();

    hello_object::HelloObject hello_object("Eglinux");
    hello_object.greet();
}
