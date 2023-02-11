import QtQuick
import Qt5Compat.GraphicalEffects

Rectangle {
    id: lockscreen 
    x: 0; y: 0; width: parent.width; height: parent.height 
    color: "transparent"

    property alias lockscreenMouseArea: lockscreenMouseArea
    property alias lockscreenTime: lockscreenTime
    property alias lockscreenDate: lockscreenDate 

    function timeChanged() {
        lockscreenTime.text = Qt.formatDateTime(new Date(), "HH:mm");
        lockscreenDate.text = Qt.formatDateTime(new Date(), "dddd, MMMM d");
    }

    Image {
        id: lockscreenImage
        source: atmospherePath + "wallpaper.jpg"
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
    }

    FastBlur {
        anchors.fill: parent
        source: lockscreenImage
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        radius: 45

        Item {
            x: 0
            y: 0
            height: parent.height
            width: parent.width

            MouseArea { 
                id: lockscreenMouseArea
                drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: -view.height; drag.maximumY: 0
                enabled: screenLockState.state == "locked";
                anchors.fill: parent
                propagateComposedEvents: true

                onReleased: {
                    if (parent.y < - 20 * shellScaleFactor) { screenLockState.state = "opened" }
                    else { lockscreen.opacity = 1}
                    parent.y = 0
                }

                onPositionChanged: {
                    if (drag.active) {
                        lockscreen.opacity = 1 + parent.y / view.height 
                    }
                }
            }

            MouseArea { 
                enabled: screenLockState.state == "closed";
                anchors.fill: parent

                onClicked: {}
            }
        }

        Text { 
            id: lockscreenTime
            color: (atmosphereVariant == "dark") ? "#ffffff" : "#000000"
            text: Qt.formatDateTime(new Date(), "HH:mm")
            font.pixelSize: 72 * shellScaleFactor
            font.family: "Lato"
            font.weight: Font.Light
            anchors { left: parent.left; bottom: lockscreenDate.top; leftMargin: 15 * shellScaleFactor; bottomMargin: 3* shellScaleFactor }
        }

        Text { 
            id: lockscreenDate
            color: (atmosphereVariant == "dark") ? "#ffffff" : "#000000"
            text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
            font.pixelSize: 20 * shellScaleFactor
            font.family: "Lato"
            font.weight: Font.Black
            anchors { left: parent.left; bottom: lockscreenNotifs.top; leftMargin: 15 * shellScaleFactor; bottomMargin: 3* shellScaleFactor }
        }

        Text { 
            id: lockscreenNotifs
            color: (atmosphereVariant == "dark") ? "#ffffff" : "#000000"
            text: notifications.count > 1
                ? qsTr("You have %1 unread notifications.").arg(notifications.count)
                : (notifications.count > 0
                ? qsTr("You have 1 unread notification.")
                : qsTr("You have no unread notifications."))
            font.pixelSize: 16 * shellScaleFactor
            font.family: "Lato"
            font.weight: Font.Normal
            anchors { left: parent.left; bottom: parent.bottom; margins: 15 * shellScaleFactor }
        }

        Timer {
            interval: 100; running: true; repeat: true;
            onTriggered: timeChanged()
        }
    }
}
