if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(FDK-AAC_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/fdk-aac)
else ()
    set(FDK-AAC_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(FDK-AAC_USE_STATIC TRUE)

find_package(FDK-AAC)

if (NOT FDK-AAC_FOUND)
    message(STATUS "now download and install fdk-aac.")
    include(${CMAKE_CURRENT_LIST_DIR}/fdk-aac_build.cmake)
else ()
    message(STATUS "find fdk-aac")
endif ()