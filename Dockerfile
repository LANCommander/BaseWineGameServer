FROM jlesage/baseimage-gui:ubuntu-22.04-v4@sha256:51c11dd8405ec18c65b85808ede782e548d8233705c7fb3a62d0dcf0abca55c3

# Environment variables used by jlesage/baseimage-gui
ENV WINEPREFIX="/config/wine"
ENV WINEARCH="win32"
ENV LANG="en_US.UTF-8"
ENV APP_NAME="LANCommander Game Server Base WINE Image"
ENV FORCE_LATEST_UPDATE="true"
ENV DISABLE_AUTOUPDATE="true"
ENV DISABLE_VIRTUAL_DESKTOP="false"
ENV DISPLAY_WIDTH="1024"
ENV DISPLAY_HEIGHT="768"
ENV WINEDEBUG=-all
ENV DISPLAY=:0
ENV DARK_MODE=1
ENV APP_ICON="/config/favicon.ico"

COPY --link helpers/* /opt/base/bin/

# Install Wine, dependencies, and configure locales.
RUN mkdir -p /config/wine && \
        apt-get update && \
    apt-get install -y \
        curl \
        software-properties-common \
        gnupg2 \
        winbind \
        xvfb && \
    dpkg --add-architecture i386 && \
    curl -O https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main' && \
    apt-get update && \
    apt-get install -y \
        --install-recommends \
        winehq-stable \
        winetricks && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/* winehq.key && \
    wine wineboot --init && \
    winetricks d3dx9 directplay

RUN chmod +x /opt/base/use_app_icon.sh && use_app_icon.sh

# HTTP
EXPOSE 5800

# VNC
EXPOSE 5900