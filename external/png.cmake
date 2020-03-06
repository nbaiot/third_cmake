if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(PNG_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/png)
else ()
    set(PNG_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

# freetype depend it
set(PNG_USE_STATIC TRUE)

find_package(PNG)

if (NOT PNG_FOUND)
    message(STATUS "now download and install png.")
    include(${CMAKE_CURRENT_LIST_DIR}/png_build.cmake)
else ()
    message(STATUS "find png")
endif ()