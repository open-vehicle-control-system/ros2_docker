#!/bin/bash
set -e

WS_DIR=/opt/ros2_ws
SRC_DIR="$WS_DIR/src"
REPO_NAME=ovcs_ros2
CHECKSUM_FILE="$WS_DIR/.package_xml_checksum"

cd "$SRC_DIR/$REPO_NAME"
echo "Pulling latest changes for $REPO_NAME..."

# Save current checksums of all package.xml files
find "$SRC_DIR" -name package.xml -exec md5sum {} \; > "$WS_DIR/.package_xml_checksum.old" || true

# Pull latest changes
git pull || echo "Warning: Failed to pull updates."

# Save new checksums
find "$SRC_DIR" -name package.xml -exec md5sum {} \; > "$WS_DIR/.package_xml_checksum.new"

# Compare old vs new checksums
if ! cmp -s "$WS_DIR/.package_xml_checksum.old" "$WS_DIR/.package_xml_checksum.new"; then
  echo "Detected changes in package.xml files. Updating rosdep..."
  rosdep update
  rosdep install --from-paths $SRC_DIR --ignore-src -r -y --skip-keys=libcamera
else
  echo "No changes in package.xml. Skipping rosdep."
fi

# Clean up
mv "$WS_DIR/.package_xml_checksum.new" "$CHECKSUM_FILE"
rm -f "$WS_DIR/.package_xml_checksum.old"

cd "$WS_DIR"
colcon build --symlink-install

source /opt/ros/jazzy/setup.bash
source "$WS_DIR/install/setup.bash"

# # Fallback in case the ros2 command is not in PATH after sourcing
# export PATH="$PATH:/opt/ros/jazzy/bin:/opt/ros2_ws/install/bin"

# Optional debug output
echo "ROS2 path: $(which ros2 || echo 'ros2 NOT FOUND')"

exec "$@"
