#!/bin/bash

#fedora workstation installation script
#===============#
#improve dnf performance
echo 'max_parallel_downloads=10
fastestmirror=True' | sudo tee -a /etc/dnf/dnf.conf > /dev/null
#===============#

#===============#
#upgrade the system
sudo dnf upgrade -y 
#===============#

#===============#
#add rpmfusion repos
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf groupupdate core -y
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf groupupdate sound-and-video -y
#===============#


#===============#
#install native packages 
sudo dnf install akmods git fastfetch htop mc wireguard-tools
#===============#


#===============#
#remove native ff and libreoffice packages to replace them with flatpaks
sudo dnf remove firefox *libreoffice* -y
#===============#

#===============#
#swap nano to vim
sudo dnf swap nano-default-editor vim-default-editor -y
#===============#


#===============#
#import vscode repo and install code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install code -y
#===============#

#===============#
#install flatpaks
flatpak update -y
flatpak install flathub org.mozilla.firefox org.libreoffice.LibreOffice com.bitwarden.desktop com.usebottles.bottles org.telegram.desktop com.spotify.Client  org.torproject.torbrowser-launcher com.github.wwmm.easyeffects io.mpv.Mpv -y
#===============#

#===============#
#configure vim
echo "set nocompatible
filetype on
filetype plugin indent on
set title
syntax on
set number relativenumber
set ts=4 sw=4" > ~/.vimrc
#===============#

#===============#
#configure cloudflare dns
if [[ ! -f /etc/systemd/resolved.conf ]]
then
	sudo cp /usr/lib/systemd/resolved.conf /etc/systemd/resolved.conf
	sudo sed -i 's/#DNS=/DNS=9.9.9.9 149.112.112.112/' /etc/systemd/resolved.conf
 	sudo sed -i 's/#Domains=/Domains=~./' /etc/systemd/resolved.conf
   	sudo sed -i 's/#DNSOverTLS=no/DNSOverTLS=yes/' /etc/systemd/resolved.conf
else
	sudo sed -i 's/#DNS=/DNS=9.9.9.9 149.112.112.112/' /etc/systemd/resolved.conf
 	sudo sed -i 's/#Domains=/Domains=~./' /etc/systemd/resolved.conf
   	sudo sed -i 's/#DNSOverTLS=no/DNSOverTLS=yes/' /etc/systemd/resolved.conf
fi
#===============#

#===============#
#restart the system
reboot
#===============#
