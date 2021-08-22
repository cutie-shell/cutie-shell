#!/bin/bash

export LD_LIBRARY_PATH="/usr/lib/aarch64-linux-gnu/libhybris:/vendor/lib64:/system/lib64:/usr/lib"
export QT_QPA_PLATFORM=hwcomposer
export EGL_PLATFORM=hwcomposer
export QT_IM_MODULE=Maliit
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR="4"
export MALIIT_FORCE_DBUS_CONNECTION=1
./cutie-ui-io -plugin libinput
