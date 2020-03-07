if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(VPX_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/vpx)
else ()
    set(VPX_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

# android only support static
set(VPX_USE_STATIC TRUE)

find_package(VPX)

if (NOT VPX_FOUND)
    message(STATUS "now download and install vpx.")
    include(${CMAKE_CURRENT_LIST_DIR}/vpx_build.cmake)
else ()
    message(STATUS "find vpx")
endif ()