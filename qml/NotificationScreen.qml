import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtWayland.Compositor 1.14

Rectangle {
    anchors.fill: parent
    opacity: 0
    z: 150
    color: "transparent"
    enabled: root.state == "notificationScreen"

    FastBlur {
        anchors.fill: parent
        source: realWallpaper
        radius: 70
    }

    Text {
        id: notificationHeader
        x: 20  * shellScaleFactor
        y: 30  * shellScaleFactor
        text: qsTr("Notifications")
        font.pixelSize: 14 * shellScaleFactor
        font.family: mainFont.name
        font.weight: Font.Black
        state: atmosphereVariant
        states: [
            State {
                name: "dark"
                PropertyChanges { target: notificationHeader; color: "#ffffff" }
            },
            State {
                name: "light"
                PropertyChanges { target: notificationHeader; color: "#000000" }
            }
        ]
        transitions: Transition {
            ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
        }
    }

    ListView {
        id: notificationList
        model: notifications
        orientation: ListView.Vertical
        anchors.fill: parent
        anchors.margins: 10 * shellScaleFactor
        anchors.topMargin: 50 * shellScaleFactor
        spacing: 10 * shellScaleFactor

        delegate: Rectangle {
            width: notificationList.width
            height: titleText.height + bodyText.height + 30 * shellScaleFactor * (1 - Math.abs(x/width))
            color: (atmosphereVariant == "dark") ? "#2fffffff" : "#4f000000"
            radius: 10 * shellScaleFactor
            opacity: 1 - Math.abs(x/width)

            MouseArea {
                anchors.fill: parent

                drag.target: parent
                drag.axis: Drag.XAxis

                onReleased: {
                    if (parent.x < - parent.width / 2 || parent.x > parent.width / 2) {
                        notifications.remove(index)
                    }
                    parent.x = 0
                }
            }

            Text {
                id: titleText
                text: title
                anchors.left: parent.left
                anchors.leftMargin: 10 * shellScaleFactor
                anchors.right: parent.right
                anchors.rightMargin: 10 * shellScaleFactor
                anchors.top: parent.top
                anchors.topMargin: 10 * shellScaleFactor * (1 - Math.abs(parent.x/parent.width))
                font.pixelSize: 10 * shellScaleFactor * (1 - Math.abs(parent.x/parent.width))
                font.family: mainFont.name
                font.weight: Font.Black
                wrapMode: Text.Wrap
                state: atmosphereVariant
                states: [
                    State {
                        name: "dark"
                        PropertyChanges { target: titleText; color: "#ffffff" }
                    },
                    State {
                        name: "light"
                        PropertyChanges { target: titleText; color: "#000000" }
                    }
                ]
                transitions: Transition {
                    ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                }
            }

            Text {
                id: bodyText
                text: body
                anchors.left: parent.left
                anchors.leftMargin: 10 * shellScaleFactor
                anchors.right: parent.right
                anchors.rightMargin: 10 * shellScaleFactor
                anchors.top: titleText.bottom
                anchors.topMargin: 10 * shellScaleFactor * (1 - Math.abs(parent.x/parent.width))
                font.pixelSize: 10 * shellScaleFactor * (1 - Math.abs(parent.x/parent.width))
                font.family: mainFont.name
                font.bold: false
                wrapMode: Text.Wrap
                state: atmosphereVariant
                states: [
                    State {
                        name: "dark"
                        PropertyChanges { target: bodyText; color: "#ffffff" }
                    },
                    State {
                        name: "light"
                        PropertyChanges { target: bodyText; color: "#000000" }
                    }
                ]
                transitions: Transition {
                    ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
                }
            }
        }
    }

    /*Item {
        x: 0
        y: 0
        z: 300
        height: parent.height
        width: parent.width

        MouseArea { 
            enabled: root.state == "notificationScreen"
            drag.target: parent; drag.axis: Drag.XAxis; drag.minimumX: -view.width; drag.maximumX: view.width
            anchors.fill: parent
            propagateComposedEvents: true

            property real _velocity: 0
            property real _oldMouseX: -1
            property real _initialX: 0

            onPressed: {
                _initialX = mouseX;
            }
            onReleased: {
                var velocityThreshold = 0.002 * shellScaleFactor;
                if (parent.x > view.width / 2) { root.state = "homeScreen" }
                else if (parent.x < -view.width / 2) { root.state = "homeScreen" }
                else if (mouseX > _initialX + view.width / 5 && _velocity > velocityThreshold) { root.state = "homeScreen" }
                else if (mouseX < _initialX - view.width / 5 && _velocity < -velocityThreshold) { root.state = "homeScreen" }
                else { parent.parent.opacity = 1; homeScreen.opacity = 0 }
                parent.x = 0
                _oldMouseX = 0;
            }
            onPositionChanged: {
                if (drag.active) {
                    parent.parent.opacity = 1 - Math.abs(parent.x)/ view.width 
                    homeScreen.opacity = Math.abs(parent.x) / view.width
                }
            }
            
            Timer {
                interval: 100; running: true; repeat: true
                onTriggered: {
                    parent._velocity = (parent.mouseX - parent._oldMouseX);
                    parent._oldMouseX = parent.mouseX;
                }
            }
        }
    }*/


    Item {
        x: 0
        y: 0
        z: 300
        height: parent.height
        width: 10 * shellScaleFactor

        MouseArea { 
            enabled: root.state == "notificationScreen"
            drag.target: parent; drag.axis: Drag.XAxis; drag.minimumX: 0; drag.maximumX: view.width
            anchors.fill: parent

            onReleased: {
                var velocityThreshold = 0.001 * shellScaleFactor;
                if (parent.x > parent.width) { root.state = "homeScreen" }
                else { parent.parent.opacity = 1; homeScreen.opacity = 0 }
                parent.x = 0
            }
            onPositionChanged: {
                if (drag.active) {
                    parent.parent.opacity = 1 - parent.x / view.width 
                    homeScreen.opacity = parent.x / view.width
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
            enabled: root.state == "notificationScreen"
            drag.target: parent; drag.axis: Drag.XAxis; drag.minimumX: -5 * shellScaleFactor; drag.maximumX: view.width - 5* shellScaleFactor
            anchors.fill: parent

            onReleased: {
                var velocityThreshold = 0.001 * shellScaleFactor;
                if (parent.x < parent.parent.width - 2 * parent.width) { root.state = "homeScreen" }
                else { parent.parent.opacity = 1; homeScreen.opacity = 0 }
                parent.x = view.width - 10 * shellScaleFactor
            }
            onPositionChanged: {
                if (drag.active) {
                    parent.parent.opacity = parent.x / view.width 
                    homeScreen.opacity = 1 - parent.x / view.width
                }
            }
        }
    }
}