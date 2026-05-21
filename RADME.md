# Docker image for RPI crosscompilation

1. Make a devcontainer using the published docker image

```
{
    "name": "my-project",
    "image": "ghcr.io/mihaizh/rpi-crosscompile/rpi-crosscompile:latest"
    "remoteUser": "vscode"
}

```

2. Install packages using `rpi-apt-get`, which is just a wrapper over `chroot ${RPI_SYSROOT} apt-get`

```
sudo rpi-apt-get install libfoo-dev
```

3. Run CMake with the provided toolchain at `/opt/toolchains/rpi-aarch64.cmake`

```
mkdir build && cd build
rpi-cmake <extra args> ..
```

`rpi-cmake` is a wrapper over
```
cmake -DCMAKE_TOOLCHAIN_FILE="${RPI_TOOLCHAIN_FILE:-/opt/toolchains/rpi-aarch64.cmake}"
```

4. Build your project

```
make myapp
```
