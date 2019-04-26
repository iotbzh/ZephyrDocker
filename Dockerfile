
FROM ubuntu:18.04

RUN apt-get update
RUN apt-get -y upgrade

RUN apt install -y --no-install-recommends git 
RUN apt install -y --no-install-recommends cmake
RUN apt install -y --no-install-recommends ninja-build 
RUN apt install -y --no-install-recommends gperf
RUN apt install -y --no-install-recommends ccache
RUN apt install -y --no-install-recommends git
RUN apt install -y --no-install-recommends dfu-util
RUN apt install -y --no-install-recommends device-tree-compiler
RUN apt install -y --no-install-recommends wget
RUN apt install -y --no-install-recommends python3-pip
RUN apt install -y --no-install-recommends python3-setuptools
RUN apt install -y --no-install-recommends python3-wheel
RUN apt install -y --no-install-recommends xz-utils
RUN apt install -y --no-install-recommends file
RUN apt install -y --no-install-recommends make
RUN apt install -y --no-install-recommends gcc
RUN apt install -y --no-install-recommends gcc-multilib
RUN apt install -y locales
RUN apt install -y sudo
RUN apt install -y vim
RUN apt install -y tree

# Locale settings
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ARG gid=1000
RUN groupadd -g $gid user
ARG uid=1000
RUN useradd -u $uid -g user user
RUN mkdir /workdir && chown user /workdir
RUN mkdir -p /home/user && chown -R user:user /home/user

RUN echo "user ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

RUN mkdir /Zephyr && chown user /Zephyr


WORKDIR /home/user
USER user

RUN wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.10.0/zephyr-sdk-0.10.0-setup.run
RUN chmod +x /home/user/zephyr-sdk-0.10.0-setup.run

RUN sudo ./zephyr-sdk-0.10.0-setup.run --target /tmp --noexec
RUN cd /tmp && sudo ./setup.sh -y

ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr
ENV ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk/

RUN sudo pip3 install cmake
RUN sudo pip3 install west

RUN git clone https://github.com/zephyrproject-rtos/zephyr.git

ENV PATH=~/.local/bin:$PATH

RUN bash -c "cd zephyr && source zephyr-env.sh && cd .. && west init -l zephyr && west update"

RUN pip3 install --user -r zephyr/scripts/requirements.txt

RUN echo ". ~/zephyr/zephyr-env.sh" >> .bashrc

ENTRYPOINT [ "/bin/bash" ]

