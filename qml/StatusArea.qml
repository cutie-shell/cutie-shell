import QtQuick 2.14
import QtGraphicalEffects 1.0

Rectangle {
    width: parent.width
    height: 30 * shellScaleFactor
    anchors.top: parent.top
    color: "transparent"

    function setCellularStrength(strength) {
        if (strength > 80) {
            image2.source = "icons/network-cellular-signal-excellent.svg"
        } else if (strength > 50) {
            image2.source = "icons/network-cellular-signal-good.svg"
        } else if (strength > 30) {
            image2.source = "icons/network-cellular-signal-ok.svg"
        } else if (strength > 10) {
            image2.source = "icons/network-cellular-signal-low.svg"
        } else {
            image2.source = "icons/network-cellular-signal-none.svg"
        }
    }

    function setWifiStrength(strength) {
        if (strength > 80) {
            image1.source = "icons/network-wireless-signal-excellent-symbolic.svg"
        } else if (strength > 50) {
            image1.source = "icons/network-wireless-signal-good-symbolic.svg"
        } else if (strength > 30) {
            image1.source = "icons/network-wireless-signal-ok-symbolic.svg"
        } else if (strength > 10) {
            image1.source = "icons/network-wireless-signal-low-symbolic.svg"
        } else {
            image1.source = "icons/network-wireless-signal-none-symbolic.svg"
        }
    }

    Rectangle
    {
        id: maskRect2
        width: 10 * shellScaleFactor
        height: 10 * shellScaleFactor
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
        anchors.right: image3.left
        anchors.rightMargin: 4 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        width: 13 * shellScaleFactor
        height: 13 * shellScaleFactor
        source: "icons/network-wireless-signal-none-symbolic.svg"
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
        width: 13 * shellScaleFactor
        height: 13 * shellScaleFactor
        source: "icons/network-cellular-signal-none.svg"
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

    Image {
        id: image3
        anchors.right: text14.left
        anchors.rightMargin: 4 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        width: 13 * shellScaleFactor
        height: 13 * shellScaleFactor
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
        anchors.right: parent.right
        anchors.rightMargin: 12 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        text: batteryStatus.Percentage.toString() + " %"
        font.pixelSize: 12 * shellScaleFactor
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
        font.family: "Lato"
    }

    Text {
        id: clockText
        anchors.left: parent.left
        anchors.leftMargin: 12 * shellScaleFactor
        anchors.verticalCenter: parent.verticalCenter
        width: 25 * shellScaleFactor
        text: Qt.formatDateTime(new Date(), "HH:mm")
        font.pixelSize: 12 * shellScaleFactor
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
        font.family: "Lato"
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