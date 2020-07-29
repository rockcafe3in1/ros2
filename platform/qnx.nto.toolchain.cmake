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

set(QNX TRUE)
set(CMAKE_SYSTEM_NAME QNX)

set(CMAKE_C_COMPILER ${QNX_HOST}/usr/bin/qcc)
set(CMAKE_CXX_COMPILER ${QNX_HOST}/usr/bin/qcc)

set(CMAKE_SYSTEM_PROCESSOR "${CPUVAR}")

set(CMAKE_SYS_ROOT "${QNX_STAGE}")
set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES} $ENV{QNX_TARGET}/usr/include)

# needs a cpu + variant
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Vgcc_nto${CMAKE_SYSTEM_PROCESSOR} ${EXTRA_CMAKE_C_FLAGS}" CACHE STRING "c_flags")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Vgcc_nto${CMAKE_SYSTEM_PROCESSOR} ${EXTRA_CMAKE_CXX_FLAGS}" CACHE STRING "cxx_flags")

# needs only cpu, ARCH=(CPU only)
set(CMAKE_AR "${QNX_HOST}/usr/bin/nto${ARCH}-ar${HOST_EXECUTABLE_SUFFIX}" CACHE PATH "archiver")
set(CMAKE_RANLIB "${QNX_HOST}/usr/bin/nto${ARCH}-ranlib${HOST_EXECUTABLE_SUFFIX}" CACHE PATH "ranlib")

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${EXTRA_CMAKE_LINKER_FLAGS}" CACHE STRING "exe_linker_flags")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${EXTRA_CMAKE_LINKER_FLAGS}" CACHE STRING "so_linker_flags")

set(THREADS_PTHREAD_ARG "0" CACHE STRING "Result from TRY_RUN" FORCE)

# the variable below has to be set according to the output of running sysconfig.get_config_var('SOABI') on the target
# this will allow python extension files to be found.
#set(PYTHON_SOABI cpython-38m-${CPUVARDIR}-qnx-nto)
set(PYTHON_SOABI cpython-38)

set(CMAKE_FIND_ROOT_PATH ${QNX_STAGE};${QNX_STAGE}/${CPUVARDIR};${QNX_STAGE}/${CPUVARDIR}/usr/lib;${QNX_TARGET};${QNX_TARGET}/${CPUVARDIR};${CMAKE_INSTALL_PREFIX};${PROJECT_SOURCE_DIR})

set(CMAKE_SKIP_RPATH TRUE CACHE BOOL "If set, runtime paths are not added when using shared libraries.")
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

if (NOT DEFINED TARGET_INSTALL_DIR)
    # TARGET_INSTALL_DIR must point to where ROS gets installed on the target
    set(TARGET_INSTALL_DIR "/opt/ros/foxy")
endif()
message(STATUS "ROS2 Foxy installation directory is: ${TARGET_INSTALL_DIR}")

#set(CMAKE_CROSSCOMPILING_EMULATOR /home/asobhy/svn/sensorframework7.1/vm/qnxemu-x86_64.sh)

# macro to find programs on the host OS
macro( find_host_program )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER )
 if( CMAKE_HOST_WIN32 )
  set( WIN32 1 )
  set( UNIX )
 elseif( CMAKE_HOST_APPLE )
  set( APPLE 1 )
  set( UNIX )
 endif()
 find_program( ${ARGN} )
 set( WIN32 )
 set( APPLE )
 set( UNIX 1 )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY )
endmacro()

# macro to find packages on the host OS
macro( find_host_package )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER )
 if( CMAKE_HOST_WIN32 )
  set( WIN32 1 )
  set( UNIX )
 elseif( CMAKE_HOST_APPLE )
  set( APPLE 1 )
  set( UNIX )
 endif()
 find_package( ${ARGN} )
 set( WIN32 )
 set( APPLE )
 set( UNIX 1 )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY )
endmacro()

# for external projects you have to repass the variables set in the build.sh file
macro( set_qnx_external_project_options )
    list(APPEND extra_cmake_args "-DCMAKE_MAKE_PROGRAM=$ENV{QNX_HOST}/usr/bin/make")
    list(APPEND extra_cmake_args "-DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}")
    list(APPEND extra_cmake_args "-DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}")
    list(APPEND extra_cmake_args "-DCMAKE_LINKER_FLAGS=${CMAKE_LINKER_FLAGS}")
    list(APPEND extra_cmake_args "-DCPUVARDIR=${CPUVARDIR}")
    list(APPEND extra_cmake_args "-DCPUVAR=${CPUVAR}")
    list(APPEND extra_cmake_args "-DARCH=${ARCH}")
    list(APPEND extra_cmake_args "-DPYTHON_EXECUTABLE=${PYTHON_EXECUTABLE}")
    list(APPEND extra_cmake_args "-DPYTHON_LIBRARY=${PYTHON_LIBRARY}")
    list(APPEND extra_cmake_args "-DPYTHON_INCLUDE_DIR=${PYTHON_INCLUDE_DIR}")
endmacro()