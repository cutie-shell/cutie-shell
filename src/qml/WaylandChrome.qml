import QtQuick
import QtWayland.Compositor
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings

ShellSurfaceItem {
    x: 0
    y: 30
    autoCreatePopupItems: true
    touchEventsEnabled: true

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
