import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtWayland.Compositor 1.14

Rectangle {
    anchors.fill: parent
    opacity: 0
    z: 150
    color: "transparent"

    FastBlur {
        anchors.fill: parent
        source: realWallpaper
        radius: 70
    }

    Text {
        id: notificationHeader
        x: 20  * shellScaleFactor
        y: 30  * shellScaleFactor
        text: qsTr("Notifications")
        font.pixelSize: 14 * shellScaleFactor
        font.family: mainFont.name
        font.weight: Font.Black
        state: atmosphereVariant
        states: [
            State {
                name: "dark"
                PropertyChanges { target: notificationHeader; color: "#ffffff" }
            },
            State {
                name: "light"
                PropertyChanges { target: notificationHeader; color: "#000000" }
            }
        ]
        transitions: Transition {
            ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
        }
    }

    Item {
        x: 0
        y: 0
        z: 300
        height: parent.height
        width: 5 * shellScaleFactor

        MouseArea { 
            enabled: root.state == "notificationScreen"
            drag.target: parent; drag.axis: Drag.XAxis; drag.minimumX: 0; drag.maximumX: view.width
            anchors.fill: parent
            onReleased: {
                if (parent.x > view.width / 2) { root.state = "homeScreen" }
                else { parent.parent.opacity = 1 }
                parent.x = 0
            }
            onPositionChanged: {
                if (drag.active) {
                    parent.parent.opacity = 1 - parent.x / view.width 
                    homeScreen.opacity = parent.x / view.width 
                }
            }
        }
    }

    Item {
        x: view.width - 5 * shellScaleFactor
        y: 0
        z: 300
        height: parent.height
        width: 5 * shellScaleFactor

        MouseArea { 
            enabled: root.state == "notificationScreen"
            drag.target: parent; drag.axis: Drag.XAxis; drag.minimumX: -5 * shellScaleFactor; drag.maximumX: view.width - 5* shellScaleFactor
            anchors.fill: parent
            onReleased: {
                if (parent.x < view.width / 2) { root.state = "homeScreen" }
                else { parent.parent.opacity = 1 }
                parent.x = view.width - 5 * shellScaleFactor
            }
            onPositionChanged: {
                if (drag.active) {
                    parent.parent.opacity = parent.x / view.width 
                    homeScreen.opacity = 1 - parent.x / view.width 
                }
            }
        }
    }
}