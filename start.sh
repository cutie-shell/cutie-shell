#!/bin/bash

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export QT_QPA_PLATFORM=eglfs
export QT_IM_MODULE=qtvirtualkeyboard
export QT_QAYLAND_CLIENT_BUFFER_INTEGRATION=wayland-egl
#export QT_QPA_EGLFS_KMS_CONFIG=/opt/cutiepi-shell/kms.conf
export XDG_RUNTIME_DIR=$HOME/.xdg

#if [ ! "`systemctl is-active connman`" == "active" ]; then 
#    sudo service connman start 
#fi

#rfkill unblock all
#connmanctl disable wifi
#connmanctl enable wifi 

./cutie-ui-io -plugin libinput
