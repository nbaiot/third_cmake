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
        AVCODEC_LIBRARY
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
        AVDEVICE_LIBRARY
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
        AVFILTER_LIBRARY
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
        AVFORMAT_LIBRARY
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
        AVUTIL_LIBRARY
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
        SWRESAMPLE_LIBRARY
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
        SWSCALE_LIBRARY
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
        AVDEVICE_LIBRARY AVDEVICE_INCLUDE
        AVCODEC_LIBRARY AVCODEC_INCLUDE
        AVFILTER_LIBRARY AVFILTER_INCLUDE
        AVFORMAT_LIBRARY AVFORMAT_INCLUDE
        AVUTIL_LIBRARY AVUTIL_INCLUDE
        SWRESAMPLE_LIBRARY SWRESAMPLE_INCLUDE
        SWSCALE_LIBRARY SWSCALE_INCLUDE
        )

if (FFMPEG_FOUND)
    add_library(avcodec ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET avcodec PROPERTY IMPORTED_LOCATION ${AVCODEC_LIBRARY})

    add_library(avdevice ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET avdevice PROPERTY IMPORTED_LOCATION ${AVDEVICE_LIBRARY})

    add_library(avfilter ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET avfilter PROPERTY IMPORTED_LOCATION ${AVFILTER_LIBRARY})


    add_library(avutil ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET avutil PROPERTY IMPORTED_LOCATION ${AVUTIL_LIBRARY})

    add_library(avformat ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET avformat PROPERTY IMPORTED_LOCATION ${AVFORMAT_LIBRARY})

    add_library(swresample ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET swresample PROPERTY IMPORTED_LOCATION ${SWRESAMPLE_LIBRARY})

    add_library(swscale ${SHARED_OR_STATIC} IMPORTED GLOBAL)
    set_property(TARGET swscale PROPERTY IMPORTED_LOCATION ${SWSCALE_LIBRARY})

    include_directories(${AVCODEC_INCLUDE})
endif ()

### restore
set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV})
set(SHARED_OR_STATIC)