#!/bin/bash

echo 'Adding COLCON_IGNORE to packages that will not be built for QNX'

echo 'vistalization packages will be ignored'
touch src/ros-visualization/COLCON_IGNORE
touch src/ros2/rviz/COLCON_IGNORE

echo 'uncrustify will be ignored'
touch src/ament/uncrustify_vendor/COLCON_IGNORE

echo 'CycloneDDS will be ignored'
touch src/eclipse-cyclonedds/COLCON_IGNORE

echo 'mimick will be ignored'
touch src/ros2/mimick_vendor/COLCON_IGNORE
