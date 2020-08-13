#!/bin/sh

# Temporary set up the nameserver
mv /etc/resolv.conf /etc/resolv2.conf
echo "nameserver 1.1.1.1" > /etc/resolv.conf

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

echo "deb http://repo.ubports.com/ xenial_-_gst-droid main" >> /etc/apt/sources.list.d/ubports.list

echo "" >> /etc/apt/preferences.d/ubports.pref
echo "Package: *" >> /etc/apt/preferences.d/ubports.pref
echo "Pin: release o=UBports,a=xenial_-_gst-droid" >> /etc/apt/preferences.d/ubports.pref
echo "Pin-Priority: 1500" >> /etc/apt/preferences.d/ubports.pref

apt update
apt upgrade -y --allow-downgrades

apt install -y gstreamer1.0-droid nemo-qtmultimedia-plugins

# custom camera+gstreamer-droid
mkdir -p /root/camera
wget https://gitlab.com/peat-psuwit/camera-app/-/jobs/676388691/artifacts/raw/build/aarch64-linux-gnu/app/com.ubuntu.camera_3.1.3+gstdroid2_arm64.click -P /root/camera/
pkcon install-local --allow-untrusted /root/camera/com.ubuntu.camera_3.1.3+gstdroid2_arm64.click
rm -rf /root/camera

# Restore symlink
rm /etc/resolv.conf
mv /etc/resolv2.conf /etc/resolv.conf
