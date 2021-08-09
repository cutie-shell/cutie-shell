import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12

ApplicationWindow {
    id: applicationWindow
    width: 480
    height: 800
    visible: true
    color: "black"
    title: qsTr("Setup-wizard")

    Rectangle{
        id: minui
        x: 0
        y: 0
        width: 480
        height: 800
        color: "#000000"
        AnimatedImage {
            id: animatedImage
            x: 190
            y: 501
            width: 100
            height: 100
            anchors.verticalCenter: parent.verticalCenter
            source: "minUi-icons/loader.gif"
            anchors.verticalCenterOffset: 179
            anchors.horizontalCenterOffset: -5
            anchors.horizontalCenter: parent.horizontalCenter
            playing: true
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text1
            x: 141
            y: 66
            width: 199
            height: 80
            color: "#ffffff"
            text: qsTr("Hello!")
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 45
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenterOffset: -286
            anchors.horizontalCenterOffset: 1
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: false
            minimumPixelSize: 13
        }

    }


    Image{
        id: ui
       visible: false
        anchors.fill: parent
        source: "wallpaper.jpg"
        sourceSize.width: 800
        sourceSize.height: 2000
        fillMode: Image.Pad
        enabled: true
        anchors.bottomMargin: 0


    }
    FastBlur {
        id: blur
      visible: false
        anchors.fill: ui
        source: ui
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        radius: 65

        Text {
            id: text3
            x: 141
            y: 66
            width: 199
            height: 80
            color: "#ffffff"
            text: qsTr("Hello!")
            font.pixelSize: 45
            horizontalAlignment: Text.AlignHCenter
            minimumPixelSize: 13
            anchors.horizontalCenterOffset: 1
            font.bold: false
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: text4
            x: 136
            y: 370
            width: 443
            height: 70
            color: "#ffffff"
            text: qsTr("Thank you for installing the cutie-pi shell environment.")
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            minimumPixelSize: 9
            font.bold: false
            anchors.horizontalCenterOffset: 1
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Image {
            id: image
            x: 141
            y: 206
            width: 203
            height: 158
            source: "44831719.png"
            anchors.horizontalCenterOffset: 1
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text5
            x: 143
            y: 734
            width: 167
            height: 40
            color: "#ffffff"
            text: qsTr("Use the DE!")
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 25
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenterOffset: 326
            minimumPixelSize: 13
            font.bold: false
            anchors.horizontalCenterOffset: 1
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Timer {
        interval: 55000; running: true; repeat: true
        onTriggered: {

            minui.visible = false
            ui.visible = true
            blur.visible = true
        }


    }


}
