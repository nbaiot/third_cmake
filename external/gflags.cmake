if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(GFLAGS_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/gflags)
else ()
    set(GFLAGS_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(GFLAGS_USE_STATIC FALSE)

find_package(gflags)

if (NOT GFLAGS_FOUND)
    message(STATUS "now download and install gflags.")
    include(${CMAKE_CURRENT_LIST_DIR}/gflags_build.cmake)
else ()
    message(STATUS "find gflags")
endif ()