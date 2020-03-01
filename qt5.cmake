if (NOT QT_LIB_ROOT)
    if (ANDROID)
        set(QT_LIB_ROOT /opt/Qt5.14.1/5.14.1/android)
    elseif (APPLE)
        message(FATAL_ERROR ">>>>>>>>>>not set QT_LIB_ROOT")
    elseif (UNIX)
        set(QT_LIB_ROOT /opt/Qt5.14.1/5.14.1/gcc_64)
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
find_package(Qt5 COMPONENTS Core Gui Qml Quick LinguistTools REQUIRED)

if (Qt5Core_FOUND)
    message(STATUS "Qt5Core:${Qt5Core_VERSION}")
endif()

if (Qt5Gui_FOUND)
    message(STATUS "Qt5Gui:${Qt5Gui_VERSION}")
endif()

if (Qt5Qml_FOUND)
    message(STATUS "Qt5Qml:${Qt5Qml_VERSION}")
endif()

if (Qt5Quick_FOUND)
    message(STATUS "Qt5Quick:${Qt5Quick_VERSION}")
endif()

if (Qt5LinguistTools_FOUND)
    message(STATUS "Qt5LinguistTools:${Qt5LinguistTools_VERSION}")
endif()
