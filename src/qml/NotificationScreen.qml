import QtQuick
import Qt5Compat.GraphicalEffects
import QtWayland.Compositor
import Cutie

Item {
    anchors.fill: parent
    opacity: 0
    enabled: root.state == "notificationScreen"

    ListView {
        id: notificationList
        model: notifications
        orientation: ListView.Vertical
        anchors.fill: parent
        anchors.topMargin: 30

        header: Item {
            height: notificationHeader.height + descriptionText.height * 3
            Text {
                id: notificationHeader
                text: qsTr("Notifications")
                anchors.top: parent.top
                anchors.topMargin: height / 2
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.right: parent.right
                anchors.rightMargin: 20
                font.pixelSize: 34
                font.family: "Lato"
                font.weight: Font.Bold
                horizontalAlignment: Text.AlignLeft
                color: Atmosphere.textColor
                transitions: Transition {
                    ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                }
            }

            Text {
                id: descriptionText
                text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
                anchors.top: notificationHeader.bottom
                anchors.topMargin: height / 2
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                font.pixelSize: 15
                font.family: "Lato"
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignLeft
                color: Atmosphere.textColor
                transitions: Transition {
                    ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                }
            }

            Timer {
                interval: 100; running: true; repeat: true;
                onTriggered: timeChanged()
            }

            function timeChanged() {
                descriptionText.text = Qt.formatDateTime(new Date(), "dddd, MMMM d");
            }
        }

        delegate: Item {
            width: notificationList.width
            height: titleText.height + bodyText.height + 40 * (1 - Math.abs(x/width))
            opacity: 1 - Math.abs(x/width)

            Rectangle {
                color: (atmosphereVariant == "dark") ? "#2fffffff" : "#4f000000"
                radius: 10
                anchors.fill: parent
                anchors.topMargin: 10
                anchors.leftMargin: 15
                anchors.rightMargin: 15
            }

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
                anchors.leftMargin: 25
                anchors.right: parent.right
                anchors.rightMargin: 25
                anchors.top: parent.top
                anchors.topMargin: 20 * (1 - Math.abs(parent.x/parent.width))
                font.pixelSize: 14 * (1 - Math.abs(parent.x/parent.width))
                font.family: "Lato"
                font.weight: Font.Black
                wrapMode: Text.Wrap
                color: Atmosphere.textColor
                transitions: Transition {
                    ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                }
            }

            Text {
                id: bodyText
                text: body
                anchors.left: parent.left
                anchors.leftMargin: 25
                anchors.right: parent.right
                anchors.rightMargin: 25
                anchors.top: titleText.bottom
                anchors.topMargin: 10 * (1 - Math.abs(parent.x/parent.width))
                font.pixelSize: 14 * (1 - Math.abs(parent.x/parent.width))
                font.family: "Lato"
                font.bold: false
                wrapMode: Text.Wrap
                color: Atmosphere.textColor
                transitions: Transition {
                    ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                }
            }
        }
    }
}