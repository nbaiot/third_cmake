INCLUDE(ExternalProject)

set(GLOG_SOURCES_DIR ${THIRD_PARTY_PATH}/glog)
set(GLOG_INCLUDE_DIR ${GLOG_INSTALL_PATH}/include)

if (WIN32)
    set(GLOG_CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4267 /wd4530")
else ()
    set(GLOG_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
endif ()

set(GLOG_REPOSITORY "https://github.com/google/glog.git")
set(GLOG_TAG "v0.4.0")

if (ANDROID)
    set(ANDROID_ABI_ARG -DANDROID_ABI=${ANDROID_ABI})
    set(ANDROID_PLATFORM_ARG -DANDROID_PLATFORM=${ANDROID_PLATFORM})
    set(ANDROID_NDK_ARG -DANDROID_NDK=${ANDROID_NDK})
    set(ANDROID_TOOLCHAIN_FILE_ARG -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE})
endif ()

if (GLOG_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(LIB_BUILD "-DBUILD_SHARED_LIBS=OFF")
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
    set(LIB_BUILD "-DBUILD_SHARED_LIBS=ON")
endif ()

if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(SEARCH_GFLAGS ${THIRD_PARTY_INSTALL_PATH}/gflags)
else ()
    set(SEARCH_GFLAGS ${THIRD_PARTY_INSTALL_PATH})
endif ()

ExternalProject_Add(
        extern_glog
        DEPENDS gflags
        GIT_REPOSITORY ${GLOG_REPOSITORY}
        GIT_TAG ${GLOG_TAG}
        PREFIX ${GLOG_SOURCES_DIR}
        UPDATE_COMMAND ""
        CMAKE_ARGS
        ${ANDROID_ABI_ARG}
        ${ANDROID_PLATFORM_ARG}
        ${ANDROID_NDK_ARG}
        ${ANDROID_TOOLCHAIN_FILE_ARG}
        -DCMAKE_INSTALL_PREFIX=${GLOG_INSTALL_PATH}
        -DCMAKE_INSTALL_LIBDIR=${GLOG_INSTALL_PATH}/lib
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DGFLAGS_INSTALL_PATH=${SEARCH_GFLAGS}
        -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
        -DWITH_GFLAGS=ON
        -DBUILD_TESTING=OFF
        ${LIB_BUILD}
        -DCMAKE_BUILD_TYPE=${THIRD_PARTY_BUILD_TYPE}
        CMAKE_CACHE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${GLOG_INSTALL_PATH}
        -DCMAKE_INSTALL_LIBDIR:PATH=${GLOG_INSTALL_PATH}/lib
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
        -DCMAKE_BUILD_TYPE:STRING=${THIRD_PARTY_BUILD_TYPE}
        BUILD_ALWAYS FALSE
)


set(GLOG_LIBRARY "${GLOG_INSTALL_PATH}/lib/libglog${LIB_SUFFIX}" CACHE FILEPATH "GLOG_LIBRARY" FORCE)

add_library(glog ${SHARED_OR_STATIC} IMPORTED GLOBAL)
set_property(TARGET glog PROPERTY IMPORTED_LOCATION ${GLOG_LIBRARY})
add_dependencies(glog gflags extern_glog)

include_directories(${GLOG_INCLUDE_DIR})
set(GLOG_INCLUDE_DIRS ${GLOG_INCLUDE_DIR})
set(GLOG_LIBRARIES ${GLOG_LIBRARY})

### restore
set(SHARED_OR_STATIC)
set(LIB_SUFFIX)