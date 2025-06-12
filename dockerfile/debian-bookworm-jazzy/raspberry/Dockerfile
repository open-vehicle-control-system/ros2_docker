FROM debian:bookworm

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    ROS_DISTRO=jazzy \
    RMW_IMPLEMENTATION=rmw_zenoh_cpp \
    ROSDEP_SKIP_KEYS="fastcdr rti-connext-dds-6.0.1 urdfdom_headers python3-vcstool cargo rustc"

WORKDIR /opt

RUN apt-get update && apt-get install -y gnupg2 curl lsb-release locales software-properties-common && \
    curl -fsSL https://archive.raspberrypi.com/debian/raspberrypi.gpg.key | gpg --dearmor -o /usr/share/keyrings/raspberrypi-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/raspberrypi-archive-keyring.gpg] http://archive.raspberrypi.com/debian/ bookworm main" > /etc/apt/sources.list.d/raspberrypi.list && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    wget \
    vim \
    build-essential \
    rpicam-apps \
    hailo-tappas-core \
    hailo-all \
    python3-picamera2 \
    python3-flake8-blind-except \
    python3-flake8-class-newline \
    python3-flake8-deprecated \
    python3-mypy \
    python3-pip \
    python3-pytest \
    python3-pytest-cov \
    python3-pytest-mock \
    python3-pytest-repeat \
    python3-pytest-rerunfailures \
    python3-pytest-runner \
    python3-pytest-timeout \
    python3-rosdep2 \
    vcstool \
    python3-vcstools \
    colcon && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/ros2/src && \
    cd /opt/ros2 && \
    vcs import --input https://raw.githubusercontent.com/ros2/ros2/jazzy/ros2.repos src

RUN cd /opt/ros2 && \
    apt-get update && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -y --rosdistro jazzy --skip-keys "$ROSDEP_SKIP_KEYS" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cd /opt/ros2 && \
    RMW_IMPLEMENTATION=rmw_fastrtps_cpp colcon build --symlink-install && \
    echo "source /opt/ros2/install/setup.bash" >> /root/.bashrc

RUN curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    echo "source /root/.cargo/env" >> /root/.bashrc

RUN mkdir -p /opt/ros2_packages/src && \
    cd /opt/ros2_packages/src && \
    git clone https://github.com/ros2/rmw_zenoh.git -b jazzy && \
    git clone https://github.com/ros-perception/vision_opencv.git && \
    git clone https://github.com/ros-perception/image_pipeline.git -b jazzy

RUN cd /opt/ros2_packages && \
    source /opt/ros2/install/setup.bash && \
    apt-get update && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -y --rosdistro jazzy --skip-keys "$ROSDEP_SKIP_KEYS"  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cd /opt/ros2_packages && \
    source /opt/ros2/install/setup.bash && \
    source /root/.cargo/env && \
    RMW_IMPLEMENTATION=rmw_fastrtps_cpp colcon build --symlink-install && \
    echo "source /opt/ros2_packages/install/setup.bash" >> /root/.bashrc

RUN mkdir -p /opt/ros2_ws/src && \
    cd /opt/ros2_ws/src && \
    source /opt/ros2/install/setup.bash && \
    source /opt/ros2_packages/install/setup.bash && \
    source /root/.cargo/env && \
    git clone --depth 1 https://github.com/open-vehicle-control-system/ovcs_ros2 && \
    cd /opt/ros2_ws && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y --rosdistro jazzy --skip-keys=libcamera && \
    colcon build --symlink-install && \
    echo "source /opt/ros2_ws/install/setup.bash" >> /root/.bashrc

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD [ "sleep", "infinity" ]
ENTRYPOINT ["/entrypoint.sh"]
