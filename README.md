![alt text](https://github.com/cutie-shell/cutie-shell/blob/qtwayland-phone-tablet/icons/cutie.png)                          
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
Status: Beta project OTA-1.0.24                                                                                                                                   
Tested on: Volla Phone, Xiaomi Redmi 7, OnePlus 6t                                                                                         
                      
                                           
                                        
## Auto Bash script
* Install droidian phosh and devtools on your device.  
* Connected the device to a PC running Linux: `ssh droidian@10.15.19.82`  

```
wget -O - https://raw.githubusercontent.com/Cutie-Pi-Shell-community-project/cutie-shell/qtwayland-phone-tablet/install.sh | bash
```


### Manual building
* Install droidian phosh and devtools on your device.  
* Connected the device to a PC running Linux: `ssh droidian@10.15.19.82`    

```
sudo apt update && sudo apt install git qtdeclarative5-dev qdbus qtcreator qml qtbase5-gles-dev qt5-qpa-hwcomposer-plugin g++ make libudev-dev qml-module-qtquick2 qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtsensors qml-module-qtwayland-compositor qml-module-qtquick-virtualkeyboard polkit-kde-agent-1 libqt5dbus5
cd ~
sudo git clone https://github.com/Cutie-Pi-Shell-community-project/atmospheres.git /usr/share/atmospheres
git clone https://github.com/Cutie-Pi-Shell-community-project/CutiePi-shell-phone-components.git
git clone https://github.com/Cutie-Pi-Shell-community-project/cutie-settings-daemon.git
git clone https://github.com/Cutie-Pi-Shell-community-project/qml-module-cutie.

cd cutie-settings-daemon
qmake
make 
sudo make install
cd ../qml-module-cutie
qmake
make
sudo make install
cd ../CutiePi-shell-phone-components
mkdir -p /etc/systemd/logind.conf.d
sudo cp -R logind.conf.d/10-cutie.conf /etc/systemd/logind.conf.d/10-cutie.conf

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
* Connected the device to a PC running Linux: `ssh droidian@10.15.19.82` 

```
sudo nano /usr/lib/systemd/system/cutie-ui-io.service

There is this line in the service file: Environment=QT_SCALE_FACTOR= "4". By default, the scale is 4 like vollaPhone display 1080x2340, but if you have it too large, you can make it less (for example 2 like Redmi 7 display 720x1520).

ctrl x
y
enter
```

## Status

https://github.com/Cutie-Pi-Shell-community-project/development-status
