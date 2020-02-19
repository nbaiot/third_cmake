include(ExternalProject)
include(ProcessorCount)

### download config
set(BOOST_EXTERNAL "extern_boost")
if (WIN32)
    set(BOOST_URL "https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.zip")
else ()
    set(BOOST_URL "https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.bz2")
endif ()
message(STATUS "BOOST_URL: ${BOOST_URL}")

### install config
set(BOOST_INSTALL_DIR ${THIRD_PARTY_INSTALL_PATH}/boost)
set(BOOSTS_INCLUDE_DIR ${BOOST_INSTALL_DIR}/include)
set(BOOST_LIBRARY_DIR ${BOOST_INSTALL_DIR}/lib)

set(BOOST_EXTERNAL_DIR ${THIRD_PARTY_PATH}/boost)
set(BOOST_DOWNLOAD_DIR ${BOOST_EXTERNAL_DIR}/dist)
set(BOOST_SOURCE_DIR ${BOOST_EXTERNAL_DIR}/src)

if (APPLE)
    set(CROSS_TOOLSET clang)
else ()
    set(CROSS_TOOLSET gcc)
endif ()

if (WIN32)
    set(CAT_CMD "type")
else ()
    set(CAT_CMD "cat")
endif ()

if (ANDROID)
    if (ARMEABI_V7A)
        set(TOOL_SET "arm")
        set(ARCH "architecture=arm")
    elseif (ARM64_V8A)
        set(TOOL_SET "aarch64")
        set(ARCH "architecture=arm")
    elseif (X86)
        set(TOOL_SET "i686")
        set(ARCH "architecture=x86")
    else (X86_64)
        set(TOOL_SET "x86_64")
        set(ARCH "architecture=x86")
    endif ()
    set(TARGET_OS "target-os=android")
    set(BOOST_CONFIG_JAM ${BOOST_SOURCE_DIR}/${BOOST_EXTERNAL}/project-config.jam)
    set(JAM_TOOL_SET "TOOL_SET = ${TOOL_SET}")
    set(JAM_HOST_TAG "HOST_TAG = ${ANDROID_HOST_TAG}")
    set(JAM_ANDROID_NATIVE_LEVEL "ANDROID_NATIVE_LEVEL = ${ANDROID_PLATFORM_LEVEL}")
    set(JAM_NDK_CXX "NDK_CXX = ${NDK_CXX}")
    set(JAM_NDK_AR "NDK_AR = ${NDK_AR}")
    set(JAM_NDK_RANLIB "NDK_RANLIB = ${NDK_RANLIB}")
    set(JAM_ANDROID ${CMAKE_CURRENT_LIST_DIR}/boost_android.jam)
    set(SEMICOLON ${CMAKE_CURRENT_LIST_DIR}/semicolon)
else()
    set(TARGET_OS)
    set(ARCH)
    set(BOOST_CONFIG_JAM ${BOOST_SOURCE_DIR}/${BOOST_EXTERNAL}/project-config-fake.jam)
    set(JAM_TOOL_SET "TOOL_SET = ${TOOL_SET}")
    set(JAM_HOST_TAG "HOST_TAG = ${ANDROID_HOST_TAG}")
    set(JAM_ANDROID_NATIVE_LEVEL "ANDROID_NATIVE_LEVEL = ${ANDROID_PLATFORM_LEVEL}")
    set(JAM_NDK_CXX "NDK_CXX = ${NDK_CXX}")
    set(JAM_NDK_AR "NDK_AR = ${NDK_AR}")
    set(JAM_NDK_RANLIB "NDK_RANLIB = ${NDK_RANLIB}")
    set(JAM_ANDROID ${CMAKE_CURRENT_LIST_DIR}/boost_android.jam)
    set(SEMICOLON ${CMAKE_CURRENT_LIST_DIR}/semicolon)
endif ()

ProcessorCount(CPU_COUNT)

if (WIN32)
    set(BOOTSTRAP_SUFFIX .bat)
    set(B2_SUFFIX .exe)
else (UNIX)
    set(BOOTSTRAP_SUFFIX .sh)
endif ()

if (BOOST_USE_STATIC)
    set(BOOST_LINK static)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(BOOST_LINK shared)
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

set(BOOST_BOOTSTRAP_CMD ./bootstrap${BOOTSTRAP_SUFFIX})
set(BOOST_BUILD_CMD ./b2${B2_SUFFIX} toolset=${CROSS_TOOLSET}
        --prefix=${BOOST_INSTALL_DIR}
        --without-python
        --without-mpi
        --without-context
        --without-coroutine
        --without-fiber
        link=${BOOST_LINK} variant=release runtime-link=shared
        ${ARCH}
        ${TARGET_OS}
        install -j${CPU_COUNT})

