set(CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (${FFTW_USE_STATIC})
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "STATIC")
else ()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
    set(SHARED_OR_STATIC "SHARED")
endif ()

unset(FFTW_LIB CACHE)
find_library(
        FFTW_LIB
        NAMES "fftw3"
        PATHS ${FFTW_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

unset(FFTW_THREAD_LIB CACHE)
find_library(
        FFTW_THREAD_LIB
        NAMES "fftw3_threads"
        PATHS ${FFTW_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

unset(FFTW_FLOAT_LIB CACHE)
find_library(
        FFTW_FLOAT_LIB
        NAMES "fftw3f"
        PATHS ${FFTW_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

unset(FFTW_THREAD_FLOAT_LIB CACHE)
find_library(
        FFTW_THREAD_FLOAT_LIB
        NAMES "fftw3f_threads"
        PATHS ${FFTW_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
)

unset(FFTW_INCLUDE CACHE)
find_path(FFTW_INCLUDE
        NAMES "fftw3.h"
        PATHS ${FFTW_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
        )

if (EXISTS ${FFTW_FLOAT_LIB})

    if (NOT TARGET fftw3f)
        add_library(fftw3f ${SHARED_OR_STATIC} IMPORTED GLOBAL)
        set_property(TARGET fftw3 PROPERTY IMPORTED_LOCATION ${FFTW_FLOAT_LIB})
    endif ()

    if (NOT TARGET fftw3f_thread)
        add_library(fftw3f_thread ${SHARED_OR_STATIC} IMPORTED GLOBAL)
        set_property(TARGET fftw3f_thread PROPERTY IMPORTED_LOCATION ${FFTW_THREAD_FLOAT_LIB})
    endif ()

    set(FFTW3_FOUND TRUE)
    include_directories(${FFTW_INCLUDE})
else ()
    set(FFTW3_FOUND FALSE)
endif ()

if (EXISTS ${FFTW_LIB})
    if (NOT TARGET fftw3)
        add_library(fftw3 ${SHARED_OR_STATIC} IMPORTED GLOBAL)
        set_property(TARGET fftw3 PROPERTY IMPORTED_LOCATION ${FFTW_LIB})
    endif ()

    if (NOT TARGET fftw3_thread)
        add_library(fftw3_thread ${SHARED_OR_STATIC} IMPORTED GLOBAL)
        set_property(TARGET fftw3_thread PROPERTY IMPORTED_LOCATION ${FFTW_THREAD_LIB})
    endif ()

    set(FFTW3_FOUND TRUE)
    include_directories(${FFTW_INCLUDE})
else ()
    set(FFTW3_FOUND FALSE)
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)