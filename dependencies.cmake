# Things that we expect will have to be built from source
include(FetchContent)
FetchContent_Declare(privateThing ...)
FetchContent_Declare(patchedDep ...)
FetchContent_MakeAvailable(privateThing patchedDep)

# Other things the developer is responsible for making
# available to us by whatever method they prefer
find_package(fmt REQUIRED)
find_package(zlib REQUIRED)
