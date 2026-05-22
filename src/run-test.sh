#!/usr/bin/env bash
set -euo pipefail

sudo rpi-apt-get update
sudo rpi-apt-get install -y --no-install-recommends libopencv-dev

mkdir -p build
cd build

rpi-cmake ..
make app

qemu-aarch64-static -L ${RPI_SYSROOT} app

cd ..
rm -rf build
