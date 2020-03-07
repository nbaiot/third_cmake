include(ExternalProject)

set(PNG_SOURCES_DIR ${THIRD_PARTY_PATH}/png)
set(PNG_INCLUDE_DIR ${PNG_INSTALL_PATH}/include)

set(PNG_REPOSITORY "https://github.com/glennrp/libpng.git")
set(PNG_TAG "v1.6.37")

if (ANDROID)
    if (ARMEABI_V7A)
        set(PNG_HOST armv7a-linux-androideabi)
        set(PNG_BUILD_CFLAGS "CFLAGS=-march=armv7-a -mfloat-abi=softfp -mfpu=neon")
    elseif (ARM64_V8A)
        set(PNG_HOST aarch64-linux-android)
    elseif (X86)
        set(PNG_HOST i686-linux-android)
    else (X86_64)
        set(PNG_HOST x86_64-linux-android)
    endif ()
endif ()

if (ANDROID)
    set(PNG_CONFIGURE_CMD
            ./configure
            CC=${NDK_CC}
            CXX=${NDK_CXX}
            AR=${NDK_AR}
            AS=${NDK_AS}
            LD=${NDK_LD}
            RANLIB=${NDK_RANLIB}
            STRIP=${NDK_STRIP}
            --host ${PNG_HOST}
            --prefix=${PNG_INSTALL_PATH}
            --with-sysroot=${NDK_SYS_ROOT}
            --with-pic
            --enable-arm-neon
            --enable-hardware-optimizations
            )
else ()
    set(PNG_CONFIGURE_CMD
            ./configure
            --prefix=${PNG_INSTALL_PATH}
            --with-pic
            --enable-hardware-optimizations
            )
endif ()

ExternalProject_Add(
        extern_png
        GIT_REPOSITORY ${PNG_REPOSITORY}
        GIT_TAG ${PNG_TAG}
        PREFIX ${PNG_SOURCES_DIR}
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND
        COMMAND ${PNG_CONFIGURE_CMD}
        BUILD_ALWAYS FALSE
        BUILD_COMMAND
        COMMAND make ${PNG_BUILD_CFLAGS} -j${CPU_COUNT}
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1
)
if (PNG_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

set(PNG_LIBRARY "${PNG_INSTALL_PATH}/lib/libpng${LIB_SUFFIX}" CACHE FILEPATH "PNG_LIBRARY" FORCE)

add_library(png ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET png PROPERTY IMPORTED_LOCATION ${PNG_LIBRARY})
add_dependencies(png extern_png)
include_directories(${PNG_INCLUDE_DIR})
set(PNG_INCLUDE_DIRS ${PNG_INCLUDE_DIR})
set(PNG_LIBRARIES ${PNG_LIBRARY})

### restore
set(SHARED_OR_STATIC)
set(LIB_SUFFIX)