#!/bin/bash

# Set this variable according to the path of package on target
ROS2_PACKAGE_TARGET_INSTALL_PATH=/opt/ros/rolling

if [ ! -d "${QNX_TARGET}" ]; then
    echo "QNX_TARGET is not set. Exiting..."
    exit 1
fi

#for arch in armv7 aarch64 x86_64; do
for arch in x86_64; do

    if [ "${arch}" == "aarch64" ]; then
        CPUVARDIR=aarch64le
        CPUVAR=aarch64le
		rm src/ros2/pybind11_vendor/COLCON_IGNORE
    elif [ "${arch}" == "armv7" ]; then
        CPUVARDIR=armle-v7
        CPUVAR=armv7le
		# incompatibility issue between the 32-bit compiler and the package. Needs futher investigation.
		touch src/ros2/pybind11_vendor/COLCON_IGNORE
    elif [ "${arch}" == "x86_64" ]; then
        CPUVARDIR=x86_64
        CPUVAR=x86_64
		rm src/ros2/pybind11_vendor/COLCON_IGNORE
    else
        echo "Invalid architecture. Exiting..."
        exit 1
    fi

    echo "CPU set to ${CPUVAR}"
    echo "CPUVARDIR set to ${CPUVARDIR}"

    export CPUVARDIR=${CPUVARDIR}
    export CPUVAR=${CPUVAR}
    export ARCH=${arch}

    colcon --log-level 8 build --merge-install --cmake-force-configure \
        --build-base=build/${CPUVARDIR} \
        --install-base=install/${CPUVARDIR} \
        --cmake-args \
            -DCMAKE_TOOLCHAIN_FILE="${PWD}/platform/qnx.nto.toolchain.cmake" \
            -DCMAKE_VERBOSE_MAKEFILE:BOOL="ON" \
            -DBUILD_TESTING:BOOL="OFF" \
            -DCMAKE_BUILD_TYPE="Release" \
            -DTARGET_INSTALL_DIR="/opt/ros/rolling"

done

	# The three variables below are patched according to the installation of ros2 on target and the installation of the current package on target
    # Patching the scripts is done during the build process for convenience but can also be done on target if user chooses to do so
    # _colcon_prefix_chain_sh_COLCON_CURRENT_PREFIX --> package path on target
    # COLCON_CURRENT_PREFIX --> ros2 path on target
    # _colcon_prefix_sh_COLCON_CURRENT_PREFIX --> package path on target

    # setup.sh
#    grep -rl --include setup.sh "_colcon_prefix_chain_sh_COLCON_CURRENT_PREFIX=" install/ | xargs sed -i "s|_colcon_prefix_chain_sh_COLCON_CURRENT_PREFIX=/.*$|_colcon_prefix_chain_sh_COLCON_CURRENT_PREFIX=${ROS2_PACKAGE_TARGET_INSTALL_PATH}|g"
#    grep -rl --include setup.sh "COLCON_CURRENT_PREFIX=\"/" install/ | xargs sed -i 's|COLCON_CURRENT_PREFIX="/.*$|COLCON_CURRENT_PREFIX=\"${ROS2_PACKAGE_TARGET_INSTALL_PATH}\"|g'
    # local_setup.sh
#    grep -rl --include local_setup.sh "_colcon_prefix_sh_COLCON_CURRENT_PREFIX=\"/" install/ | xargs sed -i "s|_colcon_prefix_sh_COLCON_CURRENT_PREFIX=\"/.*\"|_colcon_prefix_sh_COLCON_CURRENT_PREFIX=\"${ROS2_PACKAGE_TARGET_INSTALL_PATH}\"|g"
#    grep -rl --include local_setup.sh "AMENT_CURRENT_PREFIX:=\"/" install/ | xargs sed -i "s|AMENT_CURRENT_PREFIX:=\"/.*\"|AMENT_CURRENT_PREFIX:=\"${ROS2_PACKAGE_TARGET_INSTALL_PATH}\"|g"

exit 0
