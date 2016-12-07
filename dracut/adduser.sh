#!/bin/sh -x
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

# Set hostname here
echo "Setting hostname..."
echo void-custom > ${NEWROOT}/etc/hostname

AUTOLOGIN=$(getarg live.autologin)
USERNAME=$(getarg live.user)
USERSHELL=$(getarg live.shell)

[ -z "$USERNAME" ] && USERNAME=user
[ -x $NEWROOT/bin/bash -a -z "$USERSHELL" ] && USERSHELL=/bin/bash
[ -z "$USERSHELL" ] && USERSHELL=/bin/sh

# Create /etc/default/live.conf to store USER.
echo "USERNAME=$USERNAME" >> ${NEWROOT}/etc/default/live.conf
chmod 644 ${NEWROOT}/etc/default/live.conf

if ! grep -q ${USERSHELL} ${NEWROOT}/etc/shells ; then
    echo "${USERSHELL} as a login shell..."
    echo ${USERSHELL} >> ${NEWROOT}/etc/shells
fi

# Create new user and remove password. We'll use autologin by default.
echo "Creating live user and setting its password..."
chroot ${NEWROOT} useradd -m -c $USERNAME -G audio,video,wheel -s $USERSHELL $USERNAME
# Remove default gtk theme, gtk config, and xfce4 panel config from /etc/skel.
chroot ${NEWROOT} sh -c 'rm -r /etc/skel/.gtkrc-2.0'
chroot ${NEWROOT} sh -c 'rm -r /etc/skel/.themes'
chroot ${NEWROOT} sh -c 'rm -r /etc/skel/.config'
chroot ${NEWROOT} passwd -d $USERNAME >/dev/null 2>&1

# Setup default root/user password (voidlinux).
echo "Setting up the root user..."
chroot ${NEWROOT} sh -c 'echo "root:root" | chpasswd -c SHA512'
chroot ${NEWROOT} sh -c "echo "$USERNAME:$USERNAME" | chpasswd -c SHA512"
chroot ${NEWROOT} sh -c 'chsh --shell /bin/bash root'

# Enable sudo permission by default.
if [ -f ${NEWROOT}/etc/sudoers ]; then
    echo "Setting up sudo(8)"
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> ${NEWROOT}/etc/sudoers
fi

if [ -d ${NEWROOT}/etc/polkit-1 ]; then
    # If polkit is installed allow users in the wheel group to run anything.
    echo "Setting up polkit..."
    cat > ${NEWROOT}/etc/polkit-1/rules.d/void-live.rules <<_EOF
polkit.addAdminRule(function(action, subject) {
    return ["unix-group:wheel"];
});

polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
_EOF
    chroot ${NEWROOT} chown polkitd:polkitd /etc/polkit-1/rules.d/void-live.rules
fi

if [ -n "$AUTOLOGIN" ]; then
        echo "Setting up autologin..."
        sed -i "s,GETTY_ARGS=\"--noclear\",GETTY_ARGS=\"--noclear -a $USERNAME\",g" ${NEWROOT}/etc/sv/agetty-tty1/run
fi

if [ -e "${NEWROOT}/usr/bin/screenfetch" ]; then
echo "Setting up screenfetch in bashrc..."
echo "screenfetch" >> ${NEWROOT}/etc/bash/bashrc.d/90-screenfetch.sh
fi
