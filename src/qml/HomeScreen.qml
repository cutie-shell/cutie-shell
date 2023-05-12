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

    GridView {
        id: tabListView
        anchors.fill: parent
        anchors.topMargin: 70
        model: shellSurfaces
        cellWidth: view.width / 2 - 5
        cellHeight: view.height / 2 + 20

        delegate: Item {
            id: appThumb
            width: tabListView.cellWidth
            height: tabListView.cellHeight

            Item {
                id: appBg
                width: appThumb.width - 20
                height: appThumb.height - 20
                x: 10

                Item {
                    id: tileBlurMask
                    anchors.fill: tileBlur
                    clip: true
                    visible: false
                    Rectangle {
                        width: appBg.width
                        height: appBg.height
                        x: appThumb.x+appBg.x+tabListView.x-tabListView.contentX
                        y: appThumb.y+appBg.y+tabListView.y-tabListView.contentY
                        color: "black"
                        radius: 10
                    }
                }

                FastBlur {
                    id: tileBlur
                    width: homeScreen.width
                    height: homeScreen.height
                    x: tabListView.contentX-appThumb.x-appBg.x-tabListView.x
                    y: tabListView.contentY-appThumb.y-appBg.y-tabListView.y
                    source: realWallpaper
                    radius: 70
                    visible: false
                }

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
                    anchors.fill: tileBlur
                    source: tileBlur
                    maskSource: tileBlurMask
                }

                Rectangle {
                    color: Atmosphere.secondaryAlphaColor
                    anchors.fill: appBg
                    opacity: 1/3
                    radius: 10
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
                            appThumb.opacity = 1;
                        }
                        appBg.x = 10;
                    }

                    onPositionChanged: {
                        if (drag.active) {
                            appThumb.opacity = 1 - Math.abs(appBg.x - 10) / parent.width 
                        }
                    }
                }
            }
        }
    }
}
