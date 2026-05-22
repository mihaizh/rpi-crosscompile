FROM mcr.microsoft.com/devcontainers/cpp:debian-12

ENV DEBIAN_FRONTEND=noninteractive
ENV RPI_SYSROOT=/opt/rpi-sysroot
ENV QEMU_LD_PREFIX=/opt/rpi-sysroot

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl gnupg debootstrap qemu-user-static \
    cmake ninja-build pkg-config git rsync \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu gdb-multiarch \
    && rm -rf /var/lib/apt/lists/*

# Create an ARM64 Debian Bookworm rootfs as the base.
# Raspberry Pi OS 64-bit is Debian arm64 + Raspberry Pi repo overlays.
RUN mkdir -p ${RPI_SYSROOT} \
    && debootstrap --arch=arm64 --foreign bookworm ${RPI_SYSROOT} http://deb.debian.org/debian \
    && cp /usr/bin/qemu-aarch64-static ${RPI_SYSROOT}/usr/bin/ \
    && chroot ${RPI_SYSROOT} /debootstrap/debootstrap --second-stage

# Add Raspberry Pi repo overlay inside the sysroot.
RUN mkdir -p ${RPI_SYSROOT}/etc/apt/sources.list.d \
    && printf '%s\n' \
      'deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware' \
      'deb http://deb.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware' \
      'deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware' \
      > ${RPI_SYSROOT}/etc/apt/sources.list \
    && printf '%s\n' \
      'deb http://archive.raspberrypi.com/debian bookworm main' \
      > ${RPI_SYSROOT}/etc/apt/sources.list.d/raspi.list

# Install Raspberry Pi archive key into the ARM64 sysroot
RUN mkdir -p ${RPI_SYSROOT}/usr/share/keyrings \
    && curl -fsSL https://archive.raspberrypi.com/debian/raspberrypi.gpg.key \
      | gpg --dearmor \
      > ${RPI_SYSROOT}/usr/share/keyrings/raspberrypi-archive-keyring.gpg

RUN printf '%s\n' \
    'deb [signed-by=/usr/share/keyrings/raspberrypi-archive-keyring.gpg] http://archive.raspberrypi.com/debian bookworm main' \
    > ${RPI_SYSROOT}/etc/apt/sources.list.d/raspi.list

COPY rpi-apt-get /usr/local/bin/
RUN chmod +x /usr/local/bin/rpi-apt-get

RUN mkdir -p /opt/toolchains/
COPY rpi-aarch64.cmake /opt/toolchains/

COPY rpi-cmake /usr/local/bin/
RUN chmod +x /usr/local/bin/rpi-cmake

COPY rpi-fix-symlinks /usr/local/bin/
RUN chmod +x /usr/local/bin/rpi-fix-symlinks

# Install target packages into the ARM64 sysroot.
RUN rpi-apt-get update \
    && rpi-apt-get install -y --no-install-recommends \
       libcamera-dev \
       rpicam-apps \
       libjpeg-dev \
       libpng-dev \
    && rpi-apt-get clean
