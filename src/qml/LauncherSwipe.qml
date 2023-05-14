import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    x: 0
    y: parent.height - 20
    height: 20
    width: parent.width

    MouseArea { 
        drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: - 20; drag.maximumY: view.height - 20
        enabled: (launcherState.state != "opened") && (screenLockState.state == "opened") && (settingsState.state == "closed")
        anchors.fill: parent

        onPressed: {
            launcherState.state = "opening";
            launcherSheet.setLauncherContainerState("opening");
        }

        onReleased: {
            var velocityThreshold = 0.002;

            if (parent.y < view.height - 2 * parent.height) { 
                launcherState.state = "opened"
                launcherSheet.setLauncherContainerState("opened");
                wallpaperBlur.opacity = 1;
            }
            else { 
                launcherState.state = "closed"
                launcherSheet.setLauncherContainerState("closed");
                if (root.state === "homeScreen")
                    wallpaperBlur.opacity = 0;
            }
            parent.y = parent.parent.height - 20 ;
        }

        onPositionChanged: {
            if (drag.active) {
                launcherSheet.opacity = 2 - 2 * parent.y / view.height;
                launcherSheet.setLauncherContainerY(parent.y);
                mainViewContainer.opacity = parent.y / view.height;
                if (root.state === "homeScreen")
                    wallpaperBlur.opacity = 1 - parent.y / view.height;
            }
        }
    }
}