ExternalProject_Add(
        ${BOOST_EXTERNAL}
        PREFIX ${BOOST_EXTERNAL_DIR}
        URL ${BOOST_URL}
        CONFIGURE_COMMAND
        COMMAND ${BOOST_BOOTSTRAP_CMD}
        COMMAND echo ${JAM_TOOL_SET} > ${BOOST_CONFIG_JAM}
        COMMAND ${CAT_CMD} ${SEMICOLON} >> ${BOOST_CONFIG_JAM}
        COMMAND echo ${JAM_HOST_TAG} >> ${BOOST_CONFIG_JAM}
        COMMAND ${CAT_CMD} ${SEMICOLON} >> ${BOOST_CONFIG_JAM}
        COMMAND echo ${JAM_ANDROID_NATIVE_LEVEL} >> ${BOOST_CONFIG_JAM}
        COMMAND ${CAT_CMD} ${SEMICOLON} >> ${BOOST_CONFIG_JAM}
        COMMAND echo ${JAM_NDK_CXX} >> ${BOOST_CONFIG_JAM}
        COMMAND ${CAT_CMD} ${SEMICOLON} >> ${BOOST_CONFIG_JAM}
        COMMAND echo ${JAM_NDK_AR} >> ${BOOST_CONFIG_JAM}
        COMMAND ${CAT_CMD} ${SEMICOLON} >> ${BOOST_CONFIG_JAM}
        COMMAND echo ${JAM_NDK_RANLIB} >> ${BOOST_CONFIG_JAM}
        COMMAND ${CAT_CMD} ${SEMICOLON} >> ${BOOST_CONFIG_JAM}
        COMMAND ${CAT_CMD} ${JAM_ANDROID} >> ${BOOST_CONFIG_JAM}
        BUILD_ALWAYS FALSE
        BUILD_COMMAND
        COMMAND ${BOOST_BUILD_CMD}
        INSTALL_COMMAND ""
        UPDATE_COMMAND ""
        BUILD_IN_SOURCE 1
)

set(BOOST_COMPONENTS "")

list(APPEND BOOST_COMPONENTS "atomic")
list(APPEND BOOST_COMPONENTS "chrono")
list(APPEND BOOST_COMPONENTS "container")
#list(APPEND BOOST_COMPONENTS "context")
list(APPEND BOOST_COMPONENTS "contract")
#list(APPEND BOOST_COMPONENTS "coroutine")
list(APPEND BOOST_COMPONENTS "date_time")
list(APPEND BOOST_COMPONENTS "exception")
#list(APPEND BOOST_COMPONENTS "fiber")
list(APPEND BOOST_COMPONENTS "filesystem")
list(APPEND BOOST_COMPONENTS "graph")
list(APPEND BOOST_COMPONENTS "graph_parallel")
list(APPEND BOOST_COMPONENTS "iostreams")
list(APPEND BOOST_COMPONENTS "locale")
#list(APPEND BOOST_COMPONENTS "log")
list(APPEND BOOST_COMPONENTS "math")
list(APPEND BOOST_COMPONENTS "program_options")
list(APPEND BOOST_COMPONENTS "random")
list(APPEND BOOST_COMPONENTS "regex")
list(APPEND BOOST_COMPONENTS "serialization")
list(APPEND BOOST_COMPONENTS "stacktrace")
list(APPEND BOOST_COMPONENTS "system")
#list(APPEND BOOST_COMPONENTS "test")
list(APPEND BOOST_COMPONENTS "thread")
list(APPEND BOOST_COMPONENTS "timer")
list(APPEND BOOST_COMPONENTS "type_erasure")
list(APPEND BOOST_COMPONENTS "wave")
#list(APPEND BOOST_COMPONENTS "python")
#list(APPEND BOOST_COMPONENTS "mpi")

foreach (SUBLIB ${BOOST_COMPONENTS})
    set(SUB_TARGET boost_${SUBLIB})
    add_library(${SUB_TARGET} ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET ${SUB_TARGET} PROPERTY IMPORTED_LOCATION ${BOOST_LIBRARY_DIR}/lib${SUB_TARGET}${LIB_SUFFIX})
    add_dependencies(${SUB_TARGET} ${BOOST_EXTERNAL})
endforeach ()

include_directories(${BOOSTS_INCLUDE_DIR})

# restore
set(SHARED_OR_STATIC)
set(LIB_SUFFIX)
