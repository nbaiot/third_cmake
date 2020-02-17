set(GFLAGS_ROOT ${THIRD_PARTY_INSTALL_PATH}/gflags)

set(GFLAGS_USE_STATIC TRUE)

find_package(gflags)

if (NOT GFLAGS_FOUND)
    message(STATUS "now download and install gflags.")
    include(${CMAKE_CURRENT_LIST_DIR}/gflags_build.cmake)
else ()
    message(STATUS "find gflags")
endif ()