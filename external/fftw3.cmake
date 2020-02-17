
set(FFTW_ROOT ${THIRD_PARTY_INSTALL_PATH}/fftw3)

set(FFTW_USE_STATIC TRUE)

find_package(FFTW3)

if (NOT FFTW3_FOUND)
    message(STATUS "now download and install fftw3.")
    include(${CMAKE_CURRENT_LIST_DIR}/fftw3_build.cmake)
else ()
    message(STATUS "find fftw3")
endif ()