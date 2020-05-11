if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(MONGODB_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/mongodb)
else ()
    set(MONGODB_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(MONGODB_USE_STATIC TRUE)

find_package(MongoDB)

if (NOT MONGODB_FOUND)
    message(STATUS "now download and install mongodb.")
    include(${CMAKE_CURRENT_LIST_DIR}/mongodb_build.cmake)
else ()
    message(STATUS "find mongodb")
endif ()