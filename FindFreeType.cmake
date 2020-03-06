include(FindPackageHandleStandardArgs)

set(CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (FREETYPE_USE_STATIC)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "STATIC")
else ()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
    set(SHARED_OR_STATIC "SHARED")
endif ()

unset(FREETYPE_LIBRARY CACHE)
find_library(
        FREETYPE_LIBRARY
        NAMES "freetype"
        PATHS ${FREETYPE_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

unset(FREETYPE_INCLUDE CACHE)
find_path(
        FREETYPE_INCLUDE_DIR
        NAMES "freetype2"
        PATHS ${FREETYPE_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

find_package_handle_standard_args(FREETYPE DEFAULT_MSG FREETYPE_LIBRARY FREETYPE_INCLUDE_DIR)

if (FREETYPE_FOUND)
    if (NOT TARGET freetype)
        add_library(freetype ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    endif ()
    set_property(TARGET freetype PROPERTY IMPORTED_LOCATION ${FREETYPE_LIBRARY})
    include_directories(${FREETYPE_INCLUDE_DIR})
    set(FREETYPE_INCLUDE_DIRS ${FREETYPE_INCLUDE_DIR})
    set(FREETYPE_LIBRARIES ${FREETYPE_LIBRARY})
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)