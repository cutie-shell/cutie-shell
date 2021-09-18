#!/bin/bash
echo -e  "\e[32m[X] Hybris-installer pre-build packages cutie shell"
echo -e  "\e[32m[X] Upgrading packages and installing necessary dependencies"
sudo apt install cutie-shell cutie-settings-daemon cutie-browser cutie-keyboard cutie-atmospheres qt5-qpa-hwcomposer-plugin libqt5svg5 qtwayland5
