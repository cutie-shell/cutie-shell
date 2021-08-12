import QtQuick 2.12
import QtGraphicalEffects 1.0

Rectangle {
    anchors.fill: parent
    opacity: 0
    z: 150
    color: "transparent"

    MouseArea { 
        enabled: root.state == "homeScreen"
        anchors.fill: parent
        onReleased: {
            root.state = "appScreen"
        }
    }
}