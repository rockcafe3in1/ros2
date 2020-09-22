#!/bin/bash

echo 'vistalization packages will be ignored'
touch src/ros-visualization/COLCON_IGNORE
touch src/ros2/rviz/COLCON_IGNORE
echo 'uncrustify will be ignored'
touch src/ament/uncrustify/COLCON_IGNORE
#echo 'foonathan memory is built with dependencies and will be ignored'
#touch src/eProsima/foonathan_memory_vendor/COLCON_IGNORE
