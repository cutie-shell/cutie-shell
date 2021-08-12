import QtQuick 2.14
import QtWayland.Compositor 1.14

ShellSurfaceItem {
    anchors { top: parent.top; left: parent.left }
    z: 200
    height: view.height
    width: view.width
    sizeFollowsSurface: false
    onSurfaceDestroyed: {
        shellSurfaces.remove(parent.shellSurfaceIdx);
        root.state = "homeScreen";
    }
}