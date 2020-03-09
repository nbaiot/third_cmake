include(FindPackageHandleStandardArgs)

set(CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (FDK-AAC_USE_STATIC)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "STATIC")
else ()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
    set(SHARED_OR_STATIC "SHARED")
endif ()

unset(FDK-AAC_LIBRARY CACHE)
find_library(
        FDK-AAC_LIBRARY
        NAMES "fdk-aac"
        PATHS ${FDK-AAC_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

unset(FDK-AAC_INCLUDE CACHE)
find_path(
        FDK-AAC_INCLUDE_DIR
        NAMES "fdk-aac"
        PATHS ${FDK-AAC_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

find_package_handle_standard_args(FDK-AAC DEFAULT_MSG FDK-AAC_LIBRARY FDK-AAC_INCLUDE_DIR)

if (FDK-AAC_FOUND)
    if (NOT TARGET fdk-aac)
        add_library(fdk-aac ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    endif ()
    set_property(TARGET fdk-aac PROPERTY IMPORTED_LOCATION ${FDK-AAC_LIBRARY})
    include_directories(${FDK-AAC_INCLUDE_DIR})
    set(FDK-AAC_INCLUDE_DIRS ${FDK-AAC_INCLUDE_DIR})
    set(FDK-AAC_LIBRARIES ${FDK-AAC_LIBRARY})
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)