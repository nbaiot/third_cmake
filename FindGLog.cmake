include(FindPackageHandleStandardArgs)

set(CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (GLOG_USE_STATIC)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "STATIC")
else ()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_SHARED_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "SHARED")
endif ()

find_library(
        GLOG_LIBRARY
        NAMES "glog"
        PATHS ${GLOG_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
)

find_path(GLOG_INCLUDE
        NAMES "glog/logging.h"
        PATHS ${GLOG_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        )

find_package_handle_standard_args(glog DEFAULT_MSG GLOG_LIBRARY GLOG_INCLUDE)

if (GLOG_FOUND)
    add_library(glog ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET glog PROPERTY IMPORTED_LOCATION ${GLOG_LIBRARY})
    include_directories(${GLOG_INCLUDE})
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)