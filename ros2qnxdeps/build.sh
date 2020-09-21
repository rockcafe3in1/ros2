#!/bin/bash

set e-

echo "Building ROS2 QNX Dependencies..."

#find . -maxdepth 2 -mindepth 2 -type f -name build.sh -exec {} ';'

cd src

cd apr
./build.sh

cd ../apr-util
./build.sh

cd ../log4cxx
./build.sh

cd ../libxslt
./build.sh

cd ../lxml
./build.sh

cd ../asio
./build.sh

cd ../memory
./build.sh

cd ../libpng16
./build.sh

cd ../opencv
./build.sh

cd ../eigen3
./build.sh

cd ../bullet3
./build.sh

cd ../netifaces
./build.sh

cd ../tinyxml2
./build.sh

cd ../numpy
./build.sh

cd ../uncrustify
./build.sh
