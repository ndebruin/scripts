#!/bin/bash

REPOURL=http://scratch.draigon.org/init

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

cd ~/

sudo apt update
sudo apt full-upgrade -y

sudo apt install -y htop curl dnsutils net-tools nmap rsync

HYP=$(lscpu | grep "Hypervisor vendor:")

case $HYP in
  *"KVM"*)
    sudo apt install -y qemu-guest-agent
    ;;
  *"VMware"*)
    sudo apt install -y open-vm-tools
    ;;
esac

sudo sed -i -e '32 s/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i -e '56 s/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
