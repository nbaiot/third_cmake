if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(JPEG_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/jpeg-turbo)
else ()
    set(JPEG_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(JPEG_USE_STATIC TRUE)

find_package(JPEG)

if (NOT JPEG_FOUND)
    message(STATUS "now download and install jpeg-turbo.")
    include(${CMAKE_CURRENT_LIST_DIR}/jpeg_build.cmake)
else ()
    message(STATUS "find jpeg-turbo")
endif ()