import QtQuick 2.14
import QtWayland.Compositor 1.14

ShellSurfaceItem {
    x: 0
    y: 30 * shellScaleFactor
    sizeFollowsSurface: false
    autoCreatePopupItems: true
    touchEventsEnabled: root.state === "appScreen"

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