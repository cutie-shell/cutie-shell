import QtQuick
import Qt5Compat.GraphicalEffects
import QtWayland.Compositor

Rectangle {
    anchors.fill: parent
    opacity: 0
    visible: opacity > 0
    color: "transparent"
    property alias chrome: visibleClient
    
    property ShellSurface shellSurface
    property int shellSurfaceIdx: -1

    onShellSurfaceChanged: {
        visibleClient.shellSurface = shellSurface;
    }

    WaylandChrome {
        id: visibleClient
    }
}