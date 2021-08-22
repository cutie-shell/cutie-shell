import QtQuick 2.14
import QtQuick.Window 2.2
import QtWayland.Compositor 1.14
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtSensors 5.11

ShellSurfaceItem {
    y: 20*shellScaleFactor
    sizeFollowsSurface: true
    shellSurface: keyboard
    focusOnClick: false
    z: 320

    onShellSurfaceChanged: {
        for (let i = 0; i < shellSurfaces.count; i++) {
            if (shellSurfaces.get(i).shellSurface != shellSurface) {
                if (shellSurface != null) {
                    shellSurfaces.get(i).shellSurface.toplevel.sendResizing(Qt.size(view.width, view.height * 0.7 - 36 * shellScaleFactor));
                } else {
                    shellSurfaces.get(i).shellSurface.toplevel.sendResizing(Qt.size(view.width, view.height - 20 * shellScaleFactor));
                }
            }
        }
        if (shellSurface != null) {
            content.keyboardHeight = view.height * 0.3 + 16 * shellScaleFactor
        } else {
            content.keyboardHeight = 0
        }
    }
}
