import QtQuick

Item {
    Item {
        x: 0
        y: 0
        height: view.height
        width: 12

        MouseArea { 
            drag.target: parent; drag.axis: Drag.XAxis; drag.minimumX: 0; drag.maximumX: view.width
            anchors.fill: parent

            function getNextState() {
                if (root.state == "homeScreen")
                    return "notificationScreen";
                else if (root.state == "notificationScreen")
                    return "homeScreen";
                else if (root.state == "appScreen")
                    return "homeScreen";
                else return "";
            }

            onReleased: {
                if (root.state === "homeScreen" && homeScreen.searchFocus) {
                    if (parent.x > parent.width) {
                        homeScreen.forceTabFocus();
                        homeScreen.tabOpacity = 1;
                        homeScreen.globalSearchText = "";
                    } else {
                        homeScreen.tabOpacity = 0;
                    }
                } else {
                    let nextState = getNextState();
                    if (parent.x > parent.width) {
                        root.state = nextState;
                        eval(nextState).forceActiveFocus();
                    }
                    else { 
                        eval(root.state).opacity = 1; 
                        eval(nextState).opacity = 0;
                        if (root.state === "homeScreen")
                            wallpaperBlur.opacity = 0;
                        else wallpaperBlur.opacity = 1;
                    }
                }

                parent.x = 0;
            }

            onPositionChanged: {
                if (drag.active) {
                    if (root.state === "homeScreen" && homeScreen.searchFocus) {
                        homeScreen.tabOpacity = 2 * parent.x / view.width;
                        return;
                    }
                    let nextState = getNextState();
                    eval(root.state).opacity = 1 - 2 * parent.x / view.width 
                    eval(nextState).opacity = 2 * parent.x / view.width
                    if (root.state === "homeScreen")
                        wallpaperBlur.opacity = 2 * parent.x / view.width;
                    else if (nextState === "homeScreen")
                        wallpaperBlur.opacity = 1 - 2 * parent.x / view.width;
                }
            }
        }
    }

    Item {
        x: view.width - 12
        y: 0
        height: view.height
        width: 12

        MouseArea { 
            drag.target: parent; drag.axis: Drag.XAxis; drag.minimumX: 0; drag.maximumX: view.width - 12
            anchors.fill: parent

            function getNextState() {
                if (root.state == "homeScreen")
                    return "notificationScreen";
                else if (root.state == "notificationScreen")
                    return "homeScreen";
                else if (root.state == "appScreen")
                    return "homeScreen";
                else return "";
            }

            onReleased: {
                if (root.state === "homeScreen" && homeScreen.searchFocus) {
                    if (parent.x < view.width - 2 * parent.width) {
                        homeScreen.forceTabFocus();
                        homeScreen.tabOpacity = 1;
                        homeScreen.globalSearchText = "";
                    } else {
                        homeScreen.tabOpacity = 0;
                    }
                } else {
                    let nextState = getNextState();
                    if (parent.x < view.width - 2 * parent.width) { 
                        root.state = nextState;
                        eval(nextState).forceActiveFocus();
                    }
                    else { 
                        eval(root.state).opacity = 1; 
                        eval(nextState).opacity = 0;
                        if (root.state === "homeScreen")
                            wallpaperBlur.opacity = 0;
                        else wallpaperBlur.opacity = 1;
                    }
                }
                parent.x = view.width - 12;
            }

            onPositionChanged: {
                if (drag.active) {
                    if (root.state === "homeScreen" && homeScreen.searchFocus) {
                        homeScreen.tabOpacity = 2 - 2 * parent.x / view.width;
                        return;
                    }
                    let nextState = getNextState();
                    eval(root.state).opacity = 2 * parent.x / view.width - 1
                    eval(nextState).opacity = 2 - 2 * parent.x / view.width
                    if (root.state === "homeScreen")
                        wallpaperBlur.opacity = 2 - 2 * parent.x / view.width;
                    else if (nextState === "homeScreen")
                        wallpaperBlur.opacity = 2 * parent.x / view.width - 1;
                }
            }
        }
    }
}