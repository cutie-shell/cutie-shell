import QtQuick 2.14
import QtQuick.Window 2.2
import QtWayland.Compositor 1.14
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtSensors 5.11
import Process 1.0
//import MeeGo.Connman 0.2 

WaylandOutput {
    id: compositor
    property variant formatDateTimeString: "HH:mm"
    property variant batteryPercentage: "56"
    property variant simPercentage: "27"
    property variant queue: []
    property bool screenLocked: false
    property bool batteryCharging: false
    //property variant wallpaperUrl: ":/wallpaper.jpg"

    property real pitch: 0.0
    property real roll: 0.0
    readonly property double radians_to_degrees: 180 / Math.PI
    property variant orientation: 0
    property variant sensorEnabled: true 

    property int drawerMargin: 5*shellScaleFactor

    function handleShellSurface(shellSurface, toplevel) {
        shellSurfaces.insert(0, {shellSurface: shellSurface});
        toplevel.sendConfigure(Qt.size(view.width, view.height), [ XdgToplevel.NoneEdge ]);
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
        state: "normal" 
        states: [
            State {
                name: "setting"
                PropertyChanges { target: sidebar; x: -view.width }
                PropertyChanges { target: settingSheet; y: 0 }
            },
            State { name: "locked" }, 
            State { name: "popup" }, 
            State { name: "parked" },
            State{
                name: "drawer"
                PropertyChanges { target: sidebar; x: 0 }
                PropertyChanges { target: settingSheet; y: -view.height }
            },
            State {
                name: "normal"
                PropertyChanges { target: settingSheet; y: -view.height }
                PropertyChanges { target: sidebar; x: -view.width }
            }

       ]

        transitions: [
           Transition {
                to: "*"
                NumberAnimation { target: settingSheet; properties: "y"; duration: 400; easing.type: Easing.InOutQuad; }
                NumberAnimation { target: sidebar; properties: "x"; duration: 400; easing.type: Easing.InOutQuad; }
           }



        ]



    }

    sizeFollowsWindow: true
    window: Window {
        visible: true
        Rectangle {
            id: view 
            color: "#2E3440"
            anchors.fill: parent
          //  rotation: orientation

            Rectangle { anchors.fill: parent; color: '#2E3440' }

            Process { id: process }
                        Component {
                            id: procComponent
                            Process {}
                        }







            FontLoader {
                id: icon
                source: "qrc:/fonts/Font Awesome 5 Free-Solid-900.otf"
            }

            Rectangle {
                id: content 
                anchors.fill: parent 



                /*MouseArea { 
                    id: overlayMouseArea 
                    anchors.fill: parent 
                    z: 3
                    enabled: (root.state == "setting" || root.state == "popup" || root.state == "drawer" )
                    onClicked: { 
                        if ( root.state == "setting" || root.state == "drawer") 
                            root.state = "normal"
                    }
                }*/



                SideBarSwipe { id: sideBarSwipe }
                SideBar { id: sidebar }

                SettingSheet { id: settingSheet } 
                StatusArea { id: setting }

                Repeater {
                    anchors.fill: parent
                    //anchors { top: naviBar.bottom; left: parent.left; bottom: parent.bottom; right: parent.right }
                    model: shellSurfaces
                    delegate: WaylandChrome {}
                }
            }

            LockScreen { id: lockscreen }





            Loader {
                anchors.fill: parent
                source: "Keyboard.qml"
            }
        }

















































    }
}
