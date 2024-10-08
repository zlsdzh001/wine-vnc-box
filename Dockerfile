FROM ubuntu:20.04

LABEL maintainer="s.furacas@outlook.com"

RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone

# 安装必要的工具
RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    apt-get install -y wget && \
    apt-get install -y unzip && \
    apt-get install -y git && \
    apt-get install -y curl && \
    apt-get install -y vim && \
    apt-get install -y sudo


RUN apt-get update -y && \
    apt-get install -y supervisor && \
    apt-get install -y xvfb && \
    apt-get install -y x11vnc && \
    apt-get install -y fluxbox && \
    apt-get install -y novnc && \
    apt-get install -y xdotool

# 设置 VNC 密码
RUN mkdir ~/.vnc && x11vnc -storepasswd vncpass ~/.vnc/passwd

RUN apt-get install -y ttf-wqy-microhei locales procps \
    && rm -rf /var/lib/apt/lists/* \
    && sed -ie 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen

RUN  dpkg --add-architecture i386 \
&& mkdir -pm755 /etc/apt/keyrings \
&& wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
&& wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources \
&& apt update -y \
&& apt install -y --install-recommends winehq-stable \
&& apt install -y winetricks

ENV DISPLAY_WIDTH=1280 \
    DISPLAY_HEIGHT=720 \
    DISPLAY=:0.0 \
    LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    WINEPREFIX=/home/app/.wine

COPY etc/ /etc/

RUN useradd -m app && usermod -aG sudo app && echo 'app ALL=(ALL) NOPASSWD:ALL' >> //etc/sudoers

USER app
WORKDIR /home/app

COPY setup /home/app/setup

RUN bash -c 'sudo -E supervisord -c /etc/supervisord.conf -l /var/log/supervisord.log &' && \
    sleep 5 && \
    sudo chown -R app:app /home/app/setup &&  \
    cd /home/app/setup && \
    ./install.sh && \
    sudo rm -rf /home/app/setup 


COPY entrypoint.sh /entrypoint.sh


CMD ["/entrypoint.sh"]

