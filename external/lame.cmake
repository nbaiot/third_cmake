if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(LAME_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/lame)
else ()
    set(LAME_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(LAME_USE_STATIC TRUE)

find_package(LAME)

if (NOT LAME_FOUND)
    message(STATUS "now download and install lame.")
    include(${CMAKE_CURRENT_LIST_DIR}/lame_build.cmake)
else ()
    message(STATUS "find lame")
endif ()