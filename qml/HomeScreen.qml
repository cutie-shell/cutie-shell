import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtWayland.Compositor 1.14

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
                    color: "white"; 
                    font.pointSize: 4* shellScaleFactor
                    anchors { left: parent.left; margins: drawerMargin; verticalCenter: parent.verticalCenter
                        leftMargin: drawerMargin+15*shellScaleFactor; right: parent.right; rightMargin: 18*shellScaleFactor } 
                    elide: Text.ElideRight 
                }
                MouseArea { 
                    anchors { top: parent.top; left: parent.left; bottom: parent.bottom; right: parent.right; rightMargin: 20*shellScaleFactor }
                    enabled: (root.state == "homeScreen") 
                    onClicked: {
                        tabListView.currentIndex = index;
                        root.state = "appScreen";
                    }
                }

                Rectangle {
                    width: 20 * shellScaleFactor
                    height: 20 * shellScaleFactor
                    color: "transparent"
                    anchors { right: parent.right; top: parent.top}
                    Text { 
                        visible: tabListView.currentIndex === index
                        anchors { top: parent.top; right: parent.right; margins: drawerMargin }
                        text: "\uF057"
                        font.family: icon.name
                        font.pointSize: 3 * shellScaleFactor
                        color: "gray"

                        MouseArea { 
                            anchors.fill: parent; anchors.margins: -shellScaleFactor 
                            onClicked: {
                                modelData.surface.client.close()
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

        onCurrentIndexChanged: {
             if (currentIndex < 0) {
                appScreen.shellSurface = null;
                appScreen.shellSurfaceIdx = -1;
            } else {
                appScreen.shellSurface = shellSurfaces.get(currentIndex).shellSurface;
                appScreen.shellSurfaceIdx = currentIndex;
            }
        }

        model: shellSurfaces
        delegate: tabDelegate 
        highlight: Rectangle { 
            width: view.width; height: view.height
            gradient: Gradient {
                GradientStop { position: 0.1; color: "#1F1F23" }
                GradientStop { position: 0.5; color: "#28282F" }
                GradientStop { position: 0.8; color: "#2A2B31" }
                GradientStop { position: 1.0; color: "#25252A" }

            }
        }
        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
        }
        displaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
        }
        highlightMoveDuration: 2
        highlightFollowsCurrentItem: true 
    }
}