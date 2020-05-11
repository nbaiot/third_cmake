include(FindPackageHandleStandardArgs)

set(CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (MONGODB_USE_STATIC)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "STATIC")
    set(MONGODB_NAME "mongoc-static-1.0")
    set(BSON_NAME "bson-static-1.0")
else ()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
    set(SHARED_OR_STATIC "SHARED")
    set(MONGODB_NAME "mongoc-1.0")
    set(BSON_NAME "bson-1.0")
endif ()

unset(MONGODB_LIBRARY CACHE)
find_library(
        MONGODB_LIBRARY
        NAMES ${MONGODB_NAME}
        PATHS ${MONGODB_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

unset(BSON_LIBRARY CACHE)
find_library(
        BSON_LIBRARY
        NAMES ${BSON_NAME}
        PATHS ${MONGODB_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

unset(MONGODB_INCLUDE CACHE)
find_path(MONGODB_INCLUDE
        NAMES "libmongoc-1.0"
        PATHS ${MONGODB_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
        )

unset(BSON_INCLUDE CACHE)
find_path(BSON_INCLUDE
        NAMES "libbson-1.0"
        PATHS ${MONGODB_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
        )

find_package_handle_standard_args(MongoDB DEFAULT_MSG MONGODB_LIBRARY BSON_LIBRARY MONGODB_INCLUDE BSON_INCLUDE)

if (MONGODB_FOUND)
    if (NOT TARGET mongodb)
        add_library(mongodb ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    endif ()
    if (NOT TARGET bason)
        add_library(bson ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    endif ()
    set_property(TARGET mongodb PROPERTY IMPORTED_LOCATION ${MONGODB_LIBRARY})
    set_property(TARGET bson PROPERTY IMPORTED_LOCATION ${BSON_LIBRARY})
    include_directories(${MONGODB_INCLUDE})
    include_directories(${BSON_INCLUDE})
    set(MONGODB_INCLUDE_DIRS ${MONGODB_INCLUDE})
    set(MONGODB_LIBRARIES ${BSON_LIBRARY})
    set(BSON_INCLUDE_DIRS ${BSON_INCLUDE})
    set(BSON_LIBRARIES ${MONGODB_LIBRARY})
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)