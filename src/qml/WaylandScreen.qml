import QtQuick
import QtQuick.Window
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import QtSensors
import Cutie

WaylandOutput {
    id: compositor
    property variant formatDateTimeString: "HH:mm"
    property variant batteryPercentage: "56"
    property variant simPercentage: "27"
    property variant queue: []
    property bool batteryCharging: false

    property real pitch: 0.0
    property real roll: 0.0
    readonly property double radians_to_degrees: 180 / Math.PI
    property variant orientation: 0
    property variant sensorEnabled: true 

    property real unlockBrightness: 0.5

    property int drawerMargin: 5
    property string nextAtmospherePath: "/usr/share/atmospheres/city/"
    property color atmosphereForeground: "#ffffff"

    property XdgSurface keyboard: null

    function handleShellSurface(shellSurface) {
        shellSurfaces.append({shellSurface: shellSurface});
    }

    function lock() {
        if (screenLockState.state == "closed") {
            openBl.start();
        } else {
            unlockBrightness = settings.GetBrightness() / settings.GetMaxBrightness();
            closeBl.start();
        }
    }

    scaleFactor: shellScaleFactor

    NumberAnimation { 
        id: closeBl
        target: settings
        property: "brightness"
        to: 0 
        duration: 200

        onFinished: {
            screenLockState.state = "closed";
        }
    }

    NumberAnimation { 
        id: openBl
        target: settings
        property: "brightness"
        to: settings.GetMaxBrightness() * unlockBrightness
        duration: 200

        onFinished: {
            screenLockState.state = "locked";
        }
    }   

    Item {
        id: root
        property string oldState: "homeScreen"
        property string tmpState: "homeScreen"

        onStateChanged: {
            oldState = tmpState;
            tmpState = state;
        }

        state: "homeScreen" 
        states: [
            State{
                name: "homeScreen"
                PropertyChanges { target: wallpaperBlur; opacity: 0 }
                PropertyChanges { target: homeScreen; opacity: 1 }
                PropertyChanges { target: appScreen; opacity: 0 }
                PropertyChanges { target: notificationScreen; opacity: 0 }
                PropertyChanges { target: mainViewContainer; opacity: 1 }
            },
            State {
                name: "appScreen"
                PropertyChanges { target: wallpaperBlur; opacity: 1 }
                PropertyChanges { target: homeScreen; opacity: 0 }
                PropertyChanges { target: appScreen; opacity: 1 }
                PropertyChanges { target: notificationScreen; opacity: 0 }
                PropertyChanges { target: mainViewContainer; opacity: 1 }
            },
            State {
                name: "notificationScreen"
                PropertyChanges { target: wallpaperBlur; opacity: 1 }
                PropertyChanges { target: homeScreen; opacity: 0 }
                PropertyChanges { target: appScreen; opacity: 0 }
                PropertyChanges { target: notificationScreen; opacity: 1 }
                PropertyChanges { target: mainViewContainer; opacity: 1 }
            }
        ]

        transitions: [
           Transition {
                to: "*"
                NumberAnimation { target: notificationScreen; properties: "opacity"; duration: 300; easing.type: Easing.InOutQuad; }
                NumberAnimation { target: homeScreen; properties: "opacity"; duration: 300; easing.type: Easing.InOutQuad; }
                NumberAnimation { target: appScreen; properties: "opacity"; duration: 300; easing.type: Easing.InOutQuad; }
           }

        ]
    }

    Item {
        id: screenLockState
        state: "locked" 
        states: [
            State{
                name: "closed"
                PropertyChanges { target: lockscreen; opacity: 1; y: 0 }
                PropertyChanges { target: shellContainer; visible: false; opacity: 0 }
            },
            State {
                name: "locked"
                PropertyChanges { target: lockscreen; opacity: 1; y: 0 }
                PropertyChanges { target: shellContainer; visible: true; opacity: 0 }
            },
            State {
                name: "opened"
                PropertyChanges { target: lockscreen; opacity: 0; y: -view.height }
                PropertyChanges { target: shellContainer; visible: true; opacity: 1 }
            }
        ]

        transitions: [
           Transition {
                to: "*"
                NumberAnimation { target: lockscreen; properties: "opacity"; duration: 200; easing.type: Easing.InOutQuad; }
           }

        ]
    }

    Item {
        id: launcherState
        state: "closed" 
        states: [
            State {
                name: "opened"
                PropertyChanges { target: launcherSheet; y: 0; opacity: 1 }
                PropertyChanges { target: mainViewContainer; opacity: 0 }
            },
            State {
                name: "closed"
                PropertyChanges { target: launcherSheet; y: view.height; opacity: 0 }
                PropertyChanges { target: mainViewContainer; opacity: 1 }
            },
            State {
                name: "opening"
                PropertyChanges { target: launcherSheet; y: 0 }
            },
            State {
                name: "closing"
                PropertyChanges { target: launcherSheet; y: 0 }
            }
        ]

        transitions: [
           Transition {
                to: "*"
                NumberAnimation { target: launcherSheet; properties: "opacity"; duration: 600; easing.type: Easing.InOutQuad; }
           }
        ]
    }

    Item {
        id: settingsState
        state: "closed" 
        states: [
            State {
                name: "opened"
                PropertyChanges { target: settingSheet; y: 0; opacity: 1 }
                PropertyChanges { target: setting; opacity: 1 }
                PropertyChanges { target: mainViewContainer; opacity: 0 }
            },
            State {
                name: "closed"
                PropertyChanges { target: settingSheet; y: -view.height; opacity: 0 }
                PropertyChanges { target: setting; opacity: 1 }
                PropertyChanges { target: mainViewContainer; opacity: 1 }
            },
            State {
                name: "opening"
                PropertyChanges { target: settingSheet; y: 0 }
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
                NumberAnimation { target: settingSheet; properties: "opacity"; duration: 800; easing.type: Easing.InOutQuad; }
           },
           Transition {
                to: "opening"
                ParallelAnimation {
                    NumberAnimation { target: setting; properties: "opacity"; duration: 800; easing.type: Easing.InOutQuad; }
                    SequentialAnimation {
                        NumberAnimation { target: setting; properties: "anchors.topMargin"; duration: 300; easing.type: Easing.InOutQuad; to: -20 }
                    }
                }
           },
           Transition {
                to: "closing"
                ParallelAnimation {
                    NumberAnimation { target: setting; properties: "opacity"; duration: 800; easing.type: Easing.InOutQuad; }
                    SequentialAnimation {
                        NumberAnimation { target: setting; properties: "anchors.topMargin"; duration: 300; easing.type: Easing.InOutQuad; to: -20 }
                    }
                }
           },
           Transition {
                to: "opened"
                ParallelAnimation {
                    NumberAnimation { target: setting; properties: "opacity"; duration: 800; easing.type: Easing.InOutQuad; }
                    SequentialAnimation {
                        NumberAnimation { target: setting; properties: "anchors.topMargin"; duration: 600; easing.type: Easing.InOutQuad; to: 0 }
                    }
                }
           },
           Transition {
                to: "closed"
                ParallelAnimation {
                    NumberAnimation { target: setting; properties: "opacity"; duration: 800; easing.type: Easing.InOutQuad; }
                    SequentialAnimation {
                        NumberAnimation { target: setting; properties: "anchors.topMargin"; duration: 600; easing.type: Easing.InOutQuad; to: 0 }
                    }
                }
           }
        ]
    }

    sizeFollowsWindow: true
    window: Window {
        visible: true
        width: 540
        height: 1150
        Item {
            id: view
            anchors.fill: parent

            Item {
                id: content 
                anchors.fill: parent

                Item {
                    id: realWallpaper
                    anchors.fill: parent
                    Image {
                        id: wallpaper
                        anchors.fill: parent
                        source: "file:/" + atmospherePath + "/wallpaper.jpg"
                        fillMode: Image.PreserveAspectCrop
                    }

                    Image {
                        id: nextWallpaper
                        anchors.fill: parent
                        source: "file:/" + nextAtmospherePath + "/wallpaper.jpg"
                        fillMode: Image.PreserveAspectCrop
                        opacity: 0
                        state: "normal"
                        states: [
                            State {
                                name: "changing"
                                PropertyChanges { target: nextWallpaper; opacity: 1 }
                            },
                            State {
                                name: "normal"
                                PropertyChanges { target: nextWallpaper; opacity: 0 }
                            }
                        ]

                        transitions: Transition {
                            to: "normal"

                            NumberAnimation {
                                target: nextWallpaper
                                properties: "opacity"
                                easing.type: Easing.InOutQuad
                                duration: 500
                            }
                        }
                    }
                }

                Item {
                    id: shellContainer
                    anchors.fill: parent

                    Behavior on opacity {
                        PropertyAnimation { duration: 300 }
                    }

                    FastBlur {
                        id: wallpaperBlur
                        anchors.fill: parent
                        source: realWallpaper
                        radius: 70

                        Behavior on opacity {
                            PropertyAnimation { duration: 300 }
                        }
                    }

                    Rectangle {
                        color: Atmosphere.secondaryAlphaColor
                        anchors.fill: wallpaperBlur
                        opacity: wallpaperBlur.opacity / 3
                    }

                    Item {
                        id: mainViewContainer
                        anchors.fill: parent

                        Behavior on opacity {
                            PropertyAnimation { duration: 300 }
                        }

                        HomeScreen { id: homeScreen }
                        NotificationScreen { id: notificationScreen }
                        AppScreen { id: appScreen }

                        ScreenSwipe { id: screenSwipe }
                    }

                    SettingSheet { id: settingSheet } 
                    StatusArea { id: setting }

                    LauncherSheet { id: launcherSheet } 
                    LauncherSwipe { id: lSwipe }
                }

                LockScreen { id: lockscreen }
                Keyboard {}
            }
        }
    }
}
