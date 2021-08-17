#!/bin/bash

echo -e  "\e[32m[X] Upgrading packages and installing necessary dependencies"
sudo apt update -y
sudo apt upgrade -y
sudo apt install git qtdeclarative5-dev qdbus qtcreator qml qtbase5-gles-dev qt5-qpa-hwcomposer-plugin g++ make libudev-dev qml-module-qtquick2 qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtsensors qml-module-qtwayland-compositor qml-module-qtquick-virtualkeyboard polkit-kde-agent-1 libqt5dbus5 libqt5waylandclient5 libqt5waylandclient5-dev qtwayland5 qtvirtualkeyboard-plugin -y
cd ~
echo -e  "\e[32m[X] Cloning repositories"
sudo git clone https://github.com/Cutie-Pi-Shell-community-project/atmospheres.git /usr/share/atmospheres
git clone https://github.com/Cutie-Pi-Shell-community-project/cutie-shell
git clone https://github.com/Cutie-Pi-Shell-community-project/cutie-settings-daemon.git
git clone https://github.com/Cutie-Pi-Shell-community-project/qml-module-cutie.git

echo -e  "\e[32m[X] Installing cutie-shell-daemon"
cd cutie-settings-daemon
qmake
make -j$(nproc)
sudo make install

echo -e  "\e[32m[X] Installing qml-module-cutie"
cd ../qml-module-cutie
qmake
make -j$(nproc)
sudo make install

echo -e  "\e[32m[X] Installing cutie-shell"
cd ../cutie-shell
sudo mkdir -p /etc/systemd/logind.conf.d/
sudo cp -R logind.conf.d/10-cutie.conf /etc/systemd/logind.conf.d/10-cutie.conf
qmake
make -j$(nrpco)
sudo make install
sudo cp cutie-ui-io.service /usr/lib/systemd/system/cutie-ui-io.service
sudo systemctl daemon-reload
sudo systemctl disable phosh
sudo systemctl enable cutie-settings-daemon
sudo systemctl enable cutie-ui-io

echo -e  "\e[32m[X] Installation finished, please reboot now."

