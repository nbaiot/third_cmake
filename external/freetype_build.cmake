include(ExternalProject)

set(FREETYPE_SOURCES_DIR ${THIRD_PARTY_PATH}/freetype)
set(FREETYPE_INCLUDE_DIR ${FREETYPE_INSTALL_PATH}/include)

set(FREETYPE_URL "https://download.savannah.gnu.org/releases/freetype/freetype-2.10.0.tar.bz2")

if (ANDROID)
    if (ARMEABI_V7A)
        set(FREETYPE_HOST armv7a-linux-androideabi)
        set(PNG_BUILD_CFLAGS "CFLAGS=-march=armv7-a -mfloat-abi=softfp -mfpu=neon")
    elseif (ARM64_V8A)
        set(FREETYPE_HOST aarch64-linux-android)
    elseif (X86)
        set(FREETYPE_HOST i686-linux-android)
    else (X86_64)
        set(FREETYPE_HOST x86_64-linux-android)
    endif ()
endif ()

if (ANDROID)
    set(FREETYPE_CONFIGURE_CMD
            ./configure
            CC=${NDK_CC}
            AR=${NDK_AR}
            AS=${NDK_AS}
            LD=${NDK_LD}
            LIBPNG_LIBS=${PNG_LIBRARY}
            RANLIB=${NDK_RANLIB}
            STRIP=${NDK_STRIP}
            --host ${FREETYPE_HOST}
            --prefix=${FREETYPE_INSTALL_PATH}
            --with-sysroot=${NDK_SYS_ROOT}
            --with-harfbuzz=no
            --with-pic
            )
else ()
    set(FREETYPE_CONFIGURE_CMD
            ./configure
            LIBPNG_LIBS=${PNG_LIBRARY}
            --prefix=${FREETYPE_INSTALL_PATH}
            --with-pic
            --with-harfbuzz=no
            )
endif ()

ExternalProject_Add(
        extern_freetype
        DEPENDS png
        URL ${FREETYPE_URL}
        PREFIX ${FREETYPE_SOURCES_DIR}
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND
        COMMAND ${FREETYPE_CONFIGURE_CMD}
        BUILD_ALWAYS FALSE
        BUILD_COMMAND
        COMMAND make  -j${CPU_COUNT}
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1
)

if (FREETYPE_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

set(FREETYPE_LIBRARY "${FREETYPE_INSTALL_PATH}/lib/libfreetype${LIB_SUFFIX}" CACHE FILEPATH "FREETYPE_LIBRARY" FORCE)

add_library(freetype ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET freetype PROPERTY IMPORTED_LOCATION ${FREETYPE_LIBRARY})
add_dependencies(freetype extern_freetype)
include_directories(${FREETYPE_INCLUDE_DIR})
set(FREETYPE_INCLUDE_DIRS ${FREETYPE_INCLUDE_DIR})
set(FREETYPE_LIBRARIES ${FREETYPE_LIBRARY})

### restore
set(SHARED_OR_STATIC)
set(LIB_SUFFIX)