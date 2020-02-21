set(LIBUSB_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/libusb)

set(LIBUSB_USE_STATIC TRUE)

find_package(Libusb)

if (NOT LIBUSB_FOUND)
    message(STATUS "now download and install libusb.")
    include(${CMAKE_CURRENT_LIST_DIR}/libusb_build.cmake)
else ()
    message(STATUS "find libusb")
endif ()