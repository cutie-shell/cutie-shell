import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtWayland.Compositor 1.14

Rectangle {
    anchors.fill: parent
    opacity: 0
    color: "transparent"
    enabled: root.state == "notificationScreen"

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
        font.pixelSize: 36 * shellScaleFactor
        font.family: "Lato"
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

    ListView {
        id: notificationList
        model: notifications
        orientation: ListView.Vertical
        anchors.fill: parent
        anchors.margins: 10 * shellScaleFactor
        anchors.topMargin: 50 * shellScaleFactor
        spacing: 10 * shellScaleFactor

        delegate: Rectangle {
            width: notificationList.width
            height: titleText.height + bodyText.height + 30 * shellScaleFactor * (1 - Math.abs(x/width))
            color: (atmosphereVariant == "dark") ? "#2fffffff" : "#4f000000"
            radius: 10 * shellScaleFactor
            opacity: 1 - Math.abs(x/width)

            MouseArea {
                anchors.fill: parent

                drag.target: parent
                drag.axis: Drag.XAxis

                onReleased: {
                    if (parent.x < - parent.width / 2 || parent.x > parent.width / 2) {
                        notifications.remove(index)
                    }
                    parent.x = 0
                }
            }

            Text {
                id: titleText
                text: title
                anchors.left: parent.left
                anchors.leftMargin: 10 * shellScaleFactor
                anchors.right: parent.right
                anchors.rightMargin: 10 * shellScaleFactor
                anchors.top: parent.top
                anchors.topMargin: 10 * shellScaleFactor * (1 - Math.abs(parent.x/parent.width))
                font.pixelSize: 14 * shellScaleFactor * (1 - Math.abs(parent.x/parent.width))
                font.family: "Lato"
                font.weight: Font.Black
                wrapMode: Text.Wrap
                state: atmosphereVariant
                states: [
                    State {
                        name: "dark"
                        PropertyChanges { target: titleText; color: "#ffffff" }
                    },
                    State {
                        name: "light"
                        PropertyChanges { target: titleText; color: "#000000" }
                    }
                ]
                transitions: Transition {
                    ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                }
            }

            Text {
                id: bodyText
                text: body
                anchors.left: parent.left
                anchors.leftMargin: 10 * shellScaleFactor
                anchors.right: parent.right
                anchors.rightMargin: 10 * shellScaleFactor
                anchors.top: titleText.bottom
                anchors.topMargin: 10 * shellScaleFactor * (1 - Math.abs(parent.x/parent.width))
                font.pixelSize: 14 * shellScaleFactor * (1 - Math.abs(parent.x/parent.width))
                font.family: "Lato"
                font.bold: false
                wrapMode: Text.Wrap
                state: atmosphereVariant
                states: [
                    State {
                        name: "dark"
                        PropertyChanges { target: bodyText; color: "#ffffff" }
                    },
                    State {
                        name: "light"
                        PropertyChanges { target: bodyText; color: "#000000" }
                    }
                ]
                transitions: Transition {
                    ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                }
            }
        }
    }
}