#!/usr/bin/env bash
set -euo pipefail

mkdir -p build
cd build

rpi-cmake ..
make app

qemu-aarch64-static -L ${RPI_SYSROOT} app

cd ..
rm -rf build
