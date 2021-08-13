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

## Building and Running

Firstly, copy `com.github.CutiePiShellCommunityProject.SettingsDaemon.conf` over to `/usr/share/dbus-1/system.d/com.github.CutiePiShellCommunityProject.SettingsDaemon.conf` and `logind.conf.d/10-cutie.conf` to `/etc/systemd/logind.conf.d/10-cutie.conf`. You may have to create the `logind.conf.d` directory. After copying the files, you need to reboot your device.

Then, build the settings daemon and run it as root:

```
cd settings-daemon
qmake
make
sudo ./cutie-settings-daemon
```

After that, build the actual shell and run it as the normal user (in the root of this repo):

```
qmake
make
./start-halium.sh
```
