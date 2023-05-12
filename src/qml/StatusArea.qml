import QtQuick
import Qt5Compat.GraphicalEffects
import Cutie

Item {
    width: parent.width
    height: 30
    anchors.top: parent.top

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
    
    function modemDataChangeHandler(data) {
        if (!data.Online || !data.Powered) {
            image2.source = "icons/network-cellular-offline.svg"
        }
    }

    function modemNetDataChangeHandler(netData) {
        if (netData.Status === "unregistered"
            || netData.Status === "denied") {
            image2.source = "icons/network-cellular-offline.svg"
        } else if (netData.Status === "searching") {
            image2.source = "icons/network-cellular-no-route.svg"
        } else {
            if (netData.Strength > 80) {
                image2.source = "icons/network-cellular-signal-excellent.svg"
            } else if (netData.Strength > 50) {
                image2.source = "icons/network-cellular-signal-good.svg"
            } else if (netData.Strength > 30) {
                image2.source = "icons/network-cellular-signal-ok.svg"
            } else if (netData.Strength > 10) {
                image2.source = "icons/network-cellular-signal-low.svg"
            } else {
                image2.source = "icons/network-cellular-signal-none.svg"
            }
        }
    }

    function wirelessDataChangeHandler(wData) {
        if (wData.Strength > 80) {
            image1.source = "icons/network-wireless-signal-excellent-symbolic.svg"
        } else if (wData.Strength > 50) {
            image1.source = "icons/network-wireless-signal-good-symbolic.svg"
        } else if (wData.Strength > 30) {
            image1.source = "icons/network-wireless-signal-ok-symbolic.svg"
        } else if (wData.Strength > 10) {
            image1.source = "icons/network-wireless-signal-low-symbolic.svg"
        } else {
            image1.source = "icons/network-wireless-signal-none-symbolic.svg"
        }
    }

    function wirelessActiveAccessPointHandler(activeAccessPoint) {
        if (activeAccessPoint) {
            let wData = CutieWifiSettings.activeAccessPoint.data;
            wirelessDataChangeHandler(wData);
            CutieWifiSettings.activeAccessPoint.dataChanged.connect(wirelessDataChangeHandler);
        } else image1.source = "icons/network-wireless-offline.svg";
    }

    function wirelessEnabledChangedHandler(wirelessEnabled) {
        if (!wirelessEnabled) {
            image1.source = "icons/network-wireless-offline.svg";
        }
    }

    Component.onCompleted: {
        if (CutieWifiSettings.wirelessEnabled) {
            if (CutieWifiSettings.activeAccessPoint) {
                let wData = CutieWifiSettings.activeAccessPoint.data;

                wirelessDataChangeHandler(wData);
                CutieWifiSettings.activeAccessPoint.dataChanged.connect(wirelessDataChangeHandler);
            } else {
                wirelessActiveAccessPointHandler(null);
            }
        } else {
            wirelessEnabledChanged(false);
        }

        CutieWifiSettings.activeAccessPointChanged.connect(wirelessActiveAccessPointHandler);
        CutieWifiSettings.wirelessEnabledChanged.connect(wirelessEnabledChangedHandler);

        let modems = CutieModemSettings.modems;
        let data = modems[0].data;
        if (!data.Online || !data.Powered) {
            image2.source = "icons/network-cellular-offline.svg";
            CutieModemSettings.modems[0].dataChanged.connect(modemDataChangeHandler);
            CutieModemSettings.modems[0].netDataChanged.connect(modemNetDataChangeHandler);
            return;
        }
        let netData = modems[0].netData;
        if (netData.Strength > 80) {
            image2.source = "icons/network-cellular-signal-excellent.svg"
        } else if (netData.Strength > 50) {
            image2.source = "icons/network-cellular-signal-good.svg"
        } else if (netData.Strength > 30) {
            image2.source = "icons/network-cellular-signal-ok.svg"
        } else if (netData.Strength > 10) {
            image2.source = "icons/network-cellular-signal-low.svg"
        } else {
            image2.source = "icons/network-cellular-signal-none.svg"
        }

        CutieModemSettings.modems[0].dataChanged.connect(modemDataChangeHandler);
        CutieModemSettings.modems[0].netDataChanged.connect(modemNetDataChangeHandler);
    }

    Rectangle
    {
        id: maskRect2
        width: 10
        height: 10
        visible: false
        color: Atmosphere.textColor
        transitions: Transition {
            ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
        }
    }

    Image {
        id: image1
        anchors.right: image2.left
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        width: 13
        height: 13
        source: "icons/network-wireless-offline.svg"
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
        anchors.right: image3.left
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        width: 13
        height: 13
        source: "icons/network-cellular-offline.svg"
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
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        width: 13
        height: 13
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
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        text: Math.floor(batteryStatus.Percentage).toString() + " %"
        font.pixelSize: 12
        font.bold: false
        color: Atmosphere.textColor
        transitions: Transition {
            ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
        }
        font.family: "Lato"
    }

    Text {
        id: clockText
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        width: 25
        text: Qt.formatDateTime(new Date(), "HH:mm")
        font.pixelSize: 12
        font.bold: false
        color: Atmosphere.textColor
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
                    settingSheet.opacity = 2 * parent.y / view.height;
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