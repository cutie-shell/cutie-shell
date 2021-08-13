import QtQuick 2.14

Image {
    id: lockscreen 

    property alias lockscreenMosueArea: lockscreenMosueArea
    property alias lockscreenTime: lockscreenTime
    property alias lockscreenDate: lockscreenDate 

    //visible: ( screenLockState.state == "locked" )
    source: "file://usr/share/atmospheres/Current/wallpaper.jpg"
    fillMode: Image.PreserveAspectCrop
    z: 325
    x: 0; y: 0; width: parent.width; height: parent.height 
    MouseArea {
        id: lockscreenMosueArea
        anchors.fill: parent 
        drag.target: lockscreen; drag.axis: Drag.YAxis; drag.maximumY: 0
        onReleased: { 
            if (lockscreen.y > -parent.height / 2) { bounce.restart(); } else { screenLockState.state = "opened"; } 
        } 
    }
    NumberAnimation { id: bounce; target: lockscreen; properties: "y"; to: 0; easing.type: Easing.InOutQuad; duration: 200 }
    Text { 
        id: lockscreenTime
        text: Qt.formatDateTime(new Date(), "HH:mm"); color: 'white'; font.pointSize: 14 * shellScaleFactor; 
        anchors { left: parent.left; bottom: lockscreenDate.top; leftMargin: 15 * shellScaleFactor; bottomMargin: 3* shellScaleFactor }
    }
    Text { 
        id: lockscreenDate
        text: Qt.formatDateTime(new Date(), "dddd, MMMM d"); color: 'white'; font.pointSize: 8 * shellScaleFactor; 
        anchors { left: parent.left; bottom: parent.bottom; margins: 15 * shellScaleFactor }
    }
}
