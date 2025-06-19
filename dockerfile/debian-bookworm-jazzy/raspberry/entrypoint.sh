#!/bin/bash
set -e

WS_DIR=/opt/ros2_ws
SRC_DIR="$WS_DIR/src"
CHECKSUM_FILE="$WS_DIR/.package_xml_checksum"

source /root/.cargo/env
source /opt/ros2/install/setup.bash
source /opt/ros2_packages/install/setup.bash

if [ "$BUILD_OVCS_ROS2_WS" = "yes" ]; then
  cd "$WS_DIR"
  colcon build --symlink-install
fi

source /opt/ros2_ws/install/setup.bash

exec "$@"
