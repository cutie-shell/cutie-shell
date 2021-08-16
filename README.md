# CutiePi-shell-phone-components source
A mobile QtWayland compositor and shell and for smartphones and tablets.

## Screenshots ui
![alt text](https://github.com/Cutie-Pi-Shell-community-project/CutiePi-shell-phone-components/blob/main/screenshots/photo5226690739709261655.jpg) 
Qt5-simple-browser                                                                                        
                                                                                                    
![alt text](https://github.com/Cutie-Pi-Shell-community-project/CutiePi-shell-phone-components/blob/main/screenshots/photo5226690739709261659.jpg) 
Quick StatusBar                                                                                       
                                                                                                  
![alt text](https://github.com/Cutie-Pi-Shell-community-project/CutiePi-shell-phone-components/blob/main/screenshots/photo5226690739709261739.png) 
qt5-apps-launcher                                                                                                                         
                                                                                                
![alt text](https://github.com/Cutie-Pi-Shell-community-project/CutiePi-shell-phone-components/blob/main/screenshots/photo5226690739709261746.png) 
qt5-weather-app                                                                                                   
                                                                                         
![alt text](https://github.com/Cutie-Pi-Shell-community-project/CutiePi-shell-phone-components/blob/main/screenshots/photo5226690739709261779.png) 
qt5-welcome-app                                                                      

## Building and Running on halium9 devices (powered by droidian)
Status: WIP 

Tested on: Volla Phone, Xiaomi Redmi 7

* Install droidian phosh and devtools on your device.  
* Connected the device to a PC running Linux: `ssh droidian@10.15.19.82`    

```
sudo apt update && sudo apt install git qtdeclarative5-dev qtcreator qml qtbase5-gles-dev qt5-qpa-hwcomposer-plugin g++ make libudev-dev qml-module-qtquick2 qml-module-qtquick-controls qml-module-qtwayland-compositor qml-module-qtquick-virtualkeyboard polkit-kde-agent-1 libqt5dbus5
cd ~
sudo git clone https://github.com/Cutie-Pi-Shell-community-project/atmospheres.git /usr/share/atmospheres
git clone https://github.com/Cutie-Pi-Shell-community-project/CutiePi-shell-phone-components.git
cd CutiePi-shell-phone-components 
sudo cp -R com.github.CutiePiShellCommunityProject.SettingsDaemon.conf /usr/share/dbus-1/system.d/com.github.CutiePiShellCommunityProject.SettingsDaemon.conf
mkdir -p /etc/systemd/logind.conf.d
sudo cp -R logind.conf.d/10-cutie.conf /etc/systemd/logind.conf.d/10-cutie.conf
cd settings-daemon
qmake
make
sudo make install
sudo cp settings-daemon/cutie-settings-daemon.service /usr/lib/systemd/system/cutie-settings-daemon.service
cd ..
qmake
make
sudo make install
sudo cp cutie-ui-io.service /usr/lib/systemd/system/cutie-ui-io.service
sudo systemctl daemon-reload
sudo systemctl disable phosh
sudo systemctl enable cutie-settings-daemon
sudo systemctl enable cutie-ui-io
sudo reboot
```

### To fix isues on scaling

```
sudo nano /usr/lib/systemd/system/cutie-ui-io.service

There is this line in the service file: Environment=QT_SCALE_FACTOR= "4". By default, the scale is 4, but if you have it too large, you can make it less (for example 2).

ctrl x
y
enter
```

# Status
https://github.com/Cutie-Pi-Shell-community-project/development-status
