import QtQuick
import Qt5Compat.GraphicalEffects
import Cutie

Item {
    id: lockscreen 
    x: 0; y: 0; width: parent.width; height: parent.height 

    property alias lockscreenMouseArea: lockscreenMouseArea
    property alias lockscreenTime: lockscreenTime
    property alias lockscreenDate: lockscreenDate

    function timeChanged() {
        lockscreenTime.text = Qt.formatDateTime(new Date(), "HH:mm");
        lockscreenDate.text = Qt.formatDateTime(new Date(), "dddd, MMMM d");
    }

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
                if (parent.y < - 20) { screenLockState.state = "opened" }
                    else { lockscreen.opacity = 1}
                parent.y = 0
            }

            onPositionChanged: {
                if (drag.active) {
                    lockscreen.opacity = 1 + parent.y / view.height;
                    shellContainer.opacity = 1 - lockscreen.opacity;
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
        color: Atmosphere.textColor
        text: Qt.formatDateTime(new Date(), "HH:mm")
        font.pixelSize: 72
        font.family: "Lato"
        font.weight: Font.Light

        anchors { 
            horizontalCenter: parent.horizontalCenter
            top: parent.top; 
            topMargin: 150
        }

        layer.enabled: true
        layer.effect: DropShadow {
            verticalOffset: 2
            color: Atmosphere.primaryColor
            radius: 2
            samples: 3
        }
    }

    Text { 
        id: lockscreenDate
        color: Atmosphere.textColor
        text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
        font.pixelSize: 20
        font.family: "Lato"
        font.weight: Font.Black

        anchors { 
            horizontalCenter: parent.horizontalCenter
            top: lockscreenTime.bottom; 
            topMargin: 5
        }

        layer.enabled: true
        layer.effect: DropShadow {
            verticalOffset: 2
            color: Atmosphere.primaryColor
            radius: 2
            samples: 3
        }
    }

    Text { 
        id: lockscreenNotifs
        color: Atmosphere.textColor
        text: notifications.count > 1
        ? qsTr("You have %1 unread notifications.").arg(notifications.count)
        : (notifications.count > 0
            ? qsTr("You have 1 unread notification.")
            : qsTr("You have no unread notifications."))
        font.pixelSize: 16
        font.family: "Lato"
        font.weight: Font.Normal

        anchors { 
            horizontalCenter: parent.horizontalCenter
            top: lockscreenDate.bottom; 
            topMargin: 5
        }

        layer.enabled: true
        layer.effect: DropShadow {
            verticalOffset: 2
            color: Atmosphere.primaryColor
            radius: 2
            samples: 3
        }
    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: timeChanged()
    }
}
