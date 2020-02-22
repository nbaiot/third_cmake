INCLUDE(ExternalProject)

set(LIBUSB_SOURCES_DIR ${THIRD_PARTY_PATH}/libusb)
set(LIBUSB_INCLUDE_DIR ${LIBUSB_INSTALL_PATH}/include)

set(LIBUSB_URL "https://github.com/libusb/libusb/releases/download/v1.0.23/libusb-1.0.23.tar.bz2")


if (ANDROID)
    if (ARMEABI_V7A)
        set(LIBUSB_HOST armv7a-linux-androideabi)
    elseif (ARM64_V8A)
        set(LIBUSB_HOST aarch64-linux-android)
    elseif (X86)
        set(LIBUSB_HOST i686-linux-android)
    else (X86_64)
        set(LIBUSB_HOST x86_64-linux-android)
    endif ()
endif ()

if (APPLE)
    set(SETENV
            export "LDFLAGS=-framework IOKit -framework CoreFoundation -arch i386 -arch x86_64 "
            "CFLAGS=-arch i386 -arch x86_64 "
            &&
            )
    set(LIBUSB_CONFIGURE_CMD
            ./configure
            --prefix=${LIBUSB_INSTALL_PATH}
            #--disable-dependency-tracking
            )
elseif(ANDROID)
    set(LIBUSB_CONFIGURE_CMD
            ./configure --prefix=${LIBUSB_INSTALL_PATH}
            CC=${NDK_CC}
            CXX=${NDK_CXX}
            AR=${NDK_AR}
            AS=${NDK_AS}
            LD=${NDK_LD}
            RANLIB=${NDK_RANLIB}
            STRIP=${NDK_STRIP}
            --host ${LIBUSB_HOST}
            --disable-udev
            )
else()
    set(LIBUSB_CONFIGURE_CMD
            ./configure --prefix=${LIBUSB_INSTALL_PATH}
            )
endif()

ExternalProject_Add(
        extern_libusb
        URL ${LIBUSB_URL}
        PREFIX ${LIBUSB_SOURCES_DIR}
        CONFIGURE_COMMAND
        COMMAND ${LIBUSB_CONFIGURE_CMD}
        BUILD_ALWAYS				FALSE
        BUILD_COMMAND
        COMMAND make -j${CPU_COUNT}
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1

)

if (LIBUSB_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

set(LIBUSB_LIBRARIE ${LIBUSB_INSTALL_PATH}/lib/libusb-1.0${LIB_SUFFIX})
add_library(libusb ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET libusb PROPERTY IMPORTED_LOCATION ${LIBUSB_LIBRARIE})
add_dependencies(libusb extern_libusb)

include_directories(${LIBUSB_INCLUDE_DIR})

set(SHARED_OR_STATIC)
set(LIB_SUFFIX)
