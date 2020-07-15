if (NOT QT_LIB_ROOT)
    if (ANDROID)
        set(QT_LIB_ROOT ~/tools/Qt/5.15.0/android)
    elseif (APPLE)
        message(FATAL_ERROR ">>>>>>>>>>not set QT_LIB_ROOT")
    elseif (UNIX)
        set(QT_LIB_ROOT ~/tools/Qt/5.15.0/gcc_64)
    elseif (WIN32)
        message(FATAL_ERROR ">>>>>>>>>>not set QT_LIB_ROOT")
    endif ()
endif ()

set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${QT_LIB_ROOT})
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

if (NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 11)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
endif()

### recommend quick replace widgets
find_package(Qt5 COMPONENTS Core Gui Widgets Qml Quick Multimedia LinguistTools MultimediaWidgets REQUIRED)

if (Qt5Core_FOUND)
    include_directories(${Qt5Core_INCLUDE_DIRS})
    message(STATUS "Qt5Core:${Qt5Core_VERSION}")
endif()

if (Qt5Gui_FOUND)
    include_directories(${Qt5Gui_INCLUDE_DIRS})
    message(STATUS "Qt5Gui:${Qt5Gui_VERSION}")
endif()

if (Qt5Widgets_FOUND)
    include_directories(${Qt5Widgets_INCLUDE_DIRS})
    message(STATUS "Qt5Widgets:${Qt5Widgets_VERSION}")
endif()

if (Qt5MultimediaWidgets_FOUND)
    include_directories(${Qt5MultimediaWidgets_INCLUDE_DIRS})
    message(STATUS "Qt5MultimediaWidgets:${Qt5MultimediaWidgets_VERSION}")
endif()

if (Qt5Qml_FOUND)
    include_directories(${Qt5Qml_INCLUDE_DIRS})
    message(STATUS "Qt5Qml:${Qt5Qml_VERSION}")
endif()

if (Qt5Quick_FOUND)
    include_directories(${Qt5Quick_INCLUDE_DIRS})
    message(STATUS "Qt5Quick:${Qt5Quick_VERSION}")
endif()

if (Qt5Multimedia_FOUND)
    include_directories(${Qt5Multimedia_INCLUDE_DIRS})
    message(STATUS "Qt5Multimedia:${Qt5Multimedia_VERSION}")
endif()

if (Qt5LinguistTools_FOUND)
    include_directories(${Qt5LinguistTools_INCLUDE_DIRS})
    message(STATUS "Qt5LinguistTools:${Qt5LinguistTools_VERSION}")
endif()