import QtQuick 2.14
import QtGraphicalEffects 1.0

// setting sheet 
Rectangle {
    id: settingSheet
    width: 480
    height: 800

    // anchors { right: parent.right;  }
    y: -800








    // wifi scan result
    ListView {
        id: wifiListView
        visible: root.state == "setting"
        clip: true
        anchors {
            bottomMargin: 15
            topMargin: 56
            top: separator.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        /*
        model: networkingModel
        delegate: Rectangle {
            height: 45
            width: parent.width
            color: 'transparent'
            Row {
                width: parent.width - 40
                height: parent.height
                spacing: 10

                Rectangle {
                    width: 30
                    height: 20
                    color: 'transparent'
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        font.family: icon.name
                        font.pixelSize: 12
                        text: (modelData.state == "online" || modelData.state == "ready") ? "\uf00c" : ""
                        color: "#ECEFF4"
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Text {
                    text: (modelData.name == "") ? "[Hidden Wifi]" : modelData.name
                    color: "#ECEFF4"
                    elide: Text.ElideRight
                    width: 230
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 9
                }
            }
            Row {
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    rightMargin: 30
                }
                width: 50
                spacing: 10
                Rectangle {
                    width: 20
                    height: 20
                    color: 'transparent'
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        width: 20; height: width; sourceSize.width: width*2; sourceSize.height: height*2;
                        source: (modelData.security[0] == "none") ? "" : "icons/network-wireless-encrypted-symbolic.svg"
                    }
                }
                Image {
                    width: 20; height: width; sourceSize.width: width*2; sourceSize.height: height*2;
                    source: if (modelData.strength >= 55 ) { return "icons/network-wireless-signal-excellent-symbolic.svg" }
                    else if (modelData.strength >= 50 ) { return "icons/network-wireless-signal-good-symbolic.svg" }
                    else if (modelData.strength >= 45 ) { return "icons/network-wireless-signal-ok-symbolic.svg" }
                    else if (modelData.strength >= 30 ) { return "icons/network-wireless-signal-weak-symbolic.svg" }
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (modelData.state == "idle" || modelData.state == "failure") {
                        networkingModel.networkName = modelData.name
                        modelData.requestConnect()
                    }
                }
            }
        }
        */
    }

    Image {
        id: ui
        x: 0
        y: 0
        width: 480
        height: 800
        source: "wallpaper.jpg"
        sourceSize.height: 2000
        sourceSize.width: 800
        fillMode: Image.Pad
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
            x: 50
            y: 66
            color: "#ffffff"
            text: qsTr("Atmosphere:")
            font.pixelSize: 28
            font.bold: false
        }

        Image {
            id: image
            x: 50
            y: 111
            width: 100
            height: 100
            source: "wallpaper.jpg"
            fillMode: Image.PreserveAspectFit

            Text {
                id: text1
                x: 25
                y: 21
                color: "#ffffff"
                text: qsTr("City")
                font.pixelSize: 28

                font.bold: false
            }
        }

        Rectangle {
            id: rectangle
            x: 50
            y: 269
            width: 183
            height: 177
            color: "#2fffffff"
            radius: 19

        }


        Text {
            id: text3
            x: 109
            y: 381
            color: "#ffffff"
            text: qsTr("Wi-Fi")
            font.pixelSize: 28
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Rectangle {
            id: rectangle1
            x: 249
            y: 269
            width: 183
            height: 177
            color: "#2fffffff"
            radius: 19
        }

        Rectangle {
            id: rectangle2
            x: 50
            y: 460
            width: 183
            height: 177
            color: "#2fffffff"
            radius: 19
        }

        Rectangle {
            id: rectangle3
            x: 249
            y: 460
            width: 183
            height: 177
            color: "#2fffffff"
            radius: 19
        }

        Image {
            id: image4
            x: 97
            y: 299
            width: 90
            height: 84
            source: "icons/network-wireless-signal-good-symbolic.svg"
            sourceSize.height: 128
            sourceSize.width: 128
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text4
            x: 307
            y: 381
            color: "#ffffff"
            text: qsTr("Tele2")
            font.pixelSize: 28
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Image {
            id: image5
            x: 296
            y: 299
            width: 90
            height: 84
            source: "icons/network-cellular-signal-ok.svg"
            sourceSize.height: 128
            sourceSize.width: 128
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: image6
            x: 97
            y: 492
            width: 90
            height: 84
            source: "icons/airplane-mode.svg"
            sourceSize.height: 128
            sourceSize.width: 128
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: image7
            x: 255
            y: 511
            width: 78
            height: 85
            source: "icons/weather/graphic-weather-n322-light.png"
            sourceSize.height: 128
            sourceSize.width: 128
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text5
            x: 339
            y: 517
            color: "#ffffff"
            text: qsTr("snow")
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Text {
            id: text6
            x: 339
            y: 548
            color: "#ffffff"
            text: qsTr("-1")
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Text {
            id: text7
            x: 122
            y: 576
            color: "#ffffff"
            text: qsTr("Fly")
            font.pixelSize: 28
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Rectangle {
            id: statusbarmm
            x: 0
            y: 8
            width: 480
            height: 40
            color: "#00ffffff"

            Image {
                id: image1
                x: 378
                y: 3
                width: 33
                height: 30
                source: "icons/network-cellular-signal-good.svg"
                sourceSize.height: 400
                sourceSize.width: 400
                fillMode: Image.PreserveAspectFit
            }

            Image {
                id: image2
                x: 438
                y: 3
                width: 35
                height: 31
                source: "icons/network-wireless-signal-good-symbolic.svg"
                sourceSize.height: 128
                sourceSize.width: 128
                fillMode: Image.PreserveAspectFit
            }

            Text {
                id: text13
                x: 410
                y: 7
                width: 22
                height: 22
                color: "#ffffff"
                text: qsTr("4G")
                font.pixelSize: 17
                font.bold: false
            }

            Image {
                id: image3
                x: 8
                y: 2
                width: 34
                height: 32
                source: "icons/battery-070.svg"
                sourceSize.height: 128
                sourceSize.width: 128
                fillMode: Image.PreserveAspectFit
            }

            Text {
                id: text14
                x: 39
                y: 7
                width: 36
                height: 22
                color: "#ffffff"
                text: qsTr("75%")
                font.pixelSize: 17
                font.bold: false
            }

            Text {
                id: text15
                x: 216
                y: 7
                width: 49
                height: 22
                color: "#ffffff"
                text: qsTr("17:46")
                font.pixelSize: 17
                font.bold: false
            }
        }

    }

    Rectangle {
        id: brightness
        width: parent.width - 20
        height: 30
        color: "#00000000"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 701
        Image {
            id: volumeMuted1
            width: 30
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            source: "icons/gpm-brightness-lcd-disabled.svg"
            anchors.leftMargin: 15
            sourceSize.height: height*2
            sourceSize.width: width*2
        }

        Image {
            id: volumeHigh1
            width: 30
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            source: "icons/gpm-brightness-lcd"
            anchors.rightMargin: 20
            sourceSize.height: height*2
            sourceSize.width: width*2
        }

        Rectangle {
            id: volumeBarTrack1
            height: 2
            color: "#eceff4"
            radius: 1
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: volumeMuted1.right
            anchors.right: volumeHigh1.left
            anchors.rightMargin: 20
            anchors.leftMargin: 20
        }

        Rectangle {
            id: volumeBarThumb1
            x: volumeBarTrack1.x + volumeBarTrack1.width/2
            y: volumeBarTrack1.y - height/2
            width: 30
            height: 30
            radius: 15
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
