

FROM spin42/ovcs-ros2-base:ubuntu-24-04

RUN git clone --recursive https://github.com/raspberrypi/libcamera.git && \
    cd libcamera && \
    meson setup build --buildtype=release -Dpipelines=rpi/vc4,rpi/pisp -Dipas=rpi/vc4,rpi/pisp -Dv4l2=true -Dgstreamer=enabled -Dtest=false -Dlc-compliance=disabled -Dcam=disabled -Dqcam=disabled -Ddocumentation=disabled -Dpycamera=enabled && \
    ninja -C build && \
    ninja -C build install

RUN git clone --branch v1.7.0 --depth 1 https://github.com/raspberrypi/rpicam-apps.git && \
    cd rpicam-apps && \
    meson setup build -Denable_libav=disabled -Denable_drm=enabled -Denable_egl=disabled -Denable_qt=disabled -Denable_opencv=disabled -Denable_tflite=disabled -Denable_hailo=disabled && \
    meson compile -C build && \
    meson install -C build && \
    ldconfig

RUN git clone https://github.com/raspberrypi/picamera2.git && \
    cd picamera2 && \
    pip install --break-system-packages .

RUN git clone https://github.com/tomba/kmsxx.git && \
    cd kmsxx && \
    git checkout b91affd && \
    meson setup build && \
    ninja -C build && \
    meson install -C build

RUN git clone https://github.com/raspberrypi/pykms && \
    cd pykms && \
    pip install --break-system-packages .

RUN ldconfig

RUN mkdir -p /opt/ros2_ws/src && \
    cd /opt/ros2_ws/src && \
    git clone --depth 1 https://github.com/open-vehicle-control-system/ovcs_ros2 && \
    cd /opt/ros2_ws && \
    rosdep init && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y --skip-keys=libcamera && \
    # colcon build --symlink-install && \
    echo "source /opt/ros2_ws/install/setup.bash" >> /root/.bashrc

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "sleep", "infinity" ]
VOLUME ["/data"]
