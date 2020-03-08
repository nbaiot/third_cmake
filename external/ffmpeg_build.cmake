INCLUDE(ExternalProject)

set(FFMPEG_SOURCES_DIR ${THIRD_PARTY_PATH}/ffmpeg)
set(FFMPEG_INCLUDE_DIR ${FFMPEG_INSTALL_PATH}/include)

set(FFMPEG_URL "https://ffmpeg.org/releases/ffmpeg-4.2.2.tar.bz2")

if (ANDROID)
    if (ARMEABI_V7A)
        set(FFMPEG_ARCH arm)
        set(FFMPEG_CPU armv7-a)
        set(EXTRA_CFLAGS "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -fno-strict-overflow -fstack-protector-all \
                          -march=armv7-a -mtune=cortex-a8 -mfloat-abi=softfp -mfpu=neon")
    elseif (ARM64_V8A)
        set(FFMPEG_ARCH arm64)
        set(FFMPEG_CPU armv8-a)
        set(EXTRA_CFLAGS "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -fno-strict-overflow -fstack-protector-all \
                          -march=armv8-a")
    elseif (X86)
        if (ANDROID_PLATFORM_LEVEL LESS 24)
            message(FATAL_ERROR ">>>>>>>>>>Android platform level must > 23 ")
        endif()
        set(FFMPEG_ARCH x86)
        set(FFMPEG_CPU x86)
        set(EXTRA_CFLAGS "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -fno-strict-overflow -fstack-protector-all \
                          -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32")
        enable_language(ASM_NASM)
    else (X86_64)
        if (ANDROID_PLATFORM_LEVEL LESS 24)
            message(FATAL_ERROR ">>>>>>>>>>Android platform level must > 23 ")
        endif()
        set(FFMPEG_ARCH x86_64)
        set(FFMPEG_CPU x86_64)
        set(EXTRA_CFLAGS "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -fno-strict-overflow -fstack-protector-all \
                          -march=x86_64 -msse4.2 -mpopcnt -m64 -mtune=intel")
        enable_language(ASM_NASM)
    endif ()
    set(EXTRA_LDFLAGS "-Wl,-z,relro -Wl,-z,now -pie -fPIE")
    set(EXTRA_LB "-l:libpng.a -lz -lm -lstdc++")
else()
    set(EXTRA_CFLAGS "-Wa,--noexecstack -fdata-sections -ffunction-sections -fstack-protector-strong")
    set(EXTRA_LDFLAGS "-Wl,--gc-sections")
    set(EXTRA_LB "-lpng -lz -lm -lpthread -lstdc++")

endif ()

set(FFMPEG_ENABLE_SHARED --enable-shared)

set(BUILD_COMMON_CONFIG
        --disable-doc
        --disable-debug
        --enable-runtime-cpudetect
        --disable-postproc
        --disable-ffplay
        --disable-ffprobe
        --disable-sdl2
        --disable-sndio
        --disable-libxcb
        --disable-libxvid
        --disable-indevs
        --enable-indev=alsa,v4l2
        --disable-outdevs
        --enable-outdev=alsa,v4l2
        --disable-filters
        --enable-filter=*fade,*fifo,*format,*resample,aeval,all*,atempo,color*,convolution,draw*,eq*,framerate,*_cuda,*v4l2*,hw*,null,scale,volume
        --enable-gpl
        --enable-nonfree
        --enable-pic
        --enable-hardcoded-tables
        --disable-avresample
        --enable-yasm
        --enable-pthreads
        --enable-libx264
        --enable-libx265
        --enable-libvpx
        --enable-libopus
        --enable-libmp3lame
        --enable-libfdk-aac
        --enable-libfreetype
        --extra-libs=${EXTRA_LB}
        )

set(EXTRA_CFLAGS  "${EXTRA_CFLAGS} -I${THIRD_PARTY_PATH}/include")
set(EXTRA_LDFLAGS  "${EXTRA_LDFLAGS} -L${THIRD_PARTY_PATH}/lib")
set(FFMPEG_PKG_CONFIG ${THIRD_PARTY_INSTALL_PATH}/lib/pkgconfig)

