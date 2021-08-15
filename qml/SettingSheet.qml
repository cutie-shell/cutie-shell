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

    property bool isPoweroffPressed: false

    onOpacityChanged: {
        isPoweroffPressed = false;
    }

    onIsPoweroffPressedChanged: {
        for (let i = 0; i < settingsModel.count; i++) {
            let btn = settingsModel.get(i)
            if (btn.bText == "Power Off") {
                if (isPoweroffPressed) {
                    btn.tText = "Tap Again";
                } else {
                    btn.tText = "";
                }
            }
        }
    }

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
                    settingSheet.opacity = 1/2 + parent.y / view.height / 2
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


            ListModel {
                id: settingsModel

                ListElement {
                    bText: "Wi-Fi"
                    tText: ""
                    icon: "icons/network-wireless-signal-good-symbolic.svg"
                }
                ListElement {
                    bText: "Cellular"
                    tText: ""
                    icon: "icons/network-cellular-signal-ok.svg"
                }
                ListElement {
                    bText: "Airplane"
                    tText: ""
                    icon: "icons/airplane-mode.svg"
                }
                ListElement {
                    bText: "-1 °C"
                    tText: "Snow"
                    icon: "icons/weather/graphic-weather-n322-light.png"
                }
                ListElement {
                    bText: "Power Off"
                    tText: ""
                    icon: "icons/system-shutdown-symbolic.svg"
                    clickHandler: function (self) {
                        if (isPoweroffPressed) {
                            settings.execApp("systemctl poweroff");
                        }
                        isPoweroffPressed = !isPoweroffPressed
                    }
                }
            }

            GridView {
                anchors.fill: parent
                anchors.topMargin: 135 * shellScaleFactor
                anchors.bottomMargin: 40 * shellScaleFactor
                model: settingsModel
                cellWidth: view.width / 3 - 5 * shellScaleFactor
                cellHeight: view.width / 3 - 5 * shellScaleFactor
                clip: true

                delegate: Item {
                    width: view.width / 3 - 15 * shellScaleFactor
                    height: view.width / 3 - 15 * shellScaleFactor
                    Rectangle {
                        id: settingBg
                        width: view.width / 3 - 10 * shellScaleFactor
                        height: view.width / 3 - 10 * shellScaleFactor
                        x: 10 * shellScaleFactor
                        color: (atmosphereVariant == "dark") ? "#2fffffff" : "#4f000000"
                        radius: 10 * shellScaleFactor

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 7 * shellScaleFactor
                            color: "#ffffff"
                            text: tText
                            font.pixelSize: 9 * shellScaleFactor
                            horizontalAlignment: Text.AlignHCenter
                            font.family: mainFont.name
                            font.bold: false
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 7 * shellScaleFactor
                            color: "#ffffff"
                            text: bText
                            font.pixelSize: 9 * shellScaleFactor
                            horizontalAlignment: Text.AlignHCenter
                            font.family: mainFont.name
                            font.bold: false
                        }
                        
                        Image {
                            anchors.fill: parent
                            anchors.margins: parent.width / 3
                            source: icon
                            sourceSize.height: 128
                            sourceSize.width: 128
                            fillMode: Image.PreserveAspectFit
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: clickHandler(this)
                        }
                    }
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
                            let maxB = settings.GetMaxBrightness();
                            settings.SetBrightness(maxB / 6 + maxB * vol / 120);
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
