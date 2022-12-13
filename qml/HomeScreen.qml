import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtWayland.Compositor 1.14
import QtQuick.Controls 2.12

Rectangle {
    id: homeScreen
    anchors.fill: parent
    opacity: 0
    color: "transparent"
    enabled: root.state == "homeScreen"

    Rectangle {
        id: searchBar
        height: 40 * shellScaleFactor
	    color: (atmosphereVariant == "dark") ? "#ffffff" : "#000000"
        visible: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 8 * shellScaleFactor
        anchors.rightMargin: 8 * shellScaleFactor
        anchors.topMargin: 50 * shellScaleFactor
        radius: 8 * shellScaleFactor
        clip: true
        TextField {
            id: searchText
            text: ""
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10 * shellScaleFactor
            color: (atmosphereVariant == "dark") ? "#000000" : "#ffffff"
            clip: true
            font.family: "Lato"
            font.pixelSize: 15 * shellScaleFactor
            background: Item { }
        }
    }
    
    GridView {
        id: tabListView
        anchors.fill: parent
        anchors.topMargin: searchBar.height + 70 * shellScaleFactor
        model: shellSurfaces
        cellWidth: view.width / 2 - 5 * shellScaleFactor
        cellHeight: view.height / 2 + 20 * shellScaleFactor
        clip: true

        delegate: Item {
            id: appThumb
            width: view.width / 2 - 15 * shellScaleFactor
            height: view.height / 2 + 10 * shellScaleFactor
            Rectangle {
                id: appBg
                width: view.width / 2 - 10 * shellScaleFactor
                height: view.height / 2 + 15 * shellScaleFactor
                x: 10 * shellScaleFactor
                color: (atmosphereVariant == "dark") ? "#4fffffff" : "#4f000000"
                radius: 10 * shellScaleFactor
                clip: true

                Rectangle {
                    id: appRoundMask
                    anchors.fill: parent
                    anchors.bottomMargin: 25 * shellScaleFactor
                    color: "black"
                    radius: 10 * shellScaleFactor
                    clip: true
                    visible: false
                }

                WaylandQuickItem {
                    id: appPreview
                    anchors.fill: parent
                    anchors.bottomMargin: 25 * shellScaleFactor
                    surface: modelData.surface
                    sizeFollowsSurface: false
                    inputEventsEnabled: false
                    clip: true
                    visible: false
                    onSurfaceDestroyed: shellSurfaces.remove(index)
                }

                OpacityMask {
                    anchors.fill: appPreview
                    source: appPreview
                    maskSource: appRoundMask
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 7 * shellScaleFactor
                    color: "#ffffff"
                    text: modelData.toplevel.title
                    font.pixelSize: 12 * shellScaleFactor
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "Lato"
                    font.bold: false
                }

                MouseArea {
                    anchors.fill: parent
                    drag.target: parent; drag.axis: Drag.XAxis; drag.minimumX: -parent.width; drag.maximumX: parent.width
                    onClicked: {
                        root.state = "appScreen";
                        appScreen.shellSurface = modelData;
                        appScreen.shellSurfaceIdx = index;
                    }

                    onPressAndHold: {
                        if (appScreen.shellSurfaceIdx == index){
                            if (shellSurfaces.count != 1) {
                                if (index == 0) {
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
                        modelData.toplevel.sendClose();
                    }

                    onReleased: {
                        if (Math.abs(parent.x - 10 * shellScaleFactor) > parent.width / 3) {
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
                            modelData.toplevel.sendClose();
                        }
                        else { 
                            parent.opacity = 1;
                        }
                        parent.x = 10 * shellScaleFactor;
                    }
                    onPositionChanged: {
                        if (drag.active) {
                            parent.opacity = 1 - Math.abs(parent.x - 10 * shellScaleFactor) / parent.width 
                        }
                    }
                }
            }
        }
    }
}