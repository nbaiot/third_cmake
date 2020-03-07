include(ExternalProject)

set(FDK-AAC_SOURCES_DIR ${THIRD_PARTY_PATH}/fdk-aac)
set(FDK-AAC_INCLUDE_DIR ${FDK-AAC_INSTALL_PATH}/include)

set(FDK-AAC_URL "https://iweb.dl.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-2.0.1.tar.gz")

if (ANDROID)
    if (ARMEABI_V7A)
        set(FDK-AAC_HOST armv7a-linux-androideabi)
        set(FDK-AAC_BUILD_CFLAGS "CFLAGS=-march=armv7-a -mfloat-abi=softfp -mfpu=neon")
    elseif (ARM64_V8A)
        set(FDK-AAC_HOST aarch64-linux-android)
    elseif (X86)
        set(FDK-AAC_HOST i686-linux-android)
    else (X86_64)
        set(FDK-AAC_HOST x86_64-linux-android)
    endif ()
endif ()

set(BUILD_COMMON_CONFIG
        --with-pic
        )

if (ANDROID)
    set(FDK-AAC_CONFIGURE_CMD
            CC=${NDK_CC}
            CXX=${NDK_CXX}
            AR=${NDK_AR}
            AS=${NDK_AS}
            LD=${NDK_LD}
            RANLIB=${NDK_RANLIB}
            STRIP=${NDK_STRIP}
            ${AAC_BUILD_CFLAGS}
            ./configure
            --host ${FDK-AAC_HOST}
            --with-sysroot=${NDK_SYS_ROOT}
            --prefix=${FDK-AAC_INSTALL_PATH}
            ${BUILD_COMMON_CONFIG}
            )
else ()
    set(FDK-AAC_CONFIGURE_CMD
            ./configure
            --prefix=${FDK-AAC_INSTALL_PATH}
            ${BUILD_COMMON_CONFIG}
            )
endif ()

ExternalProject_Add(
        extern_fdk-aac
        URL ${FDK-AAC_URL}
        PREFIX ${FDK-AAC_SOURCES_DIR}
        UPDATE_COMMAND ""
        PATCH_COMMAND ${EXTERNAL_PATCH_PATH}/patch-manager.sh fdk-aac
        CONFIGURE_COMMAND
        COMMAND ${FDK-AAC_CONFIGURE_CMD}
        BUILD_ALWAYS FALSE
        BUILD_COMMAND
        COMMAND make -j${CPU_COUNT}
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1
)
if (FDK-AAC_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

set(FDK-AAC_LIBRARY "${FDK-AAC_INSTALL_PATH}/lib/libfdk-aac${LIB_SUFFIX}" CACHE FILEPATH "FDK-AAC_LIBRARY" FORCE)

add_library(fdk-aac ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET fdk-aac PROPERTY IMPORTED_LOCATION ${FDK-AAC_LIBRARY})
add_dependencies(fdk-aac extern_fdk-aac)
include_directories(${FDK-AAC_INCLUDE_DIR})
set(FDK-AAC_INCLUDE_DIRS ${FDK-AAC_INCLUDE_DIR})
set(FDK-AAC_LIBRARIES ${FDK-AAC_LIBRARY})

### restore
set(SHARED_OR_STATIC)
set(LIB_SUFFIX)