# QNX toolchain file for building ROS2

if("$ENV{QNX_HOST}" STREQUAL "")
    message(FATAL_ERROR "QNX_HOST environment variable not found. Please set the variable to your host's build tools")
endif()
if("$ENV{QNX_TARGET}" STREQUAL "")
    message(FATAL_ERROR "QNX_TARGET environment variable not found. Please set the variable to the qnx target location")
endif()

set(QNX_HOST "$ENV{QNX_HOST}")
set(QNX_TARGET "$ENV{QNX_TARGET}")
set(QNX_STAGE "$ENV{QNX_STAGE}")

message(STATUS "using QNX_HOST ${QNX_HOST}")
message(STATUS "using QNX_TARGET ${QNX_TARGET}")
message(STATUS "using QNX_STAGE ${QNX_STAGE}")

set(ARCH "$ENV{ARCH}")
set(CPUVAR "$ENV{CPUVAR}")
set(CPUVARDIR "$ENV{CPUVARDIR}")

message(STATUS "using CPUVAR ${CPUVAR}")
message(STATUS "using CPUVARDIR ${CPUVARDIR}")
message(STATUS "using ARCH ${ARCH}")

set(QNX TRUE)
set(CMAKE_SYSTEM_NAME QNX)

set(CMAKE_C_COMPILER ${QNX_HOST}/usr/bin/qcc)
set(CMAKE_CXX_COMPILER ${QNX_HOST}/usr/bin/qcc)

set(CMAKE_SYSTEM_PROCESSOR "${CPUVAR}")

set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES} ${QNX_TARGET}/usr/include)

set(EXTRA_CMAKE_C_FLAGS "-Wl,-rpath-link,${QNX_STAGE}/${CPUVARDIR}/usr/lib:${PWD}/install/${CPUVARDIR}/lib -DTHIRDPARTY=ON -DOPENCV_NOSTL_TRANSITIONAL -D_QNX_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE -Wno-deprecated-declarations -Wno-unused-parameter -Wno-unused-variable -Wno-ignored-attributes -I${QNX_STAGE}/usr/include ")
set(EXTRA_CMAKE_CXX_FLAGS "${EXTRA_CMAKE_C_FLAGS} -stdlib=libstdc++ -std=c++14")
set(EXTRA_CMAKE_LINKER_FLAGS "-Wl,--build-id=md5 -lstdc++ ")

# needs a cpu + variant
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Vgcc_nto${CMAKE_SYSTEM_PROCESSOR} ${EXTRA_CMAKE_C_FLAGS}" CACHE STRING "c_flags")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Vgcc_nto${CMAKE_SYSTEM_PROCESSOR} ${EXTRA_CMAKE_CXX_FLAGS}" CACHE STRING "cxx_flags")

# needs only cpu, ARCH=(CPU only)
set(CMAKE_AR "${QNX_HOST}/usr/bin/nto${ARCH}-ar${HOST_EXECUTABLE_SUFFIX}" CACHE PATH "archiver")
set(CMAKE_RANLIB "${QNX_HOST}/usr/bin/nto${ARCH}-ranlib${HOST_EXECUTABLE_SUFFIX}" CACHE PATH "ranlib")

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${EXTRA_CMAKE_LINKER_FLAGS}" CACHE STRING "exe_linker_flags")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${EXTRA_CMAKE_LINKER_FLAGS}" CACHE STRING "so_linker_flags")

set(THREADS_PTHREAD_ARG "0" CACHE STRING "Result from TRY_RUN" FORCE)

########################################################################
# Python setup
########################################################################
# the variable below has to be set according to the output of
# sysconfig.get_config_var('SOABI') on the target, which allows python
# extension files to be found.
#set(PYTHON_SOABI cpython-38-${CPUVARDIR}-qnx-nto)
set(PYTHON_SOABI cpython-38)
find_package(PythonInterp 3.8 REQUIRED)
set(PYTHON_INCLUDE_DIR ${QNX_TARGET}/${CPUVARDIR}/usr/include/python3.8;${QNX_TARGET}/usr/include/python3.8;${QNX_STAGE}/${CPUVARDIR}/usr/lib/python3.8/site-packages/numpy/core/include)
set(PYTHON_LIBRARY ${QNX_TARGET}/${CPUVARDIR}/usr/lib/libpython3.8.so)

#######################################################################
# Workaround to fix Eigen3Config.cmake setting eigen3 include dirs to
# ${QNX_STAGE}/${CPUVARDIR}/usr/include/ instead of ${QNX_STAGE}/usr/include/
# without having to touch any of the files outside the toolchain file
set(Eigen3_INCLUDE_DIRS ${QNX_STAGE}/usr/include/eigen3)
set(EIGEN3_FOUND TRUE)
#######################################################################

#######################################################################
# Search paths for dependencies
#######################################################################
set(CMAKE_FIND_ROOT_PATH ${CMAKE_INSTALL_PREFIX};${QNX_STAGE};${QNX_STAGE}/${CPUVARDIR};${QNX_TARGET};${QNX_TARGET}/${CPUVARDIR})

# Do not include runtime paths in libraries because they will be
# incorrect since on target they will be different than on host
set(CMAKE_SKIP_RPATH TRUE CACHE BOOL "If set, runtime paths are not added when using shared libraries.")

#######################################################################
# Search strategy
#######################################################################
# Allow search for programs on host, this will allow programs such as
# make, git and patch to be found and used.
# Only look for headers, libs and packages in the search paths provided
# by CMAKE_FIND_ROOT_PATH
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

if (NOT DEFINED TARGET_INSTALL_DIR)
    # TARGET_INSTALL_DIR must point to where ROS gets installed on the target
    set(TARGET_INSTALL_DIR "/opt/ros/rolling")
endif()
message(STATUS "ROS2 Rolling installation directory is: ${TARGET_INSTALL_DIR}")
