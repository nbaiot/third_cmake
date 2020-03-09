include(FindPackageHandleStandardArgs)

set(CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (OPUS_USE_STATIC)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "STATIC")
else ()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
    set(SHARED_OR_STATIC "SHARED")
endif ()

unset(OPUS_LIBRARY CACHE)
find_library(
        OPUS_LIBRARY
        NAMES "opus"
        PATHS ${OPUS_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

unset(OPUS_INCLUDE CACHE)
find_path(
        OPUS_INCLUDE_DIR
        NAMES "opus/opus.h"
        PATHS ${OPUS_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

find_package_handle_standard_args(OPUS DEFAULT_MSG OPUS_LIBRARY OPUS_INCLUDE_DIR)

if (OPUS_FOUND)
    if (NOT TARGET opus)
        add_library(opus ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    endif ()
    set_property(TARGET opus PROPERTY IMPORTED_LOCATION ${OPUS_LIBRARY})
    include_directories(${OPUS_INCLUDE_DIR})
    set(OPUS_INCLUDE_DIRS ${OPUS_INCLUDE_DIR})
    set(OPUS_LIBRARIES ${OPUS_LIBRARY})
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)