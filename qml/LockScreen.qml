import QtQuick 2.14
import QtGraphicalEffects 1.0

Rectangle {
    id: lockscreen 
    z: 325
    x: 0; y: 0; width: parent.width; height: parent.height 

    property alias lockscreenMosueArea: lockscreenMosueArea
    property alias lockscreenTime: lockscreenTime
    property alias lockscreenDate: lockscreenDate 

    function timeChanged() {
        lockscreenTime.text = Qt.formatDateTime(new Date(), "HH:mm:ss");
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
                id: lockscreenMosueArea
                drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: -view.height; drag.maximumY: 0
                anchors.fill: parent
                onReleased: {
                    if (parent.y < -view.height / 2) { screenLockState.state = "opened";}
                    else { lockscreen.opacity = 1 }
                    parent.y = 0
                }
                onPositionChanged: {
                    if (drag.active) {
                        lockscreen.opacity = 1 + parent.y / view.height 
                    }
                }
            }
        }

        Text { 
            id: lockscreenTime
            text: Qt.formatDateTime(new Date(), "HH:mm:ss"); color: 'white'; font.pixelSize: 32 * shellScaleFactor; 
            anchors { left: parent.left; bottom: lockscreenDate.top; leftMargin: 15 * shellScaleFactor; bottomMargin: 3* shellScaleFactor }
        }
        Text { 
            id: lockscreenDate
            text: Qt.formatDateTime(new Date(), "dddd, MMMM d"); color: 'white'; font.pixelSize: 14 * shellScaleFactor; 
            anchors { left: parent.left; bottom: parent.bottom; margins: 15 * shellScaleFactor }
        }

        Timer {
            interval: 100; running: true; repeat: true;
            onTriggered: timeChanged()
        }
    }
}
