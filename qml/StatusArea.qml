import QtQuick 2.14

MouseArea {
    width: parent.width
    height: 5 * shellScaleFactor
    z: 300
    anchors {
        top: parent.top
    }
    drag.target: settingSheet; drag.axis: Drag.YAxis; drag.minimumY: -view.height; drag.maximumY: 0
    onPressed: {
        if (settingSheet.y > -view.height / 2) { root.state = "normal" } else { root.state = "setting" }
    }
    onReleased: {
        if (settingSheet.y > -view.height / 2) { 
            root.state = "parked";
            root.state = "setting";
        } else { 
            root.state = "normal";
        }
    }
}
