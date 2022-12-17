#!/bin/bash

export QT_QPA_PLATFORM=eglfs
export QT_IM_MODULE=qtvirtualkeyboard
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR="2"
export QT_VIRTUALKEYBOARD_STYLE=cutie
export QT_VIRTUALKEYBOARD_LAYOUT_PATH=/usr/share/cutie-keyboard/layouts
./cutie-ui-io
