#!/bin/sh
# Set mklive options here
COMPRESSION=xz
INITRDCOMPRESSION=xz
ROOTFREELIVE=1024
PACKAGES="gptfdisk htop nano vim hexchat xfce4-whiskermenu-plugin xorg-minimal xorg-input-drivers xorg-video-drivers dejavu-fonts-ttf ConsoleKit2 pulseaudio terminus-font xauth xinit screenFetch xfce4 gtk-engine-murrine gparted hicolor-icon-theme man-db NetworkManager network-manager-applet gnupg lxdm android-tools dialog gnome-themes-standard"
NAME="Void Rescue/Live CD"

# Run mklive here
if [ ! -e ./mklive.sh ]; then
echo "ERROR: mklive.sh is missing."
echo "Please run 'make' then try again."
exit 1
fi
exec ./mklive.sh -i "$INITRDCOMPRESSION" -s "$COMPRESSION" -S "$ROOTFREELIVE" -p "$PACKAGES" -T "$NAME" -I data/include/

