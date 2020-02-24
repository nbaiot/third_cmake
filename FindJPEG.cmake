include(FindPackageHandleStandardArgs)

set(CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (JPEG_USE_STATIC)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "STATIC")
else ()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_SHARED_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "SHARED")
endif ()

unset(JPEG_LIBRARY CACHE)
find_library(
        JPEG_LIBRARY
        NAMES "turbojpeg"
        PATHS ${JPEG_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

unset(JPEG_INCLUDE CACHE)
find_path(
        JPEG_INCLUDE
        NAMES "turbojpeg.h"
        PATHS ${JPEG_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

find_package_handle_standard_args(JPEG DEFAULT_MSG JPEG_LIBRARY JPEG_INCLUDE)

if (JPEG_FOUND)
    if (NOT TARGET jpeg-turbo)
        add_library(jpeg-turbo ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    endif ()
    set_property(TARGET jpeg-turbo PROPERTY IMPORTED_LOCATION ${JPEG_LIBRARY})
    include_directories(${JPEG_INCLUDE})
    set(JPEG_INCLUDE_DIRS ${JPEG_INCLUDE})
    set(JPEG_LIBRARIES ${JPEG_LIBRARY})
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)