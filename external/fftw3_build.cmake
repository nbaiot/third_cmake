INCLUDE(ExternalProject)
include(ProcessorCount)

set(FFTW3_SOURCES_DIR ${THIRD_PARTY_PATH}/fftw3)
set(FFTW3_INSTALL_DIR ${THIRD_PARTY_INSTALL_PATH}/fftw3)
set(FFTW3_INCLUDE_DIR ${FFTW3_INSTALL_DIR}/include)

#set(FFTW3_URL "http://www.fftw.org/fftw-3.3.8.tar.gz")
set(FFTW3_URL "http://localhost:8888/fftw-3.3.8.tar.gz")

set(FFTW_HOST)
set(ENABLE_OP "--enable-threads")
set(ENABLE_OP ${ENABLE_OP} "--enable-shared")

set(FFTW_LIB_NAME libfftw3)
set(FFTW_THREAD_LIB_NAME libfftw3_threads)
set(FFTW_BUILD_CFLAGS "-fpic")
if (ANDROID)
    set(LIBS "LIBS=\"-lc -lgcc\"")
    if (ARMEABI_V7A)
        set(FFTW_HOST armv7a-linux-androideabi)
        set(ENABLE_OP ${ENABLE_OP} "--enable-float")
        set(ENABLE_OP ${ENABLE_OP} "--enable-neon")
        set(FFTW_LIB_NAME libfftw3f)
        set(FFTW_THREAD_LIB_NAME libfftw3f_threads)
        set(FFTW_BUILD_CFLAGS "-fpic -march=armv7-a -mfloat-abi=softfp -mfpu=neon")
    elseif (ARM64_V8A)
        set(FFTW_HOST aarch64-linux-android)
    elseif (X86)
        set(FFTW_HOST i686-linux-android)
    else (X86_64)
        set(FFTW_HOST x86_64-linux-android)
    endif ()
endif ()

if (ANDROID)
    set(FFTW_CONFIGURE_CMD
            ./configure
            CC=${NDK_CC}
            AR=${NDK_AR}
            AS=${NDK_AS}
            LD=${NDK_LD}
            RANLIB=${NDK_RANLIB}
            STRIP=${NDK_STRIP}
            LIBS=-lc\ -lgcc
            --host ${FFTW_HOST}
            --prefix=${FFTW3_INSTALL_DIR}
            ${ENABLE_OP}
            --disable-fortran
            )
else ()
    set(FFTW_CONFIGURE_CMD
            ./configure
            --prefix=${FFTW3_INSTALL_DIR}
            ${ENABLE_OP}
            --disable-fortran
            )
endif ()

string(REPLACE "--" " --" ENABLE_OPS ${ENABLE_OP})

ProcessorCount(CPU_COUNT)

ExternalProject_Add(
        extern_fftw3
        URL ${FFTW3_URL}
        PREFIX ${FFTW3_SOURCES_DIR}
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND
        COMMAND ${FFTW_CONFIGURE_CMD}
        BUILD_ALWAYS FALSE
        BUILD_COMMAND
        COMMAND make CFLAGS=${FFTW_BUILD_CFLAGS} -j${CPU_COUNT}
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1
)

if (FFTW_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

if (ARMEABI_V7A)
    set(FFTW3F_LIBRARIE "${FFTW3_INSTALL_DIR}/lib/${FFTW_LIB_NAME}${LIB_SUFFIX}" CACHE FILEPATH "FFTW3F_LIBRARIE" FORCE)
    add_library(fftw3f ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET fftw3f PROPERTY IMPORTED_LOCATION ${FFTW3F_LIBRARIE})
    add_dependencies(fftw3f extern_fftw3)

    set(FFTW3F_THREAD_LIBRARIE "${FFTW3_INSTALL_DIR}/lib/${FFTW_THREAD_LIB_NAME}${LIB_SUFFIX}" CACHE FILEPATH "FFTW3F_THREAD_LIBRARIE" FORCE)
    add_library(fftw3f_thread ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET fftw3f_thread PROPERTY IMPORTED_LOCATION ${FFTW3F_THREAD_LIBRARIE})
    add_dependencies(fftw3f_thread extern_fftw3)
    include_directories(${FFTW3_INCLUDE_DIR})
else ()
    set(FFTW3_LIBRARIE "${FFTW3_INSTALL_DIR}/lib/${FFTW_LIB_NAME}${LIB_SUFFIX}" CACHE FILEPATH "FFTW3_LIBRARIE" FORCE)
    add_library(fftw3 ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET fftw3 PROPERTY IMPORTED_LOCATION ${FFTW3_LIBRARIE})
    add_dependencies(fftw3 extern_fftw3)

    set(FFTW3_THREAD_LIBRARIE "${FFTW3_INSTALL_DIR}/lib/${FFTW_THREAD_LIB_NAME}${LIB_SUFFIX}" CACHE FILEPATH "FFTW3_THREAD_LIBRARIE" FORCE)
    add_library(fftw3_thread ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET fftw3_thread PROPERTY IMPORTED_LOCATION ${FFTW3_THREAD_LIBRARIE})
    add_dependencies(fftw3_thread extern_fftw3)

    include_directories(${FFTW3_INCLUDE_DIR})
endif ()

set(ENABLE_OP)
set(ENABLE_OPS)
set(SHARED_OR_STATIC)
set(LIB_SUFFIX)
