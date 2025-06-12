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

### ✅ On `amd64` (your desktop/laptop)

Cross-compile the image for the Raspberry Pi (ARM64) and push it to your container registry or use `--load`:

```bash
docker buildx build \
  --platform linux/arm64 \
  -t test \
  -f dockerfile/debian-bookworm-jazzy/raspberry/Dockerfile \
  --push \
  dockerfile/debian-bookworm-jazzy/raspberry
```

---

### 🍓 On Raspberry Pi

#### 🔧 Build the image locally:

```bash
docker build \
  -t test \
  -f dockerfile/debian-bookworm-jazzy/raspberry/Dockerfile \
  dockerfile/debian-bookworm-jazzy/raspberry
```

#### 🎥 Run the container with **Picamera2 support**:

```bash
docker run --rm -it \
  --privileged \
  -v /run/udev:/run/udev:ro \
  test
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
