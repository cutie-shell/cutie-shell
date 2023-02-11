import QtQuick
import QtWayland.Compositor
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings

ShellSurfaceItem {
    x: 0
    y: 30 * shellScaleFactor
    autoCreatePopupItems: true
    touchEventsEnabled: false

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

    MouseArea {
        anchors.fill: parent

        onPressed: {
            return true
        }
        onReleased: {
            return true
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        mouseEnabled: true
        enabled: root.state === "appScreen"
        onPressed: {
            for (let i = 0; i < touchPoints.length; i++) {
                comp.defaultSeat.sendTouchPointPressed(parent.shellSurface.surface, touchPoints[i].pointId, 
                    Qt.point(touchPoints[i].x / shellScaleFactor, touchPoints[i].y / shellScaleFactor));
            }
            comp.defaultSeat.sendTouchFrameEvent(parent.shellSurface.surface.client);
            parent.takeFocus();
        }
        onReleased: {
            for (let i = 0; i < touchPoints.length; i++) {
                comp.defaultSeat.sendTouchPointReleased(parent.shellSurface.surface, touchPoints[i].pointId,
                    Qt.point(touchPoints[i].x / shellScaleFactor, touchPoints[i].y / shellScaleFactor));
            }
            comp.defaultSeat.sendTouchFrameEvent(parent.shellSurface.surface.client);
        }
        onUpdated: {
            for (let i = 0; i < touchPoints.length; i++) { 
                comp.defaultSeat.sendTouchPointMoved(parent.shellSurface.surface, touchPoints[i].pointId, 
                    Qt.point(touchPoints[i].x / shellScaleFactor, touchPoints[i].y / shellScaleFactor));
            }
            comp.defaultSeat.sendTouchFrameEvent(parent.shellSurface.surface.client);
        }
    }
}