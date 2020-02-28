if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(EIGEN3_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/ffmpeg)
else ()
    set(EIGEN3_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

find_package(Eigen3)

if (NOT EIGEN3_FOUND)
    message(STATUS "now download and install eigen3.")
    include(${CMAKE_CURRENT_LIST_DIR}/eigen3_build.cmake)
else ()
    message(STATUS "find eigen3")
endif ()