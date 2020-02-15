
find_package(FFTW3)

if (NOT FFTW3_FOUND)
    message(STATUS "not find fftw3, now download and install it.")
    include(${CMAKE_CURRENT_LIST_DIR}/fftw3_build.cmake)
else ()
    message(STATUS "find fftw3")
endif ()