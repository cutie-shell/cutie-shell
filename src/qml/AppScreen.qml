import QtQuick
import Qt5Compat.GraphicalEffects
import QtWayland.Compositor
import Cutie

Item {
    anchors.fill: parent
    anchors.topMargin: 30
    opacity: 0
    visible: opacity > 0
    property alias chrome: visibleClient
    
    property ShellSurface shellSurface
    property int shellSurfaceIdx: -1

    onShellSurfaceChanged: {
        visibleClient.shellSurface = shellSurface;
        visibleClient.takeFocus();
    }

    WaylandChrome {
        id: visibleClient
    }
}