if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(OPUS_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/opus)
else ()
    set(OPUS_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

# freetype depend it
set(OPUS_USE_STATIC TRUE)

find_package(OPUS)

if (NOT OPUS_FOUND)
    message(STATUS "now download and install opus.")
    include(${CMAKE_CURRENT_LIST_DIR}/opus_build.cmake)
else ()
    message(STATUS "find opus")
endif ()