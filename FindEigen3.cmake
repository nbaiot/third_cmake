include(FindPackageHandleStandardArgs)

unset(EIGEN3_INCLUDE CACHE)
find_path(EIGEN3_INCLUDE
        NAMES "eigen3/signature_of_eigen3_matrix_library"
        PATHS ${EIGEN3_INSTALL_PATH}
        PATH_SUFFIXES "include"
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH
        )

find_package_handle_standard_args(Eigen3 DEFAULT_MSG EIGEN3_INCLUDE)

if (EIGEN3_FOUND)
    include_directories(${EIGEN_INCLUDE})
    set(EIGEN3_INCLUDE_DIR ${EIGEN3_INCLUDE})
    set(EIGEN3_INCLUDE_DIRS ${EIGEN3_INCLUDE})
endif ()