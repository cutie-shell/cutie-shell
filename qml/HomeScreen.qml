import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtWayland.Compositor 1.14
import QtQuick.Controls 2.12

Rectangle {
    id: homeScreen
    anchors.fill: parent
    opacity: 0
    z: 150
    color: "transparent"
    enabled: root.state == "homeScreen"

    Rectangle {
        id: searchBar
        height: 30 * shellScaleFactor
        color: (atmosphereVariant == "dark") ? "#ffffff" : "#000000"
        visible: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 8 * shellScaleFactor
        anchors.rightMargin: 8 * shellScaleFactor
        anchors.topMargin: 25 * shellScaleFactor
        radius: 8 * shellScaleFactor
        clip: true
        TextField {
            id: searchText
            text: ""
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            color: (atmosphereVariant == "dark") ? "#000000" : "#ffffff"
            clip: true
            font.family: "Lato"
            font.pixelSize: 14 * shellScaleFactor

            background: Rectangle {
                color: "transparent"
            }
        }
    }
    
    GridView {
        id: tabListView
        anchors.fill: parent
        anchors.topMargin: 64 * shellScaleFactor
        model: shellSurfaces
        cellWidth: view.width / 2 - 5 * shellScaleFactor
        cellHeight: view.height / 2 + 20 * shellScaleFactor
        clip: true

        delegate: Item {
            width: view.width / 2 - 15 * shellScaleFactor
            height: view.height / 2 + 10 * shellScaleFactor
            Rectangle {
                id: appBg
                width: view.width / 2 - 10 * shellScaleFactor
                height: view.height / 2 + 15 * shellScaleFactor
                x: 10 * shellScaleFactor
                color: (atmosphereVariant == "dark") ? "#2fffffff" : "#4f000000"
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
                    font.pixelSize: 9 * shellScaleFactor
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "Lato"
                    font.bold: false

                    onTextChanged: {
                        if (text == "maliit-server") {
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
            			    root.state = root.oldState;
                            screen.keyboard = modelData;
			                shellSurfaces.remove(index);
                        }
                    }
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

    Item {
        x: 0
        y: 0
        z: 300
        height: parent.height
        width: 10 * shellScaleFactor

        MouseArea { 
            enabled: root.state == "homeScreen"
            drag.target: parent; drag.axis: Drag.XAxis; drag.minimumX: 0; drag.maximumX: view.width
            anchors.fill: parent


            onReleased: {
                var velocityThreshold = 0.001 * shellScaleFactor;
                if (parent.x > parent.width) { 
                    root.state = (appScreen.shellSurfaceIdx == -1) ? "notificationScreen" : "appScreen";
                }
                else { parent.parent.opacity = 1; notificationScreen.opacity = 0 }
                parent.x = 0
            }
            onPositionChanged: {
                if (drag.active) {
                    parent.parent.opacity = 1 - parent.x / view.width 
                    if (appScreen.shellSurfaceIdx == -1) {
                        notificationScreen.opacity = parent.x / view.width
                    } else {
                        appScreen.opacity = parent.x / view.width
                    }
                }
            }
        }
    }

    Item {
        x: view.width - 10 * shellScaleFactor
        y: 0
        z: 300
        height: parent.height
        width: 10 * shellScaleFactor

        MouseArea { 
            enabled: root.state == "homeScreen"
            drag.target: parent; drag.axis: Drag.XAxis; drag.minimumX: -5 * shellScaleFactor; drag.maximumX: view.width - 5* shellScaleFactor
            anchors.fill: parent

            onReleased: {
                var velocityThreshold = 0.001 * shellScaleFactor;
                if (parent.x < parent.parent.width - 2 * parent.width) { root.state = "notificationScreen" }
                else { parent.parent.opacity = 1; notificationScreen.opacity = 0 }
                parent.x = view.width - 10 * shellScaleFactor
            }
            onPositionChanged: {
                if (drag.active) {
                    parent.parent.opacity = parent.x / view.width 
                    notificationScreen.opacity = 1 - parent.x / view.width
                }
            }
        }
    }
}