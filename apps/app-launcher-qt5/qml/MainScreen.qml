import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Material 2.1
import QtGraphicalEffects 1.0




ApplicationWindow{

    width: 480
    height: 800
    visibility: Window.FullScreen
    flags: Qt.BypassWindowManagerHint | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint

    Item {
        id: root
        state: "normal"
        states: [
            State {
              name: "swipe"
               PropertyChanges { target: mainlauncher; y: 0 }
           },

             State {
                 name: "normal"
                 PropertyChanges { target: content; anchors.leftMargin: 0 }
                 PropertyChanges { target: mainlaucher; y: 800 + 0 }
             }

       ]

        transitions: [
           Transition {
                to: "*"
                NumberAnimation { target: mainlaucher; properties: "y"; duration: 400; easing.type: Easing.InOutQuad; }
                NumberAnimation { target: content; properties: "anchors.leftMargin"; duration: 300; easing.type: Easing.InOutQuad; }
           }



        ]



    }



        Image {
            id: ui
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            source: "../wallpaper.jpg"
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
            sourceSize.height: 2000
            sourceSize.width: 800
            fillMode: Image.Pad


        }
        FastBlur {
            anchors.fill: ui
            source: ui
            anchors.rightMargin: 0
             anchors.leftMargin: 0
            anchors.topMargin: 0
            radius: 90
            visible: false
        }
         Main { id: mainlaucher }


        MouseArea {
            id: swipe
            x: 0
            y: 732
            width: 472
            height: 43
            drag.target: mainlaucher; drag.axis: Drag.YAxis; drag.minimumY: 800; drag.maximumY: 0
            //onPressAndHold: {
            //    screenshotTimer.start();
            //}
            onClicked: {
                if (mainlauncher.y > 800) { root.state = "normal" } else { root.state = "swipe" }
            }
            onReleased: {
                if (mainlauncher.y > 800) { root.state = "swipe" } else { root.state = "normal" }
            }
        }



}
