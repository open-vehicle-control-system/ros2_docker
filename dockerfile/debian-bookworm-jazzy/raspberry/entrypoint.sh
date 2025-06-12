#!/bin/bash
set -e

WS_DIR=/opt/ros2_ws
SRC_DIR="$WS_DIR/src"
REPO_NAME=ovcs_ros2
CHECKSUM_FILE="$WS_DIR/.package_xml_checksum"

cd "$WS_DIR"
colcon build --symlink-install

source /opt/ros/jazzy/setup.bash
source "$WS_DIR/install/setup.bash"

exec "$@"
