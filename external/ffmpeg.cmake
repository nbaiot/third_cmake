if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(FFMPEG_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/ffmpeg)
else ()
    set(FFMPEG_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(FFMPEG_USE_STATIC TRUE)

find_package(FFMPEG)

if (NOT FFMPEG_FOUND)
    message(STATUS "now download and install ffmpeg.")
    include(${CMAKE_CURRENT_LIST_DIR}/ffmpeg_build.cmake)
else ()
    message(STATUS "find ffmpeg")
endif ()