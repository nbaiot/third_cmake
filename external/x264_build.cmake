include(ExternalProject)

set(X264_SOURCES_DIR ${THIRD_PARTY_PATH}/x264)
set(X264_INCLUDE_DIR ${X264_INSTALL_PATH}/include)

set(X264_URL "http://download.videolan.org/x264/snapshots/x264-snapshot-20191217-2245-stable.tar.bz2")

if (ANDROID)
    if (ARMEABI_V7A)
        set(X264_HOST armv7a-linux-androideabi)
    elseif (ARM64_V8A)
        set(X264_HOST aarch64-linux-android)
    elseif (X86)
        set(X264_HOST i686-linux-android)
    else (X86_64)
        set(X264_HOST x86_64-linux-android)
    endif ()
endif ()

set(BUILD_COMMON_CONFIG
        --enable-pic
        --enable-static
        --enable-shared
        )

if (ANDROID)
    set(X264_CONFIGURE_CMD
            CC=${NDK_CC}
            ./configure
            --host=${X264_HOST}
            --cross-prefix=${NDK_CROSS_PREFIX}
            --sysroot=${NDK_SYS_ROOT}
            --prefix=${X264_INSTALL_PATH}
            ${BUILD_COMMON_CONFIG}
            )
else ()
    set(X264_CONFIGURE_CMD
            ./configure
            --prefix=${X264_INSTALL_PATH}
            ${BUILD_COMMON_CONFIG}
            )
endif ()

ExternalProject_Add(
        extern_x264
        URL ${X264_URL}
        PREFIX ${X264_SOURCES_DIR}
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND
        COMMAND ${X264_CONFIGURE_CMD}
        BUILD_ALWAYS TRUE
        BUILD_COMMAND
        COMMAND make -j${CPU_COUNT}
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1
)
if (X264_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

set(X264_LIBRARY "${X264_INSTALL_PATH}/lib/libx264${LIB_SUFFIX}" CACHE FILEPATH "X264_LIBRARY" FORCE)

add_library(x264 ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET x264 PROPERTY IMPORTED_LOCATION ${X264_LIBRARY})
add_dependencies(x264 extern_x264)
include_directories(${X264_INCLUDE_DIR})
set(X264_INCLUDE_DIRS ${X264_INCLUDE_DIR})
set(X264_LIBRARIES ${X264_LIBRARY})

### restore
set(SHARED_OR_STATIC)
set(LIB_SUFFIX)