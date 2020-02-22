include(ExternalProject)

set(JPEG_SOURCES_DIR ${THIRD_PARTY_PATH}/jpeg-turbo)
set(JPEG_INCLUDE_DIR ${JPEG_INSTALL_PATH}/include)

set(JPEG_URL "https://cfhcable.dl.sourceforge.net/project/libjpeg-turbo/2.0.4/libjpeg-turbo-2.0.4.tar.gz")

if (ANDROID)
    set(ANDROID_ABI_ARG -DANDROID_ABI=${ANDROID_ABI})
    set(ANDROID_PLATFORM_ARG -DANDROID_PLATFORM=${ANDROID_PLATFORM})
    set(ANDROID_NDK_ARG -DANDROID_NDK=${ANDROID_NDK})
    set(ANDROID_TOOLCHAIN_FILE_ARG -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE})

    if (ARMEABI_V7A)
        set(JEPG_ARM_MODE "-DANDROID_ARM_MODE=arm")
        set(JEPG_ASM_FLAGS "-DCMAKE_ASM_FLAGS=\"--target=arm-linux-androideabi${ANDROID_PLATFORM_LEVEL}\"")
    elseif (ARM64_V8A)
        set(JEPG_ARM_MODE "-DANDROID_ARM_MODE=arm")
        set(JEPG_ASM_FLAGS "-DCMAKE_ASM_FLAGS=\"--target=aarch64-linux-android${ANDROID_PLATFORM_LEVEL}\"")
    elseif (X86)
        enable_language(ASM_NASM)
    else (X86_64)
        enable_language(ASM_NASM)
    endif()
endif()

ExternalProject_Add(
        extern_jpeg-turbo
        URL ${JPEG_URL}
        PREFIX ${JPEG_SOURCES_DIR}
        UPDATE_COMMAND ""
        CMAKE_ARGS
        ${ANDROID_ABI_ARG}
        ${ANDROID_PLATFORM_ARG}
        ${ANDROID_NDK_ARG}
        ${ANDROID_TOOLCHAIN_FILE_ARG}
        -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
        -DCMAKE_INSTALL_PREFIX=${JPEG_INSTALL_PATH}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_BUILD_TYPE=${THIRD_PARTY_BUILD_TYPE}
        ${JEPG_ARM_MODE}
        ${JEPG_ASM_FLAGS}
        ${EXTERNAL_OPTIONAL_ARGS}
        CMAKE_CACHE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${JPEG_INSTALL_PATH}
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
        -DCMAKE_BUILD_TYPE:STRING=${THIRD_PARTY_BUILD_TYPE}
        BUILD_ALWAYS FALSE
)
if (JPEG_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

set(JPEG_LIBRARIE "${JPEG_INSTALL_PATH}/lib/libjpeg-turbo${LIB_SUFFIX}" CACHE FILEPATH "JPEG_LIBRARIE" FORCE)

add_library(jpeg-turbo ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET jpeg-turbo PROPERTY IMPORTED_LOCATION ${JPEG_LIBRARIE})
add_dependencies(jpeg-turbo extern_jpeg-turbo)
include_directories(${JPEG_INCLUDE_DIR})

### restore
set(SHARED_OR_STATIC)
set(LIB_SUFFIX)