if (ANDROID)
    set(FFMPEG_CONFIGURE_CMD
            PKG_CONFIG_PATH=${FFMPEG_PKG_CONFIG}
            ./configure --prefix=${FFMPEG_INSTALL_PATH}
            --extra-cflags=${EXTRA_CFLAGS}
            --extra-ldflags=${EXTRA_LDFLAGS}
            --target-os=android
            --arch=${FFMPEG_ARCH}
            --cpu=${FFMPEG_CPU}
            --enable-cross-compile
            --cross-prefix=${NDK_CROSS_PREFIX}
            --enable-jni
            --enable-mediacodec
            --enable-indev=android_camera
            --enable-thumb
            --enable-neon
            --cc=${NDK_CC}
            --cxx=${NDK_CXX}
            --sysroot=${NDK_SYS_ROOT}
            --pkg-config=/usr/bin/pkg-config
#            ${FFMPEG_ENABLE_SHARED}
            ${BUILD_COMMON_CONFIG}
            )
else ()
    message(">>>>>>>>>>>>>>>>>>>>>>>>>FFMPEG_PKG_CONFIG:${FFMPEG_PKG_CONFIG}")
    set(FFMPEG_CONFIGURE_CMD
            PKG_CONFIG_PATH=${FFMPEG_PKG_CONFIG}
            ./configure --prefix=${FFMPEG_INSTALL_PATH}
            --extra-cflags=${EXTRA_CFLAGS}
            --extra-ldflags=${EXTRA_LDFLAGS}
            --pkg-config=/usr/bin/pkg-config
            ${FFMPEG_ENABLE_SHARED}
            ${BUILD_COMMON_CONFIG}
            )
endif ()

ExternalProject_Add(
        extern_ffmpeg
        DEPENDS x264 x265 vpx freetype fdk-aac lame opus
        URL ${FFMPEG_URL}
        PREFIX ${FFMPEG_SOURCES_DIR}
        CONFIGURE_COMMAND
        COMMAND ${FFMPEG_CONFIGURE_CMD}
        BUILD_ALWAYS TRUE
        BUILD_COMMAND
        COMMAND make -j${CPU_COUNT}
        INSTALL_COMMAND  make install
        BUILD_IN_SOURCE 1

)

if (FFMPEG_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

set(LIBAVCODEC_LIBRARIE ${FFMPEG_INSTALL_PATH}/lib/libavcodec${LIB_SUFFIX})
add_library(avcodec ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET avcodec PROPERTY IMPORTED_LOCATION ${LIBAVCODEC_LIBRARIE})
add_dependencies(avcodec extern_ffmpeg)

set(LIBAVDEVICE_LIBRARIE ${FFMPEG_INSTALL_PATH}/lib/libavdevice${LIB_SUFFIX})
add_library(avdevice ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET avdevice PROPERTY IMPORTED_LOCATION ${LIBAVDEVICE_LIBRARIE})
add_dependencies(avdevice extern_ffmpeg)

set(LIBAVFILTER_LIBRARIE ${FFMPEG_INSTALL_PATH}/lib/libavfilter${LIB_SUFFIX})
add_library(avfilter ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET avfilter PROPERTY IMPORTED_LOCATION ${LIBAVFILTER_LIBRARIE})
add_dependencies(avfilter extern_ffmpeg)

set(LIBAVFORMAT_LIBRARIE ${FFMPEG_INSTALL_PATH}/lib/libavformat${LIB_SUFFIX})
add_library(avformat ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET avformat PROPERTY IMPORTED_LOCATION ${LIBAVFORMAT_LIBRARIE})
add_dependencies(avformat extern_ffmpeg)

set(LIBAVUTIL_LIBRARIE ${FFMPEG_INSTALL_PATH}/lib/libavutil${LIB_SUFFIX})
add_library(avutil ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET avutil PROPERTY IMPORTED_LOCATION ${LIBAVUTIL_LIBRARIE})
add_dependencies(avutil extern_ffmpeg)

set(LIBSWRESAMPLE_LIBRARIE ${FFMPEG_INSTALL_PATH}/lib/libswresample${LIB_SUFFIX})
add_library(swresample ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET swresample PROPERTY IMPORTED_LOCATION ${LIBSWRESAMPLE_LIBRARIE})
add_dependencies(swresample extern_ffmpeg)

set(LIBSWSCALE_LIBRARIE ${FFMPEG_INSTALL_PATH}/lib/libswscale${LIB_SUFFIX})
add_library(swscale ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET swscale PROPERTY IMPORTED_LOCATION ${LIBSWSCALE_LIBRARIE})
add_dependencies(swscale extern_ffmpeg)

include_directories(${FFMPEG_INCLUDE_DIR})
set(FFMPEG_LIBS avformat avdevice avfilter avfilter avcodec swresample swscale avutil)

set(SHARED_OR_STATIC)
set(LIB_SUFFIX)
