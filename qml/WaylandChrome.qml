import QtQuick 2.14
import QtWayland.Compositor 1.14

ShellSurfaceItem {
    anchors { fill: parent; topMargin: 20 * shellScaleFactor }
    z: 200
    sizeFollowsSurface: false
    onSurfaceDestroyed: {
        shellSurfaces.remove(parent.shellSurfaceIdx);
        root.state = "homeScreen";
    }
}