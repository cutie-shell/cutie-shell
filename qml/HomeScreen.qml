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

    Component {
        id: tabDelegate
        Row {
            spacing: 5*shellScaleFactor
            Rectangle {
                width: view.width
                height: 25 * shellScaleFactor
                color: "transparent"
                Image { 
                    height: 12 * shellScaleFactor
                    width: 12 * shellScaleFactor 
                    source: "icons/favicon.png"; // FIXME 
                    anchors { left: parent.left; margins: drawerMargin; verticalCenter: parent.verticalCenter} 
                }
                Text { 
                    text: modelData.toplevel.title
                    color: (atmosphereVariant == "dark") ? "#ffffff" : "#000000"
                    font.pixelSize: 14* shellScaleFactor
                    anchors { left: parent.left; margins: drawerMargin; verticalCenter: parent.verticalCenter
                        leftMargin: drawerMargin+15*shellScaleFactor; right: parent.right; rightMargin: 18*shellScaleFactor } 
                    font.family: mainFont.name
                    elide: Text.ElideRight 
                }
                MouseArea { 
                    anchors { top: parent.top; left: parent.left; bottom: parent.bottom; right: parent.right; rightMargin: 20*shellScaleFactor }
                    enabled: (root.state == "homeScreen") 
                    onClicked: {
                        root.state = "appScreen";
                        appScreen.shellSurface = modelData;
                        appScreen.shellSurfaceIdx = index;
                    }
                }

                Rectangle {
                    width: 20 * shellScaleFactor
                    height: 20 * shellScaleFactor
                    color: "transparent"
                    anchors { right: parent.right; top: parent.top}
                    Text {
                        anchors { top: parent.top; right: parent.right; margins: drawerMargin }
                        text: "\uF057"
                        font.family: icon.name
                        font.pixelSize: 14 * shellScaleFactor
                        color: "gray"

                        MouseArea { 
                            anchors.fill: parent; anchors.margins: -shellScaleFactor 
                            onClicked: {
                                modelData.toplevel.sendClose();
                            }
                        }
                    }
                }
            }
        }
    }

    ListView {
        id: tabListView
        height: parent.height
        anchors.fill: parent
        anchors.topMargin: 20 * shellScaleFactor

        model: shellSurfaces
        delegate: tabDelegate 
        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
        }
        displaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
        }
    }
}