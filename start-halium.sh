#!/bin/bash

export LD_LIBRARY_PATH="/usr/lib/aarch64-linux-gnu/libhybris:/vendor/lib64:/system/lib64:/usr/lib"
export QT_QPA_PLATFORM=hwcomposer
export EGL_PLATFORM=hwcomposer
export QT_IM_MODULE=qtvirtualkeyboard
export QT_VIRTUALKEYBOARD_LAYOUT_PATH=./layouts/
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR="4"
export QT_VIRTUALKEYBOARD_STYLE=cutie
./cutie-ui-io -plugin libinput
