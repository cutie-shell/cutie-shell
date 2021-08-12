import QtQuick 2.14
import QtQuick.Window 2.2
import QtWayland.Compositor 1.14
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtSensors 5.11
//import Process 1.0

WaylandOutput {
    id: compositor
    property variant formatDateTimeString: "HH:mm"
    property variant batteryPercentage: "56"
    property variant simPercentage: "27"
    property variant queue: []
    property bool screenLocked: false
    property bool batteryCharging: false

    property real pitch: 0.0
    property real roll: 0.0
    readonly property double radians_to_degrees: 180 / Math.PI
    property variant orientation: 0
    property variant sensorEnabled: true 

    property int drawerMargin: 5*shellScaleFactor

    function handleShellSurface(shellSurface, toplevel) {
        shellSurfaces.insert(0, {shellSurface: shellSurface});
        toplevel.sendConfigure(Qt.size(view.width, view.height - 20 * shellScaleFactor), [ XdgToplevel.NoneEdge ]);
    }

    onScreenLockedChanged: {
        if (screenLocked) {
            //process.start("raspi-gpio", ["set", "12", "dl"]); for rpi/cutiePi-Tablet
            root.state = "locked";
            lockscreen.lockscreenMosueArea.enabled = false; //for halium9 android devices
        } else {
            //process.start("raspi-gpio", ["set", "12", "dh"]); for rpi/cutiePi-Tablet
            lockscreen.lockscreenMosueArea.enabled = true; //for halium9 android devices
        }
    }

    Item {
        id: root
        state: "homeScreen" 
        states: [
            State{
                name: "homeScreen"
                PropertyChanges { target: settingSheet; y: -view.height }
                PropertyChanges { target: homeScreen; opacity: 1 }
                PropertyChanges { target: appScreen; opacity: 0 }
            },
            State {
                name: "appScreen"
                PropertyChanges { target: settingSheet; y: -view.height }
                PropertyChanges { target: homeScreen; opacity: 0 }
                PropertyChanges { target: appScreen; opacity: 1 }
            }
        ]

        transitions: [
           Transition {
                to: "*"
                NumberAnimation { target: settingSheet; properties: "y"; duration: 400; easing.type: Easing.InOutQuad; }
                NumberAnimation { target: homeScreen; properties: "opacity"; duration: 200; easing.type: Easing.InOutQuad; }
                NumberAnimation { target: appScreen; properties: "opacity"; duration: 200; easing.type: Easing.InOutQuad; }
           }

        ]
    }

    Item {
        id: settingsState
        state: "normal" 
        states: [
            State {
                name: "opened"
                PropertyChanges { target: settingSheet; y: 0 }
                PropertyChanges { target: setting; opacity: 1 }
            },
            State {
                name: "closed"
                PropertyChanges { target: settingSheet; y: -view.height }
                PropertyChanges { target: setting; opacity: 1 }
            },
            State {
                name: "opening"
                PropertyChanges { target: settingSheet; y: -view.height }
                PropertyChanges { target: setting; opacity: 0 }
            },
            State {
                name: "closing"
                PropertyChanges { target: settingSheet; y: 0 }
                PropertyChanges { target: setting; opacity: 0 }
            }
        ]

        transitions: [
           Transition {
                to: "*"
                NumberAnimation { target: settingSheet; properties: "y"; duration: 400; easing.type: Easing.InOutQuad; }
                NumberAnimation { target: setting; properties: "opacity"; duration: 300; easing.type: Easing.InOutQuad; }
           }
        ]
    }

    sizeFollowsWindow: true
    window: Window {
        visible: true
        width: 222 * shellScaleFactor
        height: 370 * shellScaleFactor
        Rectangle {
            id: view 
            color: "#2E3440"
            anchors.fill: parent
            //rotation: orientation

            Rectangle { anchors.fill: parent; color: '#2E3440' }

           // Process { id: process }

            //Component {
              //  id: procComponent
                //Process {}
            //}

            FontLoader {
                id: icon
                source: "qrc:/fonts/Font Awesome 5 Free-Solid-900.otf"
            }

            Rectangle {
                id: content 
                anchors.fill: parent

                Image {
                    z: 100
                    id: wallpaper
                    anchors.fill: parent
                    source: "file://usr/share/atmospheres/Current/wallpaper.jpg"
                    fillMode: Image.PreserveAspectCrop
                }

                AppScreen { id: appScreen }
                HomeScreen { id: homeScreen }

                SettingSheet { id: settingSheet } 
                StatusArea { id: setting }
            }

            LockScreen { id: lockscreen }

            Loader {
                anchors.fill: parent
                source: "Keyboard.qml"
            }
        }
    }
}
