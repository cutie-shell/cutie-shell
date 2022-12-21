import QtQuick 2.14
import QtGraphicalEffects 1.0

Item {
    x: 0
    y: parent.height - 20 * shellScaleFactor
    height: 20 * shellScaleFactor
    width: parent.width

    MouseArea { 
        drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: - 20 * shellScaleFactor; drag.maximumY: view.height - 20 * shellScaleFactor
        enabled: (launcherState.state != "opened") && (screenLockState.state == "opened") && (settingsState.state == "closed")
        anchors.fill: parent

        onPressed: {
            launcherState.state = "opening";
            launcherSheet.setLauncherContainerState("opening");
        }

        onReleased: {
            var velocityThreshold = 0.002 * shellScaleFactor;

            if (parent.y < view.height - 2 * parent.height) { 
                launcherState.state = "opened"
                launcherSheet.setLauncherContainerState("opened");
            }
            else { 
                launcherState.state = "closed"
                launcherSheet.setLauncherContainerState("closed");
            }
            parent.y = parent.parent.height - 20 * shellScaleFactor;
        }

        onPositionChanged: {
            if (drag.active) {
                launcherSheet.opacity = 1/2 - parent.y / view.height / 2;
                launcherSheet.setLauncherContainerY(parent.y);
            }
        }
    }
}