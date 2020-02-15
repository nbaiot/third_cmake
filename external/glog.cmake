
find_package(GLog)

if (NOT GLog_FOUND)
    message(STATUS "not find Glog, now download and install it.")
    include(${CMAKE_CURRENT_LIST_DIR}/glog_build.cmake)
else ()
    message(STATUS "find glog")
endif ()