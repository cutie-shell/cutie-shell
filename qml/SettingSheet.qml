import QtQuick 2.14
import QtGraphicalEffects 1.0

// setting sheet 
Rectangle {
    id: settingSheet
    width: view.width
    height: view.height
    z: 350

    MouseArea { 
        enabled: settingsState.state != "closed"
        drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: -view.height; drag.maximumY: 0
        width: view.width
        height: 5 * shellScaleFactor
        z: 100
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }

        onPressed: {
            settingsState.state = "closing";
        }

        onReleased: {
            if (parent.y > -view.height / 2) { settingsState.state = "opened" } else { settingsState.state = "closed" }
        }
    }

    Image {
        id: ui
        x: 0
        y: 0
        anchors.fill: parent
        source: "file://usr/share/atmospheres/Current/wallpaper.jpg"
        sourceSize.height: 2000
        sourceSize.width: 800
        fillMode: Image.PreserveAspectCrop
    }
    FastBlur {
        anchors.fill: ui
        source: ui
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        radius: 90

        Text {
            id: text2
            x: 25  * shellScaleFactor
            y: 25  * shellScaleFactor
            color: "#ffffff"
            text: qsTr("Atmosphere:")
            font.pixelSize: 14 * shellScaleFactor
            font.bold: false
        }

        Image {
            id: image
            x: 25 * shellScaleFactor
            y: 55 * shellScaleFactor
            width: 60 * shellScaleFactor
            height: 60 * shellScaleFactor
            source: "file://usr/share/atmospheres/city/wallpaper.jpg"
            fillMode: Image.PreserveAspectFit

            Text {
                id: text1
                anchors.centerIn: parent
                color: "#ffffff"
                text: qsTr("City")
                font.pixelSize: 9 * shellScaleFactor
                font.bold: false
            }
        }

        Rectangle {
            id: rectangle
            x: 25 * shellScaleFactor
            y: 135 * shellScaleFactor
            width: view.width / 2 - 37 * shellScaleFactor
            height: view.width / 2 - 37 * shellScaleFactor
            color: "#2fffffff"
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
            color: "#2fffffff"
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
            color: "#2fffffff"
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
            color: "#2fffffff"
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
        }

        Rectangle {
            id: volumeBarTrack1
            height: shellScaleFactor
            color: "#eceff4"
            radius: 1
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: volumeMuted1.right
            anchors.right: volumeHigh1.left
            anchors.rightMargin: 5 * shellScaleFactor
            anchors.leftMargin: 5 * shellScaleFactor
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
                var fullrange = volumeBarTrack1.width - volumeBarThumb1.width
                var vol = 100*(volumeBarThumb1.x - volumeBarTrack1.x)/fullrange
                if(vol <= 2)
                    setting.audio.source = "icons/audio-volume-muted-symbolic.svg"
                else if(vol < 25)
                    setting.audio.source = "icons/audio-volume-low-symbolic.svg"
                else if(vol < 75)
                    setting.audio.source = "icons/audio-volume-medium-symbolic.svg"
                else
                    setting.audio.source = "icons/audio-volume-high-symbolic.svg"
            }
        }
    }

}
