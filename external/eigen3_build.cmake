include(ExternalProject)

set(EIGEN3_SOURCES_DIR ${THIRD_PARTY_PATH}/eigen3)
set(EIGEN3_INCLUDE_DIR ${EIGEN3_INSTALL_PATH}/include)

set(EIGEN3_URL "https://bitbucket.org/eigen/eigen/get/3.3.7.tar.bz2")

if (ANDROID)
    set(ANDROID_ABI_ARG -DANDROID_ABI=${ANDROID_ABI})
    set(ANDROID_PLATFORM_ARG -DANDROID_PLATFORM=${ANDROID_PLATFORM})
    set(ANDROID_NDK_ARG -DANDROID_NDK=${ANDROID_NDK})
    set(ANDROID_TOOLCHAIN_FILE_ARG -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE})
endif()

ExternalProject_Add(
        extern_eigen3
        URL ${EIGEN3_URL}
        PREFIX ${EIGEN3_SOURCES_DIR}
        UPDATE_COMMAND ""
        CMAKE_ARGS
        ${ANDROID_ABI_ARG}
        ${ANDROID_PLATFORM_ARG}
        ${ANDROID_NDK_ARG}
        ${ANDROID_TOOLCHAIN_FILE_ARG}
        -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
        -DCMAKE_INSTALL_PREFIX=${EIGEN3_INSTALL_PATH}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_BUILD_TYPE=${THIRD_PARTY_BUILD_TYPE}
        -DEIGEN_TEST_CXX11=ON
        CMAKE_CACHE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${EIGEN3_INSTALL_PATH}
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
        -DCMAKE_BUILD_TYPE:STRING=${THIRD_PARTY_BUILD_TYPE}
        BUILD_ALWAYS FALSE
)

include_directories(${EIGEN3_INCLUDE_DIR})
set(EIGEN3_INCLUDE_DIRS ${EIGEN3_INCLUDE_DIR})