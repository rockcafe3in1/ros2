#!/bin/bash

set e-

echo "Building ROS2 QNX Dependencies..."

./apr/build.sh
./apr-util/build.sh
./log4cxx/build.sh

./libxslt/build.sh
./lxml/build.sh

./asio/build.sh
./memory/build.sh

./libpng16/build.sh
./opencv/build.sh

./eigen3/build.sh
./bullet3/build.sh
./netifaces/build.sh
./tinyxml2/build.sh
./numpy/build.sh
./uncrustify/build.sh
