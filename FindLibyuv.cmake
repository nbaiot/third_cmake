include(FindPackageHandleStandardArgs)

set(CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (LIBYUV_USE_STATIC)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "STATIC")
else ()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
    set(SHARED_OR_STATIC "SHARED")
endif ()

unset(LIBYUV_LIBRARY CACHE)
find_library(
        LIBYUV_LIBRARY
        NAMES "yuv"
        PATHS ${LIBYUV_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

unset(LIBYUV_INCLUDE CACHE)
find_path(
        LIBYUV_INCLUDE
        NAMES "libyuv.h"
        PATHS ${LIBYUV_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

find_package_handle_standard_args(Libyuv DEFAULT_MSG LIBYUV_LIBRARY LIBYUV_INCLUDE)

if (LIBYUV_FOUND)
    if (NOT TARGET libyuv)
        add_library(libyuv ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    endif ()
    set_property(TARGET libyuv PROPERTY IMPORTED_LOCATION ${LIBYUV_LIBRARY})
    include_directories(${LIBYUV_INCLUDE})
    set(LIBYUV_INCLUDE_DIRS ${LIBYUV_INCLUDE})
    set(LIBYUV_LIBRARIES ${LIBYUV_LIBRARY})
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)