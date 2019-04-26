# ZephyDocker

This is a Ubuntu 18.04 based container, for Zephyr development

The shared directory is $HOME/Zephyr, seen as /Zephyr within the container.
The zephyr installation in container is in /home/user/zephyr

# Build

```
docker build --network=host --build-arg=uid=$(id -u) -t zephyr .
```

# Run
```
docker run -it  --network=host --tmpfs /tmp  --security-opt=label:type:spc_t --privileged -v /dev/bus/usb:/dev/bus/usb --user=$(id -u):$(id -g) -v $HOME/Zephyr:/Zephyr  --rm zephyr
```
