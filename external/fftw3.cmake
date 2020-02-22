if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(FFTW_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/fftw3)
else ()
    set(FFTW_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(FFTW_USE_STATIC TRUE)

find_package(FFTW3)

if (NOT FFTW3_FOUND)
    message(STATUS "now download and install fftw3.")
    include(${CMAKE_CURRENT_LIST_DIR}/fftw3_build.cmake)
else ()
    message(STATUS "find fftw3")
endif ()