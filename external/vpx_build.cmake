include(ExternalProject)

set(VPX_SOURCES_DIR ${THIRD_PARTY_PATH}/vpx)
set(VPX_INCLUDE_DIR ${VPX_INSTALL_PATH}/include)

set(VPX_REPOSITORY "https://github.com/webmproject/libvpx.git")
set(VPX_TAG "v1.8.2")

set(BUILD_COMMON_CONFIG
        --disable-examples
        --disable-unit-tests
        --enable-vp9-highbitdepth
        )

if (ANDROID)
    set(BUILD_COMMON_CONFIG
            ${BUILD_COMMON_CONFIG}
            --enable-postproc
            --enable-temporal-denoising
            --enable-multi-res-encoding
            --disable-install-srcs
            --disable-install-docs
            --disable-runtime-cpu-detect
            --disable-install-docs
            )
    if (ARMEABI_V7A)
        set(VPX_TARGET armv7-android-gcc)
    elseif (ARM64_V8A)
        set(VPX_TARGET arm64-android-gcc)
    elseif (X86)
        set(VPX_TARGET x86-android-gcc)
        enable_language(ASM_NASM)
        set(BUILD_COMMON_CONFIG
                ${BUILD_COMMON_CONFIG}
                --as=nasm
                )
    else (X86_64)
        set(VPX_TARGET x86_64-android-gcc)
        enable_language(ASM_NASM)
        set(BUILD_COMMON_CONFIG
                ${BUILD_COMMON_CONFIG}
                --as=nasm
                )
    endif ()
else ()
    set(BUILD_COMMON_CONFIG
            ${BUILD_COMMON_CONFIG}
            --enable-shared
            --as=yasm
            )
endif ()

if (ANDROID)
    set(VPX_CONFIGURE_CMD
            CC=${NDK_CC}
            CXX=${NDK_CXX}
            AR=${NDK_AR}
            AS=${NDK_AS}
            LD=${NDK_LD}
            STRIP=${NDK_STRIP}
            ./configure
            --target=${VPX_TARGET}
            --prefix=${VPX_INSTALL_PATH}
            ${BUILD_COMMON_CONFIG}
            )
else ()
    set(VPX_CONFIGURE_CMD
            ./configure
            --prefix=${VPX_INSTALL_PATH}
            ${BUILD_COMMON_CONFIG}
            )
endif ()

ExternalProject_Add(
        extern_vpx
        GIT_REPOSITORY ${VPX_REPOSITORY}
        GIT_TAG ${VPX_TAG}
        PREFIX ${VPX_SOURCES_DIR}
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND
        COMMAND ${VPX_CONFIGURE_CMD}
        BUILD_ALWAYS FALSE
        BUILD_COMMAND
        COMMAND make -j${CPU_COUNT}
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1
)

if (VPX_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

set(VPX_LIBRARY "${VPX_INSTALL_PATH}/lib/libvpx${LIB_SUFFIX}" CACHE FILEPATH "VPX_LIBRARY" FORCE)

add_library(vpx ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET vpx PROPERTY IMPORTED_LOCATION ${VPX_LIBRARY})
add_dependencies(vpx extern_vpx)
include_directories(${VPX_INCLUDE_DIR})
set(VPX_INCLUDE_DIRS ${VPX_INCLUDE_DIR})
set(VPX_LIBRARIES ${VPX_LIBRARY})

### restore
set(SHARED_OR_STATIC)
set(LIB_SUFFIX)