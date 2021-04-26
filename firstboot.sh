#!/bin/bash

# apt update but ignore date errors
apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false

DEBIAN_FRONTEND=noninteractive apt-get install -yqq gpsd gpsd-clients wget git dkms

wget -O - https://www.kismetwireless.net/repos/kismet-release.gpg.key | apt-key add -
echo 'deb https://www.kismetwireless.net/repos/apt/release/buster buster main' | tee /etc/apt/sources.list.d/kismet.list

# apt update but ignore date errors
apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false

DEBIAN_FRONTEND=noneinteractive apt-get install -yqq kismet

# configuring and enabling gpsd and kismet
wget -O /etc/default/gpsd https://gist.githubusercontent.com/LoudSoftware/f73fad017f90a0c2a7250365dfdfe602/raw/1d5dc25fc09144620fa5bf772a9df4e0b01497ec/gpsd

systemctl daemon-reload
systemctl enable gpsd

# You may want to lock uart speed if gpsd doesn't autodetect your gps baud rate
# echo 'init_uart_baud=57600' >> /boot/config.txt

wget -O /etc/kismet/kismet.conf https://gist.githubusercontent.com/LoudSoftware/95662beafdc311ee01bb8a0bd9a66111/raw/34a1cf17bd67e931e0447987acec84997b212662/kismet.conf
systemctl enable kismet

# installing drivers for USB wifi card
DEBIAN_FRONTEND=noninteractive apt-get install -yqq raspberrypi-kernel-headers build-essential
git clone https://github.com/aircrack-ng/rtl8812au.git
cd rtl8812au
make dkms_install

echo 'Initial config done, reboot' > /home/pi/INSTALLED


