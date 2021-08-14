import QtQuick 2.14
import QtGraphicalEffects 1.0

Item {
    x: 0
    y: view.height - height
    height: 5 * shellScaleFactor
    width: view.width
    z: 400

    MouseArea { 
        enabled: (launcherState.state != "opened") && (screenLockState.state == "opened") && (settingsState.state == "closed")
        drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: 0; drag.maximumY: view.height
        anchors.fill: parent

        onReleased: {
            if (parent.y < view.height / 2) { 
                launcherState.state = "opened"
                launcherSheet.setLauncherContainerState("opened");
            }
            else { 
                launcherState.state = "closed"
                launcherSheet.setLauncherContainerState("closed");
            }
            parent.y = view.height - parent.height
        }

        onPressed: {
            launcherState.state = "opening";
            launcherSheet.setLauncherContainerState("opening");
        }

        onPositionChanged: {
            if (drag.active) {
                launcherSheet.opacity = 1/2 - parent.y / view.height / 2;
                launcherSheet.setLauncherContainerY(parent.y);
            }
        }
    }
}