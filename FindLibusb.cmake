include(FindPackageHandleStandardArgs)

set(CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (LIBUSB_USE_STATIC)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "STATIC")
else ()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_SHARED_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "SHARED")
endif ()

find_library(
        LIBUSB_LIB
        NAMES "libusb-1.0"
        PATHS ${LIBUSB_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
)

find_path(LIBUSB_INCLUDE
        NAMES "libusb-1.0/libusb.h"
        PATHS ${LIBUSB_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        )

find_package_handle_standard_args(Libusb DEFAULT_MSG LIBUSB_INCLUDE LIBUSB_LIB)

if (LIBUSB_FOUND)
    add_library(libusb ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET libusb PROPERTY IMPORTED_LOCATION ${LIBUSB_LIB})
    include_directories(${LIBUSB_INCLUDE})
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)