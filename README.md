# 🚀 Raspberry Pi Docker Setup with ROS 2 & Picamera

[![Platform: Raspberry Pi](https://img.shields.io/badge/platform-Raspberry%20Pi-green.svg)](https://www.raspberrypi.com/)
[![Docker](https://img.shields.io/badge/container-docker-blue)](https://www.docker.com/)
[![ROS 2 Jazzy](https://img.shields.io/badge/ros2-jazzy-blueviolet)](https://docs.ros.org/en/jazzy/)

This repository helps you run **ROS 2 Jazzy** inside Docker with full support for:

- 🖼️ `libcamera` (via Picamera2)
- 🧠 [Hailo AI HAT](https://hailo.ai/products/hailo-8-ai-accelerator-module/hailo-8-application-processor-hats/) (for real-time edge AI)

---

## 🛠️ Requirements

- Raspberry Pi running **64-bit Debian Bookworm**
- Docker installed on both Raspberry Pi and development machine

---

## 📦 Docker Image Build

### ✅ Initialize multi arch builder on `amd64` (your desktop/laptop)

```bash
docker buildx create --name multiarch-builder --node amd64-node --platform liunx/amd64 --driver docker-container
docker buildx create --name multiarch-builder --node arm64-node --platform linux/arm64 --driver docker-container ssh://PI_USER@PI_IP_ADDRESS --append
docker buildx inspect --bootstrap
```

### ✅ On `amd64` (your desktop/laptop)

Cross-compile the image for the Raspberry Pi (ARM64) and push it to your container registry or use `--load`:

```bash
docker buildx build \
  --platform linux/arm64 \
  -t ghcr.io/open-vehicle-control-system/ovcs-ros2-bookworm-jazzy-rpi:latest \
  -f dockerfile/debian-bookworm-jazzy/raspberry/Dockerfile \
  --push \
  dockerfile/debian-bookworm-jazzy/raspberry
```

```bash
docker buildx build \
  --platform linux/arm64,linux/amd64 \
  -t ghcr.io/open-vehicle-control-system/zenoh:1.4.0 \
  -f dockerfile/zenoh/Dockerfile \
  --push \
  dockerfile/zenoh
```

```bash
docker build \
  -t ghcr.io/open-vehicle-control-system/ovcs-ros2-noble-jazzy-desktop:latest \
  -f dockerfile/ubuntu-24-04-jazzy/desktop/Dockerfile \
  dockerfile/ubuntu-24-04-jazzy/desktop
```
---

### 🍓 On Raspberry Pi

#### 🔧 Build the image locally:

```bash
docker build \
  -t ghcr.io/open-vehicle-control-system/ovcs-ros2-bookworm-jazzy-rpi:latest \
  -f dockerfile/debian-bookworm-jazzy/raspberry/Dockerfile \
  dockerfile/debian-bookworm-jazzy/raspberry
```

#### 🎥 Run the container with **Picamera2 support**:

```bash
docker run --rm -it \
  --privileged \
  -v /run/udev:/run/udev:ro \
  ghcr.io/open-vehicle-control-system/ovcs-ros2-bookworm-jazzy-rpi:latest
```

> 🔐 The `--privileged` flag and `/run/udev` volume mount are required for camera hardware access.

---

## 🔄 Resetting `cloud-init` State (Optional)

If you need to reset your cloud-init setup (for example, to regenerate SSH keys or re-run first boot configs):

```bash
sudo vi /boot/firmware/user-data
cloud-init schema --config-file /boot/firmware/user-data
sudo cloud-init clean
```

---

## 📚 Resources

- [ROS 2 Jazzy](https://docs.ros.org/en/jazzy/)
- [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [Picamera2](https://github.com/raspberrypi/picamera2)

---

## 🧪 Tested On

- Raspberry Pi 5 (64-bit Ubuntu  24.04)
- Docker `>= 24.x`
- ROS 2 Jazzy
- Picamera2 v0.3+

---

Happy hacking! 🧪🔬


ls /dev/input/by-id/
readlink -f /dev/input/by-id/usb-Microsoft_Controller_3039373130343938333434343332-event-joystick

docker run --rm -ti --net host --device=/dev/input/js0 --device=/dev/input/event18 ghcr.io/open-vehicle-control-system/ovcs-ros2-noble-jazzy-desktop:latest ros2 run joy joy_node
https://docs.ros.org/en/jazzy/p/joy/
