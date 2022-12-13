import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtWayland.Compositor 1.14

Rectangle {
    anchors.fill: parent
    opacity: 0
    visible: opacity > 0
    color: "transparent"
    
    property ShellSurface shellSurface
    property int shellSurfaceIdx: -1

    onShellSurfaceChanged: {
        visibleClient.shellSurface = shellSurface;
    }

    WaylandChrome {
        id: visibleClient
    }
}