
### compiler version info
message(STATUS "CXX compiler: ${CMAKE_CXX_COMPILER}, version: "
        "${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "C compiler: ${CMAKE_C_COMPILER}, version: "
        "${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION}")

### enable fpic
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

### lib and bin path
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)

### third party
if (NOT THIRD_PARTY_PATH)
    set(THIRD_PARTY_PATH ${CMAKE_BINARY_DIR}/third_party CACHE STRING
            "A path setting third party libraries download & build directories.")
    set(THIRD_PARTY_INSTALL_PATH ${THIRD_PARTY_PATH}/install CACHE STRING
            "third party libraries install directory")
endif()

set(THIRD_PARTY_BUILD_TYPE Release)

message(STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")
message(STATUS "THIRD_PARTY_INSTALL_PATH: ${THIRD_PARTY_INSTALL_PATH}")

if (ANDROID)
    include(${CMAKE_CURRENT_LIST_DIR}/android.cmake)	
endif()
