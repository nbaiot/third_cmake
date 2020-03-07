include(ExternalProject)

set(LAME_SOURCES_DIR ${THIRD_PARTY_PATH}/lame)
set(LAME_INCLUDE_DIR ${LAME_INSTALL_PATH}/include)

set(LAME_URL "https://iweb.dl.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz")

if (ANDROID)
    if (ARMEABI_V7A)
        set(LAME_HOST armv7a-linux-androideabi)
        set(LAME_BUILD_CFLAGS "CFLAGS=-march=armv7-a -mfloat-abi=softfp -mfpu=neon")
    elseif (ARM64_V8A)
        set(LAME_HOST aarch64-linux-android)
    elseif (X86)
        set(LAME_HOST i686-linux-android)
    else (X86_64)
        set(LAME_HOST x86_64-linux-android)
    endif ()
endif ()

set(BUILD_COMMON_CONFIG
        --with-pic
        )

if (ANDROID)
    set(LAME_CONFIGURE_CMD
            CC=${NDK_CC}
            CXX=${NDK_CXX}
            AR=${NDK_AR}
            AS=${NDK_AS}
            LD=${NDK_LD}
            RANLIB=${NDK_RANLIB}
            STRIP=${NDK_STRIP}
            ${AAC_BUILD_CFLAGS}
            ./configure
            --host ${LAME_HOST}
            --with-sysroot=${NDK_SYS_ROOT}
            --prefix=${LAME_INSTALL_PATH}
            ${BUILD_COMMON_CONFIG}
            )
else ()
    set(LAME_CONFIGURE_CMD
            ./configure
            --prefix=${LAME_INSTALL_PATH}
            ${BUILD_COMMON_CONFIG}
            )
endif ()

ExternalProject_Add(
        extern_lame
        URL ${LAME_URL}
        PREFIX ${LAME_SOURCES_DIR}
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND
        COMMAND ${LAME_CONFIGURE_CMD}
        BUILD_ALWAYS FALSE
        BUILD_COMMAND
        COMMAND make -j${CPU_COUNT}
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1
)
if (LAME_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

set(LAME_LIBRARY "${LAME_INSTALL_PATH}/lib/libmp3lame${LIB_SUFFIX}" CACHE FILEPATH "LAME_LIBRARY" FORCE)

add_library(lame ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET lame PROPERTY IMPORTED_LOCATION ${LAME_LIBRARY})
add_dependencies(lame extern_lame)
include_directories(${LAME_INCLUDE_DIR})
set(LAME_INCLUDE_DIRS ${LAME_INCLUDE_DIR})
set(LAME_LIBRARIES ${LAME_LIBRARY})

### restore
set(SHARED_OR_STATIC)
set(LIB_SUFFIX)