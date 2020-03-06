if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(FREETYPE_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/freetype)
else ()
    set(FREETYPE_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(FREETYPE_USE_STATIC TRUE)

find_package(FreeType)

if (NOT FREETYPE_FOUND)
    message(STATUS "now download and install freetype.")
    include(${CMAKE_CURRENT_LIST_DIR}/freetype_build.cmake)
else ()
    message(STATUS "find freetype")
endif ()