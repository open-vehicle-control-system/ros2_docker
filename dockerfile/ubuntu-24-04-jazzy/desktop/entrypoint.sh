#!/bin/bash
source /root/.cargo/env
source /opt/ros/jazzy/setup.bash
source /opt/ros2_packages/install/setup.bash

exec "$@"
