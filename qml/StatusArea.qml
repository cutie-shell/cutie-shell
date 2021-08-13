import QtQuick 2.14

Rectangle {
    width: parent.width
    height: 20 * shellScaleFactor
    z: 400
    anchors.top: parent.top
    color: "transparent"

    Image {
        id: image1
        anchors.right: parent.right
        anchors.rightMargin: 12 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        width: 15 * shellScaleFactor
        height: 15 * shellScaleFactor
        source: "icons/network-wireless-signal-good-symbolic.svg"
        sourceSize.height: 400
        sourceSize.width: 400
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: image2
        anchors.right: image1.left
        anchors.rightMargin: 4 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        width: 15 * shellScaleFactor
        height: 15 * shellScaleFactor
        source: "icons/network-cellular-signal-good.svg"
        sourceSize.height: 128
        sourceSize.width: 128
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: text13
        anchors.right: image2.left
        anchors.rightMargin: 4 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        color: "#ffffff"
        text: qsTr("4G")
        font.pixelSize: 9 * shellScaleFactor
        font.bold: false
    }

    Image {
        id: image3
        anchors.left: text15.right
        anchors.leftMargin: 4 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        width: 15 * shellScaleFactor
        height: 15 * shellScaleFactor
        source: "icons/battery-070.svg"
        sourceSize.height: 128
        sourceSize.width: 128
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: text14
        anchors.left: image3.right
        anchors.leftMargin: 4 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        color: "#ffffff"
        text: qsTr("75%")
        font.pixelSize: 9 * shellScaleFactor
        font.bold: false
    }

    Text {
        id: text15
        anchors.left: parent.left
        anchors.leftMargin: 12 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        color: "#ffffff"
        text: qsTr("17:46")
        font.pixelSize: 9 * shellScaleFactor
        font.bold: false
    }

    Item {
        x: 0
        y: 0
        height: parent.height
        width: parent.width
        z: 100

        MouseArea { 
            enabled: (settingsState.state != "opened") && (screenLockState.state == "opened")
            drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: 0; drag.maximumY: view.height
            anchors.fill: parent

            onReleased: {
                if (parent.y > view.height / 2) { 
                    settingsState.state = "opened"
                    settingSheet.setSettingContainerState("opened");
                }
                else { 
                    settingsState.state = "closed"
                    settingSheet.setSettingContainerState("closed");
                }
                parent.y = 0
            }

            onPressed: {
                settingsState.state = "opening";
                settingSheet.setSettingContainerState("opening");
            }

            onPositionChanged: {
                if (drag.active) {
                    settingSheet.opacity = parent.y / view.height;
                    settingSheet.setSettingContainerY(parent.y - view.height);
                }
            }
        }
    }

    /*MouseArea {
        enabled: (settingsState.state != "opened") && (screenLockState.state == "opened")
        anchors.fill: parent
        drag.target: settingSheet; drag.axis: Drag.YAxis; drag.minimumY: -view.height; drag.maximumY: 0

        onPressed: {
            settingsState.state = "opening";
        }

        onReleased: {
            if (settingSheet.y > -view.height / 2) { 
                settingsState.state = "opened";
            } else { 
                settingsState.state = "closed";
            }
        }
    }*/
}