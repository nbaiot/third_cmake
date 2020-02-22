include(FindPackageHandleStandardArgs)

set(CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (${GFLAGS_USE_STATIC})
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "STATIC")
else ()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_SHARED_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "SHARED")
endif ()

find_library(
        GFLAGS_LIBRARY
        NAMES "gflags"
        PATHS ${GFLAGS_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
)

find_path(GFLAGS_INCLUDE
        NAMES "gflags/gflags.h"
        PATHS ${GFLAGS_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        )

find_package_handle_standard_args(gflags DEFAULT_MSG GFLAGS_LIBRARY GFLAGS_INCLUDE)

if (GFLAGS_FOUND)
    add_library(gflags ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET gflags PROPERTY IMPORTED_LOCATION ${GFLAGS_LIB})
    include_directories(${GFLAGS_INCLUDE})
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)