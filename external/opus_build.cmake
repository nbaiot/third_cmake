include(ExternalProject)

set(OPUS_SOURCES_DIR ${THIRD_PARTY_PATH}/png)
set(OPUS_INCLUDE_DIR ${OPUS_INSTALL_PATH}/include)

set(OPUS_URL "https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz")

if (ANDROID)
    if (ARMEABI_V7A)
        set(OPUS_HOST armv7a-linux-androideabi)
        set(OPUS_BUILD_CFLAGS "CFLAGS=-march=armv7-a -mfloat-abi=softfp -mfpu=neon")
    elseif (ARM64_V8A)
        set(OPUS_HOST aarch64-linux-android)
    elseif (X86)
        set(OPUS_HOST i686-linux-android)
    else (X86_64)
        set(OPUS_HOST x86_64-linux-android)
    endif ()
endif ()

if (ANDROID)
    set(OPUS_CONFIGURE_CMD
            ./configure
            CC=${NDK_CC}
            CXX=${NDK_CXX}
            AR=${NDK_AR}
            AS=${NDK_AS}
            LD=${NDK_LD}
            RANLIB=${NDK_RANLIB}
            STRIP=${NDK_STRIP}
            --host ${OPUS_HOST}
            --prefix=${OPUS_INSTALL_PATH}
            --with-sysroot=${NDK_SYS_ROOT}
            --with-pic
            )
else ()
    set(OPUS_CONFIGURE_CMD
            ./configure
            --prefix=${OPUS_INSTALL_PATH}
            --with-pic
            )
endif ()

ExternalProject_Add(
        extern_opus
        URL ${OPUS_URL}
        PREFIX ${OPUS_SOURCES_DIR}
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND
        COMMAND ${OPUS_CONFIGURE_CMD}
        BUILD_ALWAYS FALSE
        BUILD_COMMAND
        COMMAND make ${OPUS_BUILD_CFLAGS} -j${CPU_COUNT}
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1
)
if (OPUS_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

set(OPUS_LIBRARY "${OPUS_INSTALL_PATH}/lib/libopus${LIB_SUFFIX}" CACHE FILEPATH "OPUS_LIBRARY" FORCE)

add_library(opus ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET opus PROPERTY IMPORTED_LOCATION ${OPUS_LIBRARY})
add_dependencies(opus extern_opus)
include_directories(${OPUS_INCLUDE_DIR})
set(OPUS_INCLUDE_DIRS ${OPUS_INCLUDE_DIR})
set(OPUS_LIBRARIES ${OPUS_LIBRARY})

### restore
set(SHARED_OR_STATIC)
set(LIB_SUFFIX)