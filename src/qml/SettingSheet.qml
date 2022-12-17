import QtQuick 2.14
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0
Rectangle {
    id: settingSheet
    width: view.width
    height: view.height
    opacity: 0
    color: "transparent"
    y: -view.height

    property bool isPoweroffPressed: false
    property string weatherIcon: ""
    
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

    function addModem(n) {
        settingsModel.append({
            tText: "Cellular " + n.toString(),
            bText: "",
            icon: "icons/network-cellular-signal-none.svg"
        })
    }

    function setCellularName(n, name) {
        for (let i = 0; i < settingsModel.count; i++) {
            let btn = settingsModel.get(i)
            if (btn.tText == "Cellular " + n.toString()) {
                btn.bText = name
            }
        }
    }

    function setCellularStrength(n, strength) {
        for (let i = 0; i < settingsModel.count; i++) {
            let btn = settingsModel.get(i)
            if (btn.tText == "Cellular " + n.toString()) {
                if (strength > 80) {
                    btn.icon = "icons/network-cellular-signal-excellent.svg"
                } else if (strength > 50) {
                    btn.icon = "icons/network-cellular-signal-good.svg"
                } else if (strength > 30) {
                    btn.icon = "icons/network-cellular-signal-ok.svg"
                } else if (strength > 10) {
                    btn.icon = "icons/network-cellular-signal-low.svg"
                } else {
                    btn.icon = "icons/network-cellular-signal-none.svg"
                }
            }
        }
    }

    function setWifiName(name) {
        for (let i = 0; i < settingsModel.count; i++) {
            let btn = settingsModel.get(i)
            if (btn.tText == "WiFi") {
                btn.bText = name
            }
        }
    }
    function setWeather() {
        for (let i = 0; i < settingsModel.count; i++) {
            let btn = settingsModel.get(i)
            if (btn.tText == "No weather data") {
                btn.bText = (model.hasValidWeather
                             ? model.weather.temperature
                             : "??")
                btn.tText = (model.hasValidWeather
                             ? model.weather.weatherDescription
                             : "No weather data")
               weatherIcon= (model.hasValidWeather
                             ? model.weather.weatherIcon
                             : "01d")
                switch (weatherIcon) {
                case "01d":
                case "01n":
                  btn.icon =  "icons/weather-sunny.png"
                    break;
                case "02d":
                case "02n":
                  btn.icon =   "icons/weather-sunny-very-few-clouds.png"
                    break;
                case "03d":
                case "03n":
                   btn.icon =   "icons/weather-few-clouds.png"
                    break;
                case "04d":
                case "04n":
                  btn.icon =    "icons/weather-overcast.png"
                    break;
                case "09d":
                case "09n":
                  btn.icon =    "icons/weather-showers.png"
                    break;
                case "10d":
                case "10n":
                  btn.icon =   "icons/weather-showers.png"
                    break;
                case "11d":
                case "11n":
                   btn.icon =   "icons/weather-thundershower.png"
                    break;
                case "13d":
                case "13n":
                   btn.icon =   "icons/weather-snow.png"
                    break;
                case "50d":
                case "50n":
                 btn.icon =    "icons/weather-fog.png"
                    break;
                default:
                   btn.icon =   "icons/weather-unknown.png"
                }

            }
        }
    }

    function setWifiStrength(strength) {
        for (let i = 0; i < settingsModel.count; i++) {
            let btn = settingsModel.get(i)
            if (btn.tText == "WiFi") {
                if (strength > 80) {
                    btn.icon = "icons/network-wireless-signal-excellent-symbolic.svg"
                } else if (strength > 50) {
                    btn.icon = "icons/network-wireless-signal-good-symbolic.svg"
                } else if (strength > 30) {
                    btn.icon = "icons/network-wireless-signal-ok-symbolic.svg"
                } else if (strength > 10) {
                    btn.icon = "icons/network-wireless-signal-low-symbolic.svg"
                } else {
                    btn.icon = "icons/network-wireless-signal-none-symbolic.svg"
                }
            }
        }
    }

    Item {
        x: 0
        y: parent.height - 10 * shellScaleFactor
        height: 10 * shellScaleFactor
        width: parent.width
        
        MouseArea {
            drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: - 10 * shellScaleFactor; drag.maximumY: view.height - 10 * shellScaleFactor
            enabled: settingsState.state != "closed"
            anchors.fill: parent
            propagateComposedEvents: true

            onPressed: {
                settingsState.state = "closing";
                settingContainer.state = "closing";
                settingContainer.y = 0;
            }

            onReleased: {
                if (parent.y < view.height - 2 * parent.height) {
                    settingsState.state = "closed"
                    settingContainer.state = "closed"
                }
                else {
                    settingsState.state = "opened"
                    settingContainer.state = "opened"
                }
                parent.y = parent.parent.height - 10 * shellScaleFactor
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

            Rectangle {
                height: 160 * shellScaleFactor
                color: (atmosphereVariant == "dark") ? "#2fffffff" : "#4f000000"
                radius: 10 * shellScaleFactor
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 20 * shellScaleFactor
                anchors.leftMargin: 20 * shellScaleFactor
                y: 35 * shellScaleFactor
                clip: true

                Text {
                    id: text2
                    x: 20  * shellScaleFactor
                    y: 20  * shellScaleFactor
                    text: qsTr("Atmosphere")
                    font.pixelSize: 24 * shellScaleFactor
                    font.family: "Lato"
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

                ListView {
                    anchors.fill: parent
                    anchors.topMargin: 64 * shellScaleFactor
                    model: atmospheresModel
                    orientation: Qt.Horizontal
                    clip: false
                    spacing: -20 * shellScaleFactor
                    delegate: Item {
                        width: 100 * shellScaleFactor
                        height: 100 * shellScaleFactor
                        Image {
                            x: 20 * shellScaleFactor
                            width: 60 * shellScaleFactor
                            height: 80 * shellScaleFactor
                            source: path + "wallpaper.jpg"
                            fillMode: Image.PreserveAspectCrop

                            Text {
                                anchors.centerIn: parent
                                text: name
                                font.pixelSize: 14 * shellScaleFactor
                                font.bold: false
                                color: (variant == "dark") ? "#FFFFFF" : "#000000"
                                font.family: "Lato"
                            }

                            MouseArea{
                                anchors.fill: parent
                                onClicked:{
                                    settings.setAtmosphereVariant(variant);
                                    nextWallpaper.state = "changing"
                                    settings.setAtmospherePath(path);
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
                }
            }


            ListModel {
                id: settingsModel

                ListElement {
                    bText: ""
                    tText: "Power Off"
                    icon: "icons/system-shutdown-symbolic.svg"
                    clickHandler: function (self) {
                        if (isPoweroffPressed) {
                            settings.execApp("systemctl poweroff");
                        }
                        isPoweroffPressed = !isPoweroffPressed
                    }
                }

                ListElement {
                    bText: ""
                    tText: "WiFi"
                    icon: "icons/network-wireless-signal-none-symbolic.svg"
                }

            }

            GridView {
                id: widgetGrid
                anchors.fill: parent
                anchors.topMargin: 215 * shellScaleFactor
                anchors.bottomMargin: 100 * shellScaleFactor
                anchors.leftMargin: 20 * shellScaleFactor
                model: settingsModel
                cellWidth: width / 3
                cellHeight: width / 3
                clip: true

                delegate: Item {
                    width: widgetGrid.cellWidth
                    height: widgetGrid.cellWidth
                    Rectangle {
                        id: settingBg
                        width: parent.width - 20 * shellScaleFactor
                        height: parent.width - 20 * shellScaleFactor
                        color: (atmosphereVariant == "dark") ? "#2fffffff" : "#4f000000"
                        radius: 10 * shellScaleFactor

                        Text {
                            id: topText
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 14 * shellScaleFactor
                            text: tText
                            font.pixelSize: 12 * shellScaleFactor
                            horizontalAlignment: Text.AlignHCenter
                            font.family: "Lato"
                            font.bold: false
                            state: atmosphereVariant
                            states: [
                                State {
                                    name: "dark"
                                    PropertyChanges { target: topText; color: "#ffffff" }
                                },
                                State {
                                    name: "light"
                                    PropertyChanges { target: topText; color: "#000000" }
                                }
                            ]
                            transitions: Transition {
                                ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                            }
                        }

                        Text {
                            id: bottomText
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 14 * shellScaleFactor
                            text: bText
                            font.pixelSize: 12 * shellScaleFactor
                            horizontalAlignment: Text.AlignHCenter
                            font.family: "Lato"
                            font.bold: false
                            state: atmosphereVariant
                            states: [
                                State {
                                    name: "dark"
                                    PropertyChanges { target: bottomText; color: "#ffffff" }
                                },
                                State {
                                    name: "light"
                                    PropertyChanges { target: bottomText; color: "#000000" }
                                }
                            ]
                            transitions: Transition {
                                ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                            }
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
                height: 40 * shellScaleFactor
                color: "#00000000"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 10 * shellScaleFactor
                anchors.leftMargin: 10 * shellScaleFactor
                anchors.bottomMargin: 30 * shellScaleFactor

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
                    width: parent.height / 2
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    source: "icons/gpm-brightness-lcd-disabled.svg"
                    anchors.leftMargin: 7 * shellScaleFactor
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
                    width: parent.height / 2
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    source: "icons/gpm-brightness-lcd"
                    anchors.rightMargin: 7 * shellScaleFactor
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
                    anchors.rightMargin: 25 * shellScaleFactor
                    anchors.leftMargin: 25 * shellScaleFactor
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
                    x: (screenBrightness * (volumeBarTrack1.width - volumeBarThumb1.width) / 100) + volumeBarTrack1.x
                    y: volumeBarTrack1.y - height/2
                    width: height
                    height: parent.height / 2
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
                        settings.StoreBrightness(vol);
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
