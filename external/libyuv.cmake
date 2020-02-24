if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(LIBYUV_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/libyuv)
else ()
    set(LIBYUV_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(LIBYUV_USE_STATIC TRUE)

find_package(Libyuv)

if (NOT LIBYUV_FOUND)
    message(STATUS "now download and install libyuv.")
    include(${CMAKE_CURRENT_LIST_DIR}/libyuv_build.cmake)
else ()
    message(STATUS "find libyuv")
endif ()