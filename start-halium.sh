#!/bin/bash

export LD_LIBRARY_PATH="/usr/lib/aarch64-linux-gnu/libhybris:/vendor/lib64:/system/lib64:/usr/lib"
export QT_QPA_PLATFORM=hwcomposer
export EGL_PLATFORM=hwcomposer
export QT_IM_MODULE=qtvirtualkeyboard
export QT_VIRTUALKEYBOARD_LAYOUT_PATH=./layouts/
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR="4"
#export QT_QAYLAND_CLIENT_BUFFER_INTEGRATION=wayland-egl
#export QT_QPA_EGLFS_KMS_CONFIG=/opt/cutiepi-shell/kms.conf
#export XDG_RUNTIME_DIR=$HOME/.xdg

#if [ ! "`systemctl is-active connman`" == "active" ]; then 
#    sudo service connman start 
#fi

#rfkill unblock all
#connmanctl disable wifi
#connmanctl enable wifi 

#/opt/qt5/bin/qmlscene /opt/cutiepi-shell/compositor.qml
./cutie-ui-io -plugin libinput
