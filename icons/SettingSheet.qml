import QtQuick 2.14
import QtGraphicalEffects 1.0

// setting sheet 
Rectangle {
    id: settingSheet
    width: 480
    height: 800

    anchors { right: parent.right;  }
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
        x: 8
        y: 275
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
        anchors.bottomMargin: 15
        anchors.leftMargin: 0
        anchors.topMargin: -15
        radius: 90

        Text {
            id: text2
            x: 58
            y: 72
            color: "#ffffff"
            text: qsTr("Atmosphere:")
            font.pixelSize: 28
            font.bold: false
        }

        Image {
            id: image
            x: 58
            y: 117
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
                rotation: 3.774
                font.bold: false
            }
        }

        Rectangle {
            id: rectangle
            x: 44
            y: 269
            width: 183
            height: 177
            color: "#51ffffff"
        }

        Text {
            id: text3
            x: 103
            y: 391
            color: "#000000"
            text: qsTr("Wi-Fi")
            font.pixelSize: 28
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Rectangle {
            id: rectangle1
            x: 256
            y: 269
            width: 183
            height: 177
            color: "#51ffffff"
        }

        Rectangle {
            id: rectangle2
            x: 44
            y: 470
            width: 183
            height: 177
            color: "#51ffffff"
        }

        Rectangle {
            id: rectangle3
            x: 256
            y: 470
            width: 183
            height: 177
            color: "#51ffffff"
        }

        Text {
            id: text4
            x: 323
            y: 391
            color: "#000000"
            text: qsTr("Sim")
            font.pixelSize: 28
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Text {
            id: text5
            x: 50
            y: 475
            color: "#000000"
            text: qsTr("usage")
            font.pixelSize: 28
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Text {
            id: text6
            x: 76
            y: 525
            color: "#000000"
            text: qsTr("cpu: 27%")
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Text {
            id: text7
            x: 76
            y: 558
            color: "#000000"
            text: qsTr("gpu: 12%")
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Text {
            id: text8
            x: 76
            y: 589
            color: "#000000"
            text: qsTr("ram: 300/2.7")
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Text {
            id: text9
            x: 265
            y: 475
            color: "#000000"
            text: qsTr("Weather")
            font.pixelSize: 28
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Text {
            id: text10
            x: 265
            y: 514
            color: "#000000"
            text: qsTr("ЛО")
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Text {
            id: text11
            x: 265
            y: 547
            color: "#000000"
            text: qsTr("сегодня: 27")
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
        }

        Text {
            id: text12
            x: 265
            y: 579
            color: "#000000"
            text: qsTr("Солнечно")
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            font.bold: false
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
        anchors.rightMargin: -8
        anchors.leftMargin: 8
        anchors.topMargin: 234
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
