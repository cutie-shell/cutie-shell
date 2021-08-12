import QtQuick 2.14
import QtWayland.Compositor 1.14
import QtGraphicalEffects 1.0

Rectangle {
    id: sidebar
     x: 0
     y: 0
    z: 200
    property alias tabListView: tabListView
    width: view.width
    height: view.height 
   // anchors { left: parent.left; top: parent.top }
    color: "#2E3440"

    MouseArea { 
        enabled: root.state == "drawer"
        drag.target: parent; drag.axis: Drag.XAxis; drag.minimumX: -view.width; drag.maximumX: 0
        width: 5 * shellScaleFactor
        height: view.height
        z: 100
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        onPressed: {
            if (parent.x > -view.width / 2) { root.state = "normal" } else { root.state = "drawer" }
        }
        onReleased: {
            if (parent.x > -view.width / 2) { root.state = "drawer" } else { 
                root.state = "parked";
                root.state = "normal";
            }
        }
    }


    Image {
        id: ui
        x: 0
        anchors.fill: parent
        source: "file://usr/share/atmospheres/Current/wallpaper.jpg"
        sourceSize.height: 2000
        sourceSize.width: 800
        fillMode: Image.PreserveAspectCrop
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
                    enabled: (root.state == "drawer") 
                    onClicked: { 
                        tabListView.currentIndex = index
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
                            onClicked: modelData.surface.client.close()
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

        onCurrentIndexChanged: {
            shellSurfaces.get(currentIndex).shellSurface.toplevel.sendConfigure(Qt.size(view.width, view.height), [ XdgToplevel.NoneEdge ]);
        }

        header: Rectangle { 
            width: view.width
            height: 40*shellScaleFactor
            color: "transparent"
            Text { 
                text: "\uF067"; font.family: icon.name; color: "white"; font.pointSize: 3*shellScaleFactor
                anchors { top: parent.top; left: parent.left; margins: 10*shellScaleFactor; leftMargin: 15*shellScaleFactor }
            }
            Text { 
                text: "<b>New Tab</b>"
                color: "white"
                font.pointSize: 3*shellScaleFactor
                anchors { top: parent.top; left: parent.left; margins: 10*shellScaleFactor; leftMargin: 35*shellScaleFactor; }
            }
            MouseArea { 
                anchors.fill: parent; 
                enabled: (root.state == "drawer") 
                onClicked: {
                    process.startDetached(".apps/test.sh");
                }
                onPressAndHold: {
                    process.startDetached("./apps/terminal.sh");
                }
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
