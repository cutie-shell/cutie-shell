#!/bin/bash
echo -e  "\e[32m[X] Hybris-installer cutie shell"
echo -e  "\e[32m[X] Upgrading packages and installing necessary dependencies"
echo "deb http://droidian-libhybris.repo.droidian.org/bullseye-glvnd/ bullseye main" | sudo tee -a /etc/apt/sources.list
sudo apt update -y
sudo apt upgrade -y
sudo apt install git qtdeclarative5-dev qdbus qml qtbase5-gles-dev qt5-qpa-hwcomposer-plugin g++ make libudev-dev qml-module-qtquick2 qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtsensors qml-module-qtwayland-compositor qml-module-qtquick-virtualkeyboard polkit-kde-agent-1 libqt5dbus5 libqt5waylandclient5 libqt5waylandclient5-dev qtwayland5 qtvirtualkeyboard-plugin qml-module-qt-labs-folderlistmodel libqt5multimedia5 qtbase5-private-gles-dev qtwayland5-dev-tools libwayland-dev libxcb* doxygen libchewing3-dev libpinyin13-dev presage libpresage-dev libhunspell-dev qtwayland5-private-dev cmake -y
cd ~

apt download qtmultimedia5-dev
ar x qtmultimedia5*.deb
unxz data.tar.xz
sudo mv data.tar /
cd /
sudo tar -xvf data.tar
sudo rm -rvf data.tar

cd ~

echo -e  "\e[32m[X] Cloning repositories"
sudo git clone https://github.com/cutie-shell/atmospheres.git /usr/share/
git clone https://github.com/cutie-shell/cutie-shell
git clone https://github.com/cutie-shell/cutie-settings-daemon.git
git clone https://github.com/cutie-shell/qml-module-cutie.git
git clone https://github.com/cutie-shell/cutie-keyboard.git
git clone https://github.com/maliit/framework.git

echo -e  "\e[32m[X] Fixing atmospheres"
sudo rm -rf /usr/share/debian
sudo rm -rf /usr/share/LICENSE
sudo rm -rf /usr/share/README.md

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
cd framework
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
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

echo -e "\e32m[X] setting up connman"
sudo systemctl mask connman
sudo apt install connman
echo "PersistentTetheringMode=true" | sudo tee -a /etc/connman/main.conf
sudo systemctl unmask connman
sudo systemctl enable --now connman && sudo systemctl stop usb-tethering && sudo systemctl disable --now NetworkManager && connmanctl enable gadget && connmanctl tether gadget on

sudo reboot -f
