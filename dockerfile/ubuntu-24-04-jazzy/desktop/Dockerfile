FROM ubuntu:24.04

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    ROS_DISTRO=jazzy

WORKDIR /opt

RUN apt-get update && apt-get install -y curl gnupg2 lsb-release locales software-properties-common && \
    locale-gen en_US en_US.UTF-8 && update-locale LANG=en_US.UTF-8

RUN add-apt-repository universe

RUN curl -L -o /tmp/ros2-apt-source.deb \
    "https://github.com/ros-infrastructure/ros-apt-source/releases/download/1.1.0/ros2-apt-source_1.1.0.noble_all.deb" && \
    apt-get update && \
    apt-get install -y /tmp/ros2-apt-source.deb

RUN apt update && apt install -y \
    build-essential cmake meson ninja-build python3 python3-pip python3-jinja2 python3-ply python3-yaml pybind11-dev \
    git wget ca-certificates pkg-config libtbb-dev libevent-dev libudev-dev libv4l-dev libdrm-dev libexpat1-dev \
    libjpeg-dev libpng-dev libtiff-dev libexif-dev libssl-dev openssl libboost-dev libboost-program-options-dev \
    libgnutls28-dev qtbase5-dev qt5-qmake libqt5core5a libqt5gui5 libqt5widgets5 qttools5-dev qttools5-dev-tools \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libglib2.0-dev libcap-dev libfmt-dev \
    ros-jazzy-ros-base ros-dev-tools python3-colcon-common-extensions python3-argcomplete \
    ros-jazzy-camera-info-manager-py ros-jazzy-stereo-image-proc ros-jazzy-image-transport ros-jazzy-image-common \
    ros-jazzy-compressed-depth-image-transport ros-jazzy-compressed-image-transport ros-jazzy-zstd-image-transport \
    ros-jazzy-turbojpeg-compressed-image-transport ros-jazzy-foxglove-bridge ros-jazzy-foxglove-compressed-video-transport ros-jazzy-ffmpeg-image-transport ros-jazzy-desktop ros-jazzy-joy iproute2 usbutils

RUN curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    echo "source /root/.cargo/env" >> ~/.bashrc

RUN mkdir -p /opt/ros2_packages/src && \
    cd /opt/ros2_packages/src && \
    git clone https://github.com/ros2/rmw_zenoh.git -b jazzy

RUN cd /opt/ros2_packages && \
    source /opt/ros/jazzy/setup.bash && \
    apt-get update && \
    rosdep init && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -y --rosdistro jazzy --skip-keys "cargo rustc" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cd /opt/ros2_packages && \
    source /opt/ros/jazzy/setup.bash && \
    source /root/.cargo/env && \
    colcon build --symlink-install

ENV RMW_IMPLEMENTATION=rmw_zenoh_cpp

RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc && \
    echo "source /opt/ros2_packages/install/setup.bash" >> ~/.bashrc


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
