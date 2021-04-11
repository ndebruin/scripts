#!/bin/bash

REPOURL=https://raw.githubusercontent.com/draigon0/scripts/init/main

mkdir .ssh
cd .ssh
wget $REPOURL/authorized_keys
cd ..

cd /usr/local/share/ca-certificates
sudo mkdir draigon-CA
sudo mkdir ndebruin-CA

cd draigon-CA
sudo wget $REPOURL/draigon-CA.crt

cd ../ndebruin-CA
sudo wget $REPOURL/ndebruin-CA.crt
sudo update-ca-certificates

sudo apt update
sudo apt full-upgrade -y

sudo apt install -y htop curl dnsutils net-tools qemu-guest-agent rsync

cd ~/
sudo sed -i -e '32 s/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i -e '56 s/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
