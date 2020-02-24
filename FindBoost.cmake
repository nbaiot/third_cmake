
### for mbp, use brew install boost
if (APPLE)
    set(BOOST_INSTALL_PATH /usr/local/)
endif ()

set(BOOST_INCLUDE_DIR ${BOOST_INSTALL_PATH}/include)
set(BOOST_LIBRARY_DIR ${BOOST_INSTALL_PATH}/lib)

# TODO: fixme
if (NOT EXISTS ${BOOST_INCLUDE_DIR}/boost/version.hpp)
    set(BOOST_INSTALL FALSE)
else ()
    set(BOOST_INSTALL TRUE)
endif ()

set(BOOST_VERSION "${BOOST_VERSION_MAJOR}.${BOOST_VERSION_MINOR}.${BOOST_VERSION_PATCH}")

function(Version BOOST_VERSION)
    file(STRINGS "${BOOST_INCLUDE_DIR}/boost/version.hpp" boost_version_raw REGEX "define BOOST_VERSION ")
    string(REGEX MATCH "[0-9]+" boost_version_raw "${boost_version_raw}")
    math(EXPR BOOST_VERSION_MAJOR "${boost_version_raw} / 100000")
    math(EXPR BOOST_VERSION_MINOR "${boost_version_raw} / 100 % 1000")
    math(EXPR BOOST_VERSION_PATCH "${boost_version_raw} % 100")
    set(BOOST_VERSION "${BOOST_VERSION_MAJOR}.${BOOST_VERSION_MINOR}.${BOOST_VERSION_PATCH}" PARENT_SCOPE)
endfunction()

if (BOOST_USE_STATIC)
    set(SHARED_OR_STATIC "STATIC")
    set(LIB_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
    set(SHARED_OR_STATIC "SHARED")
    set(LIB_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif ()

if (${BOOST_INSTALL})
    foreach (SUBLIB ${Boost_FIND_COMPONENTS})
        set(SUB_TARGET boost_${SUBLIB})
        if (NOT TARGET SUB_TARGET)
            add_library(${SUB_TARGET} ${SHARED_OR_STATIC} IMPORTED GLOBAL)
            set_property(TARGET ${SUB_TARGET} PROPERTY IMPORTED_LOCATION ${BOOST_LIBRARY_DIR}/lib${SUB_TARGET}${LIB_SUFFIX})
        endif ()

    endforeach ()
    set(Boost_FOUND TRUE)
    include_directories(${BOOST_INCLUDE_DIR})
    Version(BOOST_VERSION)
else ()
    set(Boost_FOUND FALSE)
endif ()

#restore
set(LIB_SUFFIX)