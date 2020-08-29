if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(YAML_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/yaml-cpp)
else ()
    set(YAML_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(YAML_USE_STATIC TRUE)

find_package(YAML)

if (NOT YAML_FOUND)
    message(STATUS "now download and install yaml-cpp.")
    include(${CMAKE_CURRENT_LIST_DIR}/yaml_build.cmake)
else ()
    message(STATUS "found yaml-cpp")
endif ()
