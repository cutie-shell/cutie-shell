import QtQuick 2.14
import QtWayland.Compositor 1.14

ShellSurfaceItem {
    anchors { fill: parent; topMargin: 20 * shellScaleFactor; bottomMargin: parent.parent.keyboardHeight }
    z: 200
    sizeFollowsSurface: false
    autoCreatePopupItems: true

    onSurfaceDestroyed: {
        if (shellSurfaces.count != 0) {
            if (parent.shellSurfaceIdx == shellSurfaces.count) {
                parent.shellSurface = shellSurfaces.get(parent.shellSurfaceIdx - 1).shellSurface;
                parent.shellSurfaceIdx -= 1;
            } else {
                parent.shellSurface = shellSurfaces.get(parent.shellSurfaceIdx + 1).shellSurface;
            }
        } else {
            parent.shellSurface = null;
            parent.shellSurfaceIdx = -1;
            root.state = "homeScreen";
        }
    }
}