import QtQuick 2.14
import QtWayland.Compositor 1.14

ShellSurfaceItem {
    anchors { fill: parent; topMargin: 20 * shellScaleFactor; bottomMargin: parent.parent.keyboardHeight }
    z: 200
    sizeFollowsSurface: false
    autoCreatePopupItems: true

    onSurfaceDestroyed: {
        root.state = "homeScreen";
        parent.shellSurfaceIdx=-1
    }
}