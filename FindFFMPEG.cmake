include(FindPackageHandleStandardArgs)

set(CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES})

if (FFMPEG_USE_STATIC)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "STATIC")
else ()
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_SHARED_LIBRARY_SUFFIX})
    set(SHARED_OR_STATIC "SHARED")
endif ()

find_library(
        AVCODEC_LIB
        NAMES "avcodec"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
)

find_path(AVCODEC_INCLUDE
        NAMES "libavcodec/avcodec.h"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        )

find_library(
        AVDEVICE_LIB
        NAMES "avdevice"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
)

find_path(AVDEVICE_INCLUDE
        NAMES "libavdevice/avdevice.h"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        )

find_library(
        AVFILTER_LIB
        NAMES "avfilter"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
)

find_path(AVFILTER_INCLUDE
        NAMES "libavfilter/avfilter.h"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        )

find_library(
        AVFORMAT_LIB
        NAMES "avformat"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
)

find_path(AVFORMAT_INCLUDE
        NAMES "libavformat/avformat.h"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        )

find_library(
        AVUTIL_LIB
        NAMES "avutil"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
)

find_path(AVUTIL_INCLUDE
        NAMES "libavutil/avutil.h"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        )

find_library(
        SWRESAMPLE_LIB
        NAMES "swresample"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
)

find_path(SWRESAMPLE_INCLUDE
        NAMES "libswresample/swresample.h"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        )

find_library(
        SWSCALE_LIB
        NAMES "swscale"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "lib" "lib64"
        NO_DEFAULT_PATH
)

find_path(SWSCALE_INCLUDE
        NAMES "libswscale/swscale.h"
        PATHS ${FFMPEG_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        )


find_package_handle_standard_args(ffmpeg DEFAULT_MSG
        AVCODEC_LIB AVCODEC_INCLUDE
        AVDEVICE_LIB AVDEVICE_INCLUDE
        AVFILTER_LIB AVFILTER_INCLUDE
        AVFORMAT_LIB AVFORMAT_INCLUDE
        AVUTIL_LIB AVUTIL_INCLUDE
        SWRESAMPLE_LIB SWRESAMPLE_INCLUDE
        SWSCALE_LIB SWSCALE_INCLUDE
        )

if (FFMPEG_FOUND)
    add_library(avcodec ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET avcodec PROPERTY IMPORTED_LOCATION ${AVCODEC_LIB})

    add_library(avdevice ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET avdevice PROPERTY IMPORTED_LOCATION ${AVDEVICE_LIB})

    add_library(avfilter ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET avfilter PROPERTY IMPORTED_LOCATION ${AVFILTER_LIB})


    add_library(avutil ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET avutil PROPERTY IMPORTED_LOCATION ${AVUTIL_LIB})

    add_library(avformat ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET avformat PROPERTY IMPORTED_LOCATION ${AVFORMAT_LIB})

    add_library(swresample ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET swresample PROPERTY IMPORTED_LOCATION ${SWRESAMPLE_LIB})

    add_library(swscale ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET swscale PROPERTY IMPORTED_LOCATION ${SWSCALE_LIB})

    include_directories(${AVCODEC_INCLUDE})
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)