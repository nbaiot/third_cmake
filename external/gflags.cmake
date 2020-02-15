
find_package(GFlags)

if (NOT GFlags_FOUND)
    message(STATUS "not find Gflags, now download and install it.")
    include(${CMAKE_CURRENT_LIST_DIR}/gflags_build.cmake)
else ()
    message(STATUS "find gflags")
endif ()