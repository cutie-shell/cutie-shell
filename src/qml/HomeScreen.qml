import QtQuick
import Qt5Compat.GraphicalEffects
import QtWayland.Compositor
import QtQuick.Controls

Rectangle {
    id: homeScreen
    anchors.fill: parent
    opacity: 0
    color: "transparent"
    enabled: root.state == "homeScreen"
    
    GridView {
        id: tabListView
        anchors.fill: parent
        anchors.topMargin: 70 * shellScaleFactor
        model: shellSurfaces
        cellWidth: view.width / 2 - 5 * shellScaleFactor
        cellHeight: view.height / 2 + 20 * shellScaleFactor
        clip: true

        delegate: Item {
            id: appThumb
            width: tabListView.cellWidth
            height: tabListView.cellHeight
            Rectangle {
                id: appBg
                width: appThumb.width - 20 * shellScaleFactor
                height: appThumb.height - 20 * shellScaleFactor
                x: 10 * shellScaleFactor
                color: (atmosphereVariant == "dark") ? "#4fffffff" : "#4f000000"
                radius: 10 * shellScaleFactor
                clip: true

                Item {
                    id: appRoundMask
                    anchors.fill: parent
                    anchors.bottomMargin: 25 * shellScaleFactor
                    clip: true
                    visible: false
                    Rectangle {
                        anchors.fill: parent
                        anchors.bottomMargin: -25 * shellScaleFactor
                        color: "black"
                        radius: 10 * shellScaleFactor
                    }
                }

                WaylandQuickItem {
                    id: appPreview
                    anchors.fill: parent
                    anchors.bottomMargin: 25 * shellScaleFactor
                    surface: modelData.surface
                    inputEventsEnabled: false
                    clip: true
                    visible: false
                    onSurfaceDestroyed: shellSurfaces.remove(index)

                    Component.onCompleted: {
                        if (modelData.toplevel) modelData.toplevel.sendResizing(Qt.size(view.width / shellScaleFactor, view.height / shellScaleFactor - 30))

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
                    height: 25 * shellScaleFactor
                    clip: true

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 50 * shellScaleFactor
                        radius: 10 * shellScaleFactor
                        color: (atmosphereVariant == "dark") ? "#ffffff" : "#000000"
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 7 * shellScaleFactor
                        color: (atmosphereVariant == "dark") ? "#000000" : "#ffffff"
                        text: modelData.toplevel.title
                        font.pixelSize: 12 * shellScaleFactor
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
                        if (Math.abs(appBg.x - 10 * shellScaleFactor) > parent.width / 3) {
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
                        appBg.x = 10 * shellScaleFactor;
                    }

                    onPositionChanged: {
                        if (drag.active) {
                            parent.opacity = 1 - Math.abs(appBg.x - 10 * shellScaleFactor) / parent.width 
                        }
                    }
                }
            }
        }
    }
}