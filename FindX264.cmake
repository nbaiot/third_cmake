include(FindPackageHandleStandardArgs)

set(CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (X264_USE_STATIC)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "STATIC")
else ()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
    set(SHARED_OR_STATIC "SHARED")
endif ()

unset(X264_LIBRARY CACHE)
find_library(
        X264_LIBRARY
        NAMES "x264"
        PATHS ${X264_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

unset(X264_INCLUDE CACHE)
find_path(
        X264_INCLUDE_DIR
        NAMES "x264.h"
        PATHS ${X264_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

find_package_handle_standard_args(X264 DEFAULT_MSG X264_LIBRARY X264_INCLUDE_DIR)

if (X264_FOUND)
    if (NOT TARGET x264)
        add_library(x264 ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    endif ()
    set_property(TARGET x264 PROPERTY IMPORTED_LOCATION ${X264_LIBRARY})
    include_directories(${X264_INCLUDE_DIR})
    set(X264_INCLUDE_DIRS ${X264_INCLUDE_DIR})
    set(X264_LIBRARIES ${X264_LIBRARY})
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)