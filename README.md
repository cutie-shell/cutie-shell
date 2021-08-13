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

1)Please installing droidian phosh and devtools on your device.                                                                 
2)Connected device to pc linux via rndis ssh.     ssh droidian@10.15.19.82                                                        
```
sudo apt update && sudo apt install git qtcreator qml qtbase5-gles-dev qt5-qpa-hwcomposer-plugin g++ make libudev-dev qml-module-qtquick2 qml-module-qtquick-controls
cd /usr/share/
sudo git clone https://github.com/Cutie-Pi-Shell-community-project/atmospheres.git
sudo git clone https://github.com/Cutie-Pi-Shell-community-project/CutiePi-shell-phone-components.git
cd CutiePi-shell-phone-components 
sudo cp -R com.github.CutiePiShellCommunityProject.SettingsDaemon.conf /usr/share/dbus-1/system.d/com.github.CutiePiShellCommunityProject.SettingsDaemon.conf
cd /etc/systemd
mkdir logind.conf.d
cd /usr/share/CutiePi-shell-phone-components/
sudo cp -R logind.conf.d/10-cutie.conf /etc/systemd/logind.conf.d/10-cutie.conf
sudo reboot
```
Please connected to device.   ssh droidian@10.15.19.82

```
sudo systemctl stop phosh
cd settings-daemon
qmake
make
sudo ./cutie-settings-daemon
cd ..
qmake
make
sh start-halium.sh
```

Fix isues scale shell:
```
nano start-halium.sh

There is a line in the script (export QT_SCALE_FACTOR= "4"). By default, the scale is 4, but if you have too large, you can make it less than 2.

ctrl x
y
enter
```

