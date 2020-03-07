if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(X265_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/x265)
else ()
    set(X265_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(X265_USE_STATIC TRUE)

find_package(X265)

if (NOT X265_FOUND)
    message(STATUS "now download and install x265.")
    include(${CMAKE_CURRENT_LIST_DIR}/x265_build.cmake)
else ()
    message(STATUS "find x265")
endif ()