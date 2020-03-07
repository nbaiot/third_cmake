if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(X264_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/x264)
else ()
    set(X264_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(X264_USE_STATIC TRUE)

find_package(X264)

if (NOT X264_FOUND)
    message(STATUS "now download and install x264.")
    include(${CMAKE_CURRENT_LIST_DIR}/x264_build.cmake)
else ()
    message(STATUS "find x264")
endif ()