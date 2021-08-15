import QtQuick 2.14
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0

// setting sheet 
Rectangle {
    id: settingSheet
    width: view.width
    height: view.height
    z: 350
    opacity: 0
    color: "transparent"
    y: -view.height

    function setSettingContainerY(y) {
        settingContainer.y = y;
    }

    function setSettingContainerState(state) {
        settingContainer.state = state;
    }

    Item {
        x: 0
        y: parent.height - 5 * shellScaleFactor
        height: 5 * shellScaleFactor
        width: parent.width
        z: 100

        MouseArea { 
            enabled: settingsState.state != "closed"
            drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: - 5 * shellScaleFactor; drag.maximumY: view.height - 5 * shellScaleFactor
            anchors.fill: parent
            z: 425

            onReleased: {
                if (parent.y > view.height / 2) { 
                    settingsState.state = "opened"
                    settingContainer.state = "opened"
                }
                else { 
                    settingsState.state = "closed"
                    settingContainer.state = "closed"
                }
                parent.y = parent.parent.height - 5 * shellScaleFactor
            }

            onPressed: {
                settingsState.state = "closing";
                settingContainer.state = "closing";
                settingContainer.y = 0;
            }

            onPositionChanged: {
                if (drag.active) {
                    settingSheet.opacity = parent.y / view.height / 2
                    settingContainer.y = parent.y - view.height
                }
            }
        }
    }

    FastBlur {
        anchors.fill: parent
        source: realWallpaper
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        radius: 90

        Rectangle {
            anchors.fill: parent
            color: (atmosphereVariant == "dark") ? "#80000000" : "#80ffffff"
        }

        Item {
            id: settingContainer
            y: /*-view.height*/0
            height: parent.height
            width: parent.width

            state: "closed"

            states: [
                State {
                    name: "opened"
                    PropertyChanges { target: settingContainer; y: 0 }
                },
                State {
                    name: "closed"
                    PropertyChanges { target: settingContainer; y: -view.height }
                },
                State {
                    name: "opening"
                    PropertyChanges { target: settingContainer; y: -view.height }
                },
                State {
                    name: "closing"
                    PropertyChanges { target: settingContainer; y: 0 }
                }
            ]

            transitions: Transition {
                to: "*"
                NumberAnimation { target: settingContainer; properties: "y"; duration: 300; easing.type: Easing.InOutQuad; }
           }

            Text {
                id: text2
                x: 25  * shellScaleFactor
                y: 25  * shellScaleFactor
                color: (atmosphereVariant == "dark") ? "#ffffff" : "#000000"
                text: qsTr("Accent")
                font.pixelSize: 14 * shellScaleFactor
                font.family: mainFont.name
                font.weight: Font.Black
                state: atmosphereVariant
                states: [
                    State {
                        name: "dark"
                        PropertyChanges { target: text2; color: "#ffffff" }
                    },
                    State {
                        name: "light"
                        PropertyChanges { target: text2; color: "#000000" }
                    }
                ]
                transitions: Transition {
                    ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                }
            }

            //Armospheres ui block
            ListModel {
                id: atmospheresModel
                ListElement {
                    name: "City"
                    variant: "dark"
                    path: "file://usr/share/atmospheres/city/"
                }
                ListElement {
                    name: "Aurora"
                    variant: "dark"
                    path: "file://usr/share/atmospheres/aurora/"
                }
                ListElement {
                    name: "Night"
                    variant: "dark"
                    path: "file://usr/share/atmospheres/night/"
                }
                ListElement {
                    name: "Air"
                    variant: "light"
                    path: "file://usr/share/atmospheres/air/"
                }
                ListElement {
                    name: "Airy"
                    variant: "light"
                    path: "file://usr/share/atmospheres/airy/"
                }
            }

            ListView {
                x: 25 * shellScaleFactor
                y: 55 * shellScaleFactor
                width: view.width - 50 * shellScaleFactor
                height: 60 * shellScaleFactor
                model: atmospheresModel
                orientation: Qt.Horizontal
                clip: true
                spacing: 15 * shellScaleFactor
                delegate: Image {
                    width: 60 * shellScaleFactor
                    height: 60 * shellScaleFactor
                    source: path + "wallpaper.jpg"
                    fillMode: Image.PreserveAspectFit

                    Text {
                        anchors.centerIn: parent
                        text: name
                        font.pixelSize: 9 * shellScaleFactor
                        font.bold: false
                        color: (variant == "dark") ? "#FFFFFF" : "#000000"
                        font.family: mainFont.name
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked:{
                            atmosphereVariant = variant
                            nextWallpaper.state = "changing"
                            atmospherePath = path
                            nextWallpaper.state = "normal"
                            atmosphereTimer.start();
                        }
                    }

                    Timer {
                        id: atmosphereTimer
                        interval: 500
                        repeat: false
                        onTriggered: {
                            nextAtmospherePath = atmospherePath;
                        }
                    }
                }
            }
            //End atmospheres


            Rectangle {
                id: rectangle
                x: 25 * shellScaleFactor
                y: 135 * shellScaleFactor
                width: view.width / 2 - 37 * shellScaleFactor
                height: view.width / 2 - 37 * shellScaleFactor
                color: (atmosphereVariant == "dark") ? "#2fffffff" : "#4f000000"
                radius: 10 * shellScaleFactor

                Text {
                    id: text3
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 7 * shellScaleFactor
                    color: "#ffffff"
                    text: qsTr("Wi-Fi")
                    font.pixelSize: 9 * shellScaleFactor
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: false
                    font.family: mainFont.name
                }

                Image {
                    id: image4
                    anchors.fill: parent
                    anchors.margins: parent.width / 3
                    source: "icons/network-wireless-signal-good-symbolic.svg"
                    sourceSize.height: 128
                    sourceSize.width: 128
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                id: rectangle1
                x: view.width / 2 + 12 * shellScaleFactor
                y: 135 * shellScaleFactor
                width: view.width / 2 - 37 * shellScaleFactor
                height: view.width / 2 - 37 * shellScaleFactor
                color: (atmosphereVariant == "dark") ? "#2fffffff" : "#4f000000"
                radius: 10 * shellScaleFactor

                Text {
                    id: text4
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 7 * shellScaleFactor
                    color: "#ffffff"
                    text: qsTr("Modem")
                    font.pixelSize: 9 * shellScaleFactor
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: false
                    font.family: mainFont.name
                }

                Image {
                    id: image5
                    anchors.fill: parent
                    anchors.margins: parent.width / 3
                    source: "icons/network-cellular-signal-ok.svg"
                    sourceSize.height: 128
                    sourceSize.width: 128
                    fillMode: Image.PreserveAspectFit
                }
            }

            
            Rectangle {
                id: rectangle2
                x: 25 * shellScaleFactor
                y: 120 * shellScaleFactor + view.width / 2
                width: view.width / 2 - 37 * shellScaleFactor
                height: view.width / 2 - 37 * shellScaleFactor
                color: (atmosphereVariant == "dark") ? "#2fffffff" : "#4f000000"
                radius: 10 * shellScaleFactor

                Text {
                    id: text7
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 7 * shellScaleFactor
                    color: "#ffffff"
                    text: qsTr("Airplane Mode")
                    font.pixelSize: 9 * shellScaleFactor
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: false
                    font.family: mainFont.name
                }
                
                Image {
                    id: image6
                    anchors.fill: parent
                    anchors.margins: parent.width / 3
                    source: "icons/airplane-mode.svg"
                    sourceSize.height: 128
                    sourceSize.width: 128
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                id: rectangle3
                x: view.width / 2 + 12 * shellScaleFactor
                y: 120 * shellScaleFactor + view.width / 2
                width: view.width / 2 - 37 * shellScaleFactor
                height: view.width / 2 - 37 * shellScaleFactor
                color: (atmosphereVariant == "dark") ? "#2fffffff" : "#4f000000"
                radius: 10 * shellScaleFactor

                Text {
                    id: text5
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 7 * shellScaleFactor
                    color: "#ffffff"
                    text: qsTr("Snow")
                    font.pixelSize: 9 * shellScaleFactor
                    horizontalAlignment: Text.AlignHCenter
                    font.family: mainFont.name
                    font.bold: false
                }

                Text {
                    id: text6
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 7 * shellScaleFactor
                    color: "#ffffff"
                    text: qsTr("-1")
                    font.pixelSize: 9 * shellScaleFactor
                    horizontalAlignment: Text.AlignHCenter
                    font.family: mainFont.name
                    font.bold: false
                }
                
                Image {
                    id: image7
                    anchors.fill: parent
                    anchors.margins: parent.width / 3
                    source: "icons/weather/graphic-weather-n322-light.png"
                    sourceSize.height: 128
                    sourceSize.width: 128
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                id: brightness
                width: parent.width - 10 * shellScaleFactor
                height: 25 * shellScaleFactor
                color: "#00000000"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 10 * shellScaleFactor

                Rectangle
                {
                    id: maskRect1
                    width: parent.height
                    height: width
                    visible: false
                    state: atmosphereVariant
                    states: [
                        State {
                            name: "dark"
                            PropertyChanges { target: maskRect1; color: "#ffffff" }
                        },
                        State {
                            name: "light"
                            PropertyChanges { target: maskRect1; color: "#000000" }
                        }
                    ]
                    transitions: Transition {
                        ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                    }
                }

                Image {
                    id: volumeMuted1
                    width: parent.height
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    source: "icons/gpm-brightness-lcd-disabled.svg"
                    anchors.leftMargin: 5 * shellScaleFactor
                    sourceSize.height: height*2
                    sourceSize.width: width*2
                    visible: false
                }

                OpacityMask {
                    anchors.fill: volumeMuted1
                    source: maskRect1
                    maskSource: volumeMuted1
                }

                Image {
                    id: volumeHigh1
                    width: parent.height
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    source: "icons/gpm-brightness-lcd"
                    anchors.rightMargin: 5 * shellScaleFactor
                    sourceSize.height: height*2
                    sourceSize.width: width*2
                    visible: false
                }

                OpacityMask {
                    anchors.fill: volumeHigh1
                    source: maskRect1
                    maskSource: volumeHigh1
                }

                Rectangle {
                    id: volumeBarTrack1
                    height: shellScaleFactor
                    radius: 1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: volumeMuted1.right
                    anchors.right: volumeHigh1.left
                    anchors.rightMargin: 5 * shellScaleFactor
                    anchors.leftMargin: 5 * shellScaleFactor
                    state: atmosphereVariant
                    states: [
                        State {
                            name: "dark"
                            PropertyChanges { target: volumeBarTrack1; color: "#ffffff" }
                        },
                        State {
                            name: "light"
                            PropertyChanges { target: volumeBarTrack1; color: "#444444" }
                        }
                    ]
                    transitions: Transition {
                        ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                    }
                }

                Rectangle {
                    id: volumeBarThumb1
                    x: volumeBarTrack1.x + volumeBarTrack1.width/2
                    y: volumeBarTrack1.y - height/2
                    width: parent.height
                    height: width
                    radius: width / 2
                    MouseArea {
                        anchors.fill: parent
                        drag.axis: Drag.XAxis
                        drag.maximumX: volumeBarTrack1.x - width + volumeBarTrack1.width
                        drag.target: volumeBarThumb1
                        drag.minimumX: volumeBarTrack1.x
                    }
                    onXChanged: {
                        var fullrange = volumeBarTrack1.width - volumeBarThumb1.width;
                        var vol = 100*(volumeBarThumb1.x - volumeBarTrack1.x)/fullrange;
                        if (screenLockState.state != "closed") {
                            settings.SetBrightness(settings.GetMaxBrightness() * vol / 100);
                        } 
                    }
                    state: atmosphereVariant
                    states: [
                        State {
                            name: "dark"
                            PropertyChanges { target: volumeBarThumb1; color: "#ffffff" }
                        },
                        State {
                            name: "light"
                            PropertyChanges { target: volumeBarThumb1; color: "#444444" }
                        }
                    ]
                    transitions: Transition {
                        ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                    }
                }
            }
        }
    }
}
