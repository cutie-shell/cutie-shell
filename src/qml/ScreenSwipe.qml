import QtQuick 2.14

Item {
    Item {
        x: 0
        y: 0
        height: view.height
        width: 10 * shellScaleFactor

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
                let nextState = getNextState();
                if (parent.x > parent.width) {
                    root.state = nextState;
                    eval(nextState).forceActiveFocus();
                }
                else { 
                    eval(root.state).opacity = 1; 
                    eval(nextState).opacity = 0 
                }
                parent.x = 0;
            }

            onPositionChanged: {
                if (drag.active) {
                    let nextState = getNextState();
                    eval(root.state).opacity = 1 - parent.x / view.width 
                    eval(nextState).opacity = parent.x / view.width
                }
            }
        }
    }

    Item {
        x: view.width - 10 * shellScaleFactor
        y: 0
        height: view.height
        width: 10 * shellScaleFactor

        MouseArea { 
            drag.target: parent; drag.axis: Drag.XAxis; drag.minimumX: -5 * shellScaleFactor; drag.maximumX: view.width - 5 * shellScaleFactor
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
                let nextState = getNextState();
                if (parent.x < view.width - 2 * parent.width) { 
                    root.state = nextState;
                    eval(nextState).forceActiveFocus();
                }
                else { 
                    eval(root.state).opacity = 1; 
                    eval(nextState).opacity = 0 
                }
                parent.x = view.width - 10 * shellScaleFactor
            }

            onPositionChanged: {
                if (drag.active) {
                    let nextState = getNextState();
                    eval(root.state).opacity = parent.x / view.width 
                    eval(nextState).opacity = 1 - parent.x / view.width
                }
            }
        }
    }
}