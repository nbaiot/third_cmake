set(GLOG_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/glog)

set(GLOG_USE_STATIC TRUE)

find_package(GLog)

if (NOT GLOG_FOUND)
    message(STATUS "now download and install glog.")
    include(${CMAKE_CURRENT_LIST_DIR}/glog_build.cmake)
else ()
    message(STATUS "find glog")
endif ()