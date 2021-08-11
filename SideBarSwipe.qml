import QtQuick 2.14

MouseArea {
    z: 300
    width: 5 * shellScaleFactor
    height: parent.height
    anchors {
        left: parent.left
    }
    drag.target: sidebar; drag.axis: Drag.XAxis; drag.minimumX: -view.width; drag.maximumX: 0
    onPressed: {
        if (sidebar.x > -view.width / 2) { root.state = "normal" } else { root.state = "drawer" }
    }
    onReleased: {
        if (sidebar.x > -view.width / 2) { 
            root.state = "parked";
            root.state = "drawer";
        } else { root.state = "normal" }
    }
}

