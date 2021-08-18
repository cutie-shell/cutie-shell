import QtQuick 2.14
import QtGraphicalEffects 1.0

Rectangle {
    width: parent.width
    height: 20 * shellScaleFactor
    z: 400
    anchors.top: parent.top
    color: "transparent"

    Rectangle
    {
        id: maskRect2
        width: 15 * shellScaleFactor
        height: 15 * shellScaleFactor
        visible: false
        state: atmosphereVariant
        states: [
            State {
                name: "dark"
                PropertyChanges { target: maskRect2; color: "#ffffff" }
            },
            State {
                name: "light"
                PropertyChanges { target: maskRect2; color: "#000000" }
            }
        ]
        transitions: Transition {
            ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
        }
    }

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
        visible: false
    }

    OpacityMask {
        anchors.fill: image1
        source: maskRect2
        maskSource: image1
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
        visible: false
    }

    OpacityMask {
        anchors.fill: image2
        source: maskRect2
        maskSource: image2
    }

    Text {
        id: text13
        anchors.right: image2.left
        anchors.rightMargin: 4 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        color: (atmosphereVariant == "dark") ? "#ffffff" : "#000000"
        text: qsTr("4G")
        font.pixelSize: 9 * shellScaleFactor
        font.bold: false
        state: atmosphereVariant
        states: [
            State {
                name: "dark"
                PropertyChanges { target: clockText; color: "#ffffff" }
            },
            State {
                name: "light"
                PropertyChanges { target: clockText; color: "#000000" }
            }
        ]
        transitions: Transition {
            ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
        }
        font.family: mainFont.name
    }

    Image {
        id: image3
        anchors.left: clockText.right
        anchors.leftMargin: 4 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        width: 15 * shellScaleFactor
        height: 15 * shellScaleFactor
        source: ((batteryStatus.Percentage == 100) ? "icons/battery-100-charged.svg" : 
            ((batteryStatus.State === 1) ? ((batteryStatus.Percentage > 70) ? "icons/battery-070-charging.svg" : 
            ((batteryStatus.Percentage > 50) ? "icons/battery-050-charging.svg": "icons/battery-010-charging.svg")) : 
            ((batteryStatus.Percentage > 90) ? "icons/battery-090.svg" : ((batteryStatus.Percentage > 70) ? "icons/battery-070.svg" : 
            ((batteryStatus.Percentage > 50) ? "icons/battery-050.svg" : ((batteryStatus.Percentage > 30) ? "icons/battery-030.svg" :
            "icons/battery-010.svg"))))))
        sourceSize.height: 128
        sourceSize.width: 128
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    OpacityMask {
        anchors.fill: image3
        source: maskRect2
        maskSource: image3
    }

    Text {
        id: text14
        anchors.left: image3.right
        anchors.leftMargin: 4 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        text: batteryStatus.Percentage.toString() + " %"
        font.pixelSize: 9 * shellScaleFactor
        font.bold: false
        state: atmosphereVariant
        states: [
            State {
                name: "dark"
                PropertyChanges { target: text14; color: "#ffffff" }
            },
            State {
                name: "light"
                PropertyChanges { target: text14; color: "#000000" }
            }
        ]
        transitions: Transition {
            ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
        }
        font.family: mainFont.name
    }

    Text {
        id: clockText
        anchors.left: parent.left
        anchors.leftMargin: 12 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        width: 25 * shellScaleFactor
        text: Qt.formatDateTime(new Date(), "HH:mm")
        font.pixelSize: 9 * shellScaleFactor
        font.bold: false
        state: atmosphereVariant
        states: [
            State {
                name: "dark"
                PropertyChanges { target: clockText; color: "#ffffff" }
            },
            State {
                name: "light"
                PropertyChanges { target: clockText; color: "#000000" }
            }
        ]
        transitions: Transition {
            ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
        }
        font.family: mainFont.name
    }

    function timeChanged() {
        clockText.text = Qt.formatDateTime(new Date(), "HH:mm");
    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: timeChanged()
    }

    Item {
        x: 0
        y: 0
        z: 100
        height: parent.height
        width: parent.width

        MouseArea { 
            enabled: (settingsState.state != "opened") && (screenLockState.state == "opened")
            drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: 0; drag.maximumY: view.height
            anchors.fill: parent

            onReleased: {
                if (parent.y > parent.height) { 
                    settingsState.state = "opened"
                    settingSheet.setSettingContainerState("opened");
                }
                else { 
                    settingsState.state = "closed"
                    settingSheet.setSettingContainerState("closed");
                }
                parent.y = 0
            }
            
            onPositionChanged: {
                if (drag.active) {
                    settingSheet.opacity = parent.y / view.height / 2;
                    settingSheet.setSettingContainerY(parent.y - view.height);
                }
            }

            onPressed: {
                settingsState.state = "opening";
                settingSheet.setSettingContainerState("opening");
            }
        }
    }
}