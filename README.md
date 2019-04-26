# ZephyDocker
This is a Ubuntu 18.04 based container, for Zephyr developement

# Build
```
docker build --network=host --build-arg=uid=$(id -u) -t zephyr .
```

# Run
```
docker run -it  --network=host --tmpfs /tmp  --security-opt=label:type:spc_t --user=$(id -u):$(id -g) -v $HOME/Zephyr:/Zephyr  --rm zephyr
```
