if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(ZSTD_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/zstd)
else ()
    set(ZSTD_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(ZSTD_USE_STATIC TRUE)

find_package(Zstd)

if (NOT ZSTD_FOUND)
    message(STATUS "now download and install zstd.")
    include(${CMAKE_CURRENT_LIST_DIR}/zstd_build.cmake)
else ()
    message(STATUS "find ZSTD")
endif ()