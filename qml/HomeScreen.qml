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
    
    GridView {
        id: tabListView
        anchors.fill: parent
        anchors.topMargin: 20 * shellScaleFactor
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
                    font.family: mainFont.name
                    font.bold: false
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.state = "appScreen";
                        appScreen.shellSurface = modelData;
                        appScreen.shellSurfaceIdx = index;
                    }

                    onPressAndHold: {
                        appScreen.shellSurface = modelData;
                        appScreen.shellSurfaceIdx = index;
                        modelData.toplevel.sendClose();
                    }
                }
            }
        }
    }
}