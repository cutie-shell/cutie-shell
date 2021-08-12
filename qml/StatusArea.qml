import QtQuick 2.14

MouseArea {
    enabled: settingsState.state != "opened"
    width: parent.width
    height: 5 * shellScaleFactor
    z: 400
    anchors {
        top: parent.top
    }
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
}
