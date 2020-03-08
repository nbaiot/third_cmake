include(ExternalProject)

set(X265_SOURCES_DIR ${THIRD_PARTY_PATH}/x265)
set(X265_INCLUDE_DIR ${X265_INSTALL_PATH}/include)

set(X265_URL "https://bitbucket.org/multicoreware/x265/downloads/x265_3.3.tar.gz")


if (ANDROID)
    set(ANDROID_ABI_ARG -DANDROID_ABI=${ANDROID_ABI})
    set(ANDROID_PLATFORM_ARG -DANDROID_PLATFORM=${ANDROID_PLATFORM})
    set(ANDROID_NDK_ARG -DANDROID_NDK=${ANDROID_NDK})
    set(ANDROID_TOOLCHAIN_FILE_ARG -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE})
endif ()

ExternalProject_Add(
        extern_x265
        URL ${X265_URL}
        PREFIX ${X265_SOURCES_DIR}
        UPDATE_COMMAND ""
        PATCH_COMMAND ${EXTERNAL_PATCH_PATH}/patch-manager.sh x265
        CMAKE_ARGS
        ${ANDROID_ABI_ARG}
        ${ANDROID_PLATFORM_ARG}
        ${ANDROID_NDK_ARG}
        ${ANDROID_TOOLCHAIN_FILE_ARG}
        -DCMAKE_INSTALL_PREFIX=${X265_INSTALL_PATH}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_BUILD_TYPE=${THIRD_PARTY_BUILD_TYPE}
        -DENABLE_SHARED=ON
        CMAKE_CACHE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${X265_INSTALL_PATH}
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
        -DCMAKE_BUILD_TYPE:STRING=${THIRD_PARTY_BUILD_TYPE}
        SOURCE_SUBDIR source
        BUILD_ALWAYS FALSE
)

if (X265_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

set(X265_LIBRARY "${X265_INSTALL_PATH}/lib/libx265${LIB_SUFFIX}" CACHE FILEPATH "X265_LIBRARY" FORCE)

add_library(x265 ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET x265 PROPERTY IMPORTED_LOCATION ${X265_LIBRARY})
add_dependencies(x265 extern_x265)
include_directories(${X265_INCLUDE_DIR})
set(X265_INCLUDE_DIRS ${X265_INCLUDE_DIR})
set(X265_LIBRARIES ${X265_LIBRARY})

### restore
set(SHARED_OR_STATIC)
set(LIB_SUFFIX)