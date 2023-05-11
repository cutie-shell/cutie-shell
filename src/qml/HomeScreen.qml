import QtQuick
import Qt5Compat.GraphicalEffects
import QtWayland.Compositor
import QtQuick.Controls
import Cutie

Item {
    id: homeScreen
    anchors.fill: parent
    opacity: 0
    enabled: root.state == "homeScreen"

    FastBlur {
        visible: shellSurfaces.count > 0
        anchors.fill: parent
        source: realWallpaper
        radius: 70
    }

    GridView {
        id: tabListView
        anchors.fill: parent
        anchors.topMargin: 70
        model: shellSurfaces
        cellWidth: view.width / 2 - 5
        cellHeight: view.height / 2 + 20
        clip: true

        delegate: Item {
            id: appThumb
            width: tabListView.cellWidth
            height: tabListView.cellHeight
            Rectangle {
                id: appBg
                width: appThumb.width - 20
                height: appThumb.height - 20
                x: 10
                color: Atmosphere.secondaryAlphaColor
                radius: 10
                clip: true

                Item {
                    id: appRoundMask
                    anchors.fill: parent
                    anchors.bottomMargin: 25
                    clip: true
                    visible: false
                    Rectangle {
                        anchors.fill: parent
                        anchors.bottomMargin: -25
                        color: "black"
                        radius: 10
                    }
                }

                WaylandQuickItem {
                    id: appPreview
                    anchors.fill: parent
                    anchors.bottomMargin: 25
                    surface: modelData.surface
                    inputEventsEnabled: false
                    clip: true
                    visible: false
                    onSurfaceDestroyed: shellSurfaces.remove(index)

                    Component.onCompleted: {
                        if (modelData.toplevel) {
                            modelData.toplevel.sendResizing(Qt.size(view.width, view.height - 30))

                        }

                        appScreen.shellSurface = modelData;
                        appScreen.shellSurfaceIdx += 1;
                        root.oldState = root.state;
                        root.state = "appScreen";
                    }
                }

                OpacityMask {
                    anchors.fill: appPreview
                    source: appPreview
                    maskSource: appRoundMask
                }

                Item {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 25
                    clip: true

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 50
                        radius: 10
                        color: Atmosphere.primaryColor
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 7
                        color: Atmosphere.textColor
                        text: modelData.toplevel.title
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        font.family: "Lato"
                        font.bold: false
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    drag.target: appBg; drag.axis: Drag.XAxis; drag.minimumX: -parent.width; drag.maximumX: parent.width
                    onClicked: {
                        root.state = "appScreen";
                        appScreen.shellSurface = modelData;
                        appScreen.shellSurfaceIdx = index;
                    }

                    onReleased: {
                        if (Math.abs(appBg.x - 10) > parent.width / 3) {
                            modelData.toplevel.sendClose();
                            if (appScreen.shellSurfaceIdx == index){
                                if (shellSurfaces.count != 1) {
                                    if (index == shellSurfaces.count - 1) {
                                        appScreen.shellSurface = shellSurfaces.get(index + 1).shellSurface;
                                        appScreen.shellSurfaceIdx = index + 1;
                                    } else {
                                        appScreen.shellSurface = shellSurfaces.get(index - 1).shellSurface;
                                        appScreen.shellSurfaceIdx = index - 1;
                                    }
                                } else {
                                    appScreen.shellSurface = null;
                                    appScreen.shellSurfaceIdx = -1;
                                }
                            }
                        }
                        else { 
                            parent.opacity = 1;
                        }
                        appBg.x = 10;
                    }

                    onPositionChanged: {
                        if (drag.active) {
                            parent.opacity = 1 - Math.abs(appBg.x - 10) / parent.width 
                        }
                    }
                }
            }
        }
    }
}
