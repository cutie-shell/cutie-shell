import QtQuick 2.14
import QtWayland.Compositor 1.14
import QtGraphicalEffects 1.0

Rectangle {
    id: sidebar
     x: 0
     y: 0
    property alias tabListView: tabListView
    width: 400
    height: parent.height 
   // anchors { left: parent.left; top: parent.top }
    color: "#2E3440"




    Image {
        id: ui
        x: 0
        width: 400
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        source: "wallpaper.jpg"
        anchors.topMargin: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        sourceSize.height: 2000
        sourceSize.width: 800
        fillMode: Image.Pad
    }
    FastBlur {
        anchors.fill: ui
        source: ui
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        radius: 90
    }









    Component {
        id: tabDelegate
        Row {
            spacing: 10
            Rectangle {
                width: drawerWidth
                height: 50 
                color: "transparent"
                Image { 
                    height: 24; width: 24; 
                    source: "icons/favicon.png"; // FIXME 
                    anchors { left: parent.left; margins: drawerMargin; verticalCenter: parent.verticalCenter} 
                }
                Text { 
                    text: modelData.title 
                    color: "white"; 
                    font.pointSize: 7
                    anchors { left: parent.left; margins: drawerMargin; verticalCenter: parent.verticalCenter
                        leftMargin: drawerMargin+30; right: parent.right; rightMargin: 36 } 
                    elide: Text.ElideRight 
                }
                MouseArea { 
                    anchors { top: parent.top; left: parent.left; bottom: parent.bottom; right: parent.right; rightMargin: 40 }
                    enabled: (root.state == "drawer") 
                    onClicked: { 
                        tabListView.currentIndex = index
                    }
                }

                Rectangle {
                    width: 40; height: 40
                    color: "transparent"
                    anchors { right: parent.right; top: parent.top}
                    Text { 
                        visible: tabListView.currentIndex === index
                        anchors { top: parent.top; right: parent.right; margins: drawerMargin }
                        text: "\uF057"
                        font.family: icon.name
                        font.pointSize: 10
                        color: "gray"

                        MouseArea { 
                            anchors.fill: parent; anchors.margins: -2 
                            onClicked: modelData.surface.client.close()
                        }
                    }
                }
            }
        }
    }

    ListView {
        id: tabListView
        height: 800
        anchors.fill: parent

        onCurrentIndexChanged: {
            if (shellSurfaces.get(currentIndex).shellSurface.toString().match(/XWaylandShellSurface/)) { 
                shellSurfaces.get(currentIndex).shellSurface.sendResize(Qt.size(view.width, view.height - 85));
            } else { 
                shellSurfaces.get(currentIndex).shellSurface.sendConfigure(Qt.size(view.width, view.height), WlShellSurface.NoneEdge);
            }
        }

        header: Rectangle { 
            width: drawerWidth
            height: 80
            color: "transparent"
            Text { 
                text: "\uF067"; font.family: icon.name; color: "white"; font.pointSize: 10
                anchors { top: parent.top; left: parent.left; margins: 20; leftMargin: 30 }
            }
            Text { 
                text: "<b>New Tab</b>"
                color: "white"
                font.pointSize: 10
                anchors { top: parent.top; left: parent.left; margins: 20; leftMargin: 70; }
            }
            MouseArea { 
                anchors.fill: parent; 
                enabled: (root.state == "drawer") 
                onClicked: {
                    process.startDetached("./apps/webview.sh");
                }
                onPressAndHold: {
                    process.startDetached("./apps/terminal.sh");
                }
            }
        }

        model: shellSurfaces
        delegate: tabDelegate 
        highlight: Rectangle { 
            width: drawerWidth; height: drawerHeight + 10 
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
