apt-get update
apt-get install -y \
    gcc \
    git \
    wget \
    curl \
    make \
    cmake \
    ccache \
    libncurses-dev \
    flex \
    bison \
    gperf \
    python \
    python-serial \
    python-pip \
    linux-modules-extra-$(uname -r)

adduser vagrant dialout

mkdir -p /opt/esp
if ! (echo "A97823F9DA1776BFEF62A9E196F8D04CD0BACAFC /opt/esp/toolchain.tar.gz" | sha1sum -c -); then
    wget --no-verbose https://dl.espressif.com/dl/xtensa-lx106-elf-linux64-1.22.0-92-g8facf4c-5.2.0.tar.gz -O /opt/esp/toolchain.tar.gz
    echo "A97823F9DA1776BFEF62A9E196F8D04CD0BACAFC /opt/esp/toolchain.tar.gz" | sha1sum -c -
fi
rm -rf /opt/esp/toolchain
mkdir -p /opt/esp/toolchain
tar -xzf /opt/esp/toolchain.tar.gz --directory /opt/esp/toolchain

if [ ! -d /opt/esp/sdk ]; then
    git clone --recursive --branch master https://github.com/sstamoulis/ESP8266_RTOS_SDK.git /opt/esp/sdk
else
    git -C /opt/esp/sdk pull
fi

chown -R root:vagrant /opt/esp

cat > /etc/profile.d/esp8266.sh << 'EOL'
#!/bin/bash
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$1"
    fi
}
export IDF_PATH="/opt/esp/sdk"
pathadd /opt/esp/sdk/tools
pathadd /opt/esp/toolchain/xtensa-lx106-elf/bin
EOL

. /etc/profile.d/esp8266.sh

python -m pip install -r $IDF_PATH/requirements.txt