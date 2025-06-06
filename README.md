docker run --rm -it --privileged -v /run/udev:/run/udev:ro test

docker buildx build --platform linux/amd64,linux/arm64 -t spin42/ovcs-ros2-base:ubuntu-24-04 -f dockerfile/ubuntu-24-04-jazzy/base/Dockerfile --push dockerfile/ubuntu-24-04-jazzy/base
docker buildx build --platform linux/amd64,linux/arm64 -t spin42/ovcs-ros2-raspberry:ubuntu-24-04 -f dockerfile/ubuntu-24-04-jazzy/raspberry/Dockerfile --push dockerfile/ubuntu-24-04-jazzy/raspberry
docker buildx build --platform linux/amd64 -t spin42/ovcs-ros2-desktop:ubuntu-24-04 -f dockerfile/ubuntu-24-04-jazzy/desktop/Dockerfile --push dockerfile/ubuntu-24-04-jazzy/desktop

sudo vi /boot/firmware/user-data
cloud-init schema --config-file /boot/firmware/user-data
sudo cloud-init clean
