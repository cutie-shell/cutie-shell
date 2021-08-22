#!/bin/bash

echo -e  "\e[32m[X] Upgrading packages and installing necessary dependencies"
echo "deb http://droidian-libhybris.repo.droidian.org/bullseye-glvnd/ bullseye main" | sudo tee -a /etc/apt/sources.list
sudo apt update -y
sudo apt upgrade -y
sudo apt install git qtdeclarative5-dev qdbus qtcreator qml qtbase5-gles-dev qt5-qpa-hwcomposer-plugin g++ make libudev-dev qml-module-qtquick2 qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtsensors qml-module-qtwayland-compositor qml-module-qtquick-virtualkeyboard polkit-kde-agent-1 libqt5dbus5 libqt5waylandclient5 libqt5waylandclient5-dev qtwayland5 qtvirtualkeyboard-plugin qml-module-qt-labs-folderlistmodel libqt5multimedia5 qtbase5-private-gles-dev qtwayland5-dev-tools libwayland-dev libxcb* doxygen libchewing3-dev libpinyin13-dev presage libpresage-dev libhunspell-dev -y
cd ~
sudo apt download qtmultimedia5-dev
sudo dpkg -i qtmultimedia5-dev*
echo -e  "\e[32m[X] Cloning repositories"
sudo git clone https://github.com/cutie-shell/atmospheres.git /usr/share/atmospheres
git clone https://github.com/cutie-shell/cutie-shell
git clone https://github.com/cutie-shell/cutie-settings-daemon.git
git clone https://github.com/cutie-shell/qml-module-cutie.git
git clone https://github.com/cutie-shell/cutie-keyboard.git
wget https://github.com/maliit/framework/archive/refs/tags/2.0.0.zip

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
cp gtk.css ~/.config/gtk-3.0/gtk.css
qmake
make -j$(nproc)
sudo make install
sudo cp cutie-ui-io.service /usr/lib/systemd/system/cutie-ui-io.service
sudo systemctl daemon-reload
sudo systemctl disable phosh
sudo systemctl enable cutie-settings-daemon
sudo systemctl enable cutie-ui-io

echo -e "\e[32m[X] installing maliit-framework"
cd ~
unzip 2.0.0.zip
cd framework-2.0.0
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make -j$(nproc)
sudo make install

echo -e "\e[32m[X] installing cutie-keyboard"
cd ~
cd cutie-keyboard
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make -j$(nproc)
sudo make install

sudo apt install -f

echo -e "\e32m[X] setting up connman"
sudo systemctl mask connman
sudo apt install connman
echo "PersistentTetheringMode=true" | sudo tee -a /etc/connman/main.conf
sudo systemctl unmask connman
sudo systemctl enable --now connman && sudo systemctl stop usb-tethering && sudo systemctl disable --now NetworkManager && connmanctl enable gadget && connmanctl tether gadget on

sudo reboot -f
