if (THIRD_PARTY_INDEPENDENT_INSTALL)
    set(MONGODBCXX_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH}/mongodbcxx)
else ()
    set(MONGODBCXX_INSTALL_PATH ${THIRD_PARTY_INSTALL_PATH})
endif ()

set(MONGODBCXX_USE_STATIC TRUE)

find_package(MongoDBCXX)

if (NOT MONGODBCXX_FOUND)
    message(STATUS "now download and install mongodbcxx.")
    include(${CMAKE_CURRENT_LIST_DIR}/mongodb_cxx_build.cmake)
else ()
    message(STATUS "find mongodbcxx")
endif ()