import QtQuick 2.14
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0

// launcher sheet 
Rectangle {
    id: launcherSheet
    width: view.width
    height: view.height
    z: 450
    opacity: 0
    color: "transparent"
    y: view.height

    function setLauncherContainerY(y) {
        launcherContainer.y = y;
    }

    function setLauncherContainerState(state) {
        launcherContainer.state = state;
    }

    Item {
        x: 0
        y: 0
        z: 100
        height: 10 * shellScaleFactor
        width: parent.width

        MouseArea { 
            enabled: launcherState.state != "closed"
            drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: 0; drag.maximumY: view.height
            anchors.fill: parent

            onReleased: {
                if (parent.y > parent.height) { 
                    launcherState.state = "closed"
                    launcherContainer.state = "closed"
                }
                else { 
                    launcherState.state = "opened"
                    launcherContainer.state = "opened"
                }
                parent.y = 0
            }

            onPositionChanged: {
                if (drag.active) {
                    launcherSheet.opacity = 1 - parent.y / view.height / 2
                    launcherContainer.y = parent.y
                }
            }

            onPressed: {
                launcherState.state = "closing";
                launcherContainer.state = "closing";
                launcherContainer.y = 0;
            }
        }
    }

    FastBlur {
        anchors.fill: parent
        source: realWallpaper
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        radius: 90

        Rectangle {
            anchors.fill: parent
            color: (atmosphereVariant == "dark") ? "#80000000" : "#80ffffff"
        }

        Item {
            id: launcherContainer
            y: /*view.height*/0
            height: parent.height
            width: parent.width

            state: "closed"

            states: [
                State {
                    name: "opened"
                    PropertyChanges { target: launcherContainer; y: 0 }
                },
                State {
                    name: "closed"
                    PropertyChanges { target: launcherContainer; y: view.height }
                },
                State {
                    name: "opening"
                    PropertyChanges { target: launcherContainer; y: view.height }
                },
                State {
                    name: "closing"
                    PropertyChanges { target: launcherContainer; y: 0 }
                }
            ]

            transitions: Transition {
                to: "*"
                NumberAnimation { target: launcherContainer; properties: "y"; duration: 300; easing.type: Easing.InOutQuad; }
            }

            GridView {
                id: launchAppGrid
                anchors.fill: parent
                anchors.topMargin: 5 * shellScaleFactor
                model: launcherApps
                cellWidth: view.width / 4
                cellHeight: view.width / 4

                property real tempContentY: 0
                property bool refreshing: false


                onAtYBeginningChanged: {
                    if(atYBeginning){
                        tempContentY = contentY
                    }
                }

                onContentYChanged: {
                    if(atYBeginning){
                        if(Math.abs(tempContentY - contentY) > 40 * shellScaleFactor){
                            if(refreshing){
                                return;
                            } else {
                                refreshing = true               
                            }
                        }
                    }
                }

                onMovementEnded: {
                    if (refreshing) {
                        launcherApps.clear();
                        settings.loadAppList();
                        refreshing = false     
                    }
                }

                delegate: Item {
                    Button {
                        id: appIconButton
                        height: view.width / 4
                        width: view.width / 4
                        icon.name: appIcon
                        icon.color: "transparent"
                        icon.height: view.width / 8
                        icon.width: view.width / 8
                        background: Rectangle {
                            color: "transparent"
                        }

                        onClicked: {
                            settings.execApp(appExec);
                            launcherState.state = "closed"
                            launcherContainer.state = "closed"
                        }
                    }
                    Text {
                        anchors.bottom: appIconButton.bottom
                        anchors.horizontalCenter: appIconButton.horizontalCenter
                        text: appName
                        font.pixelSize: 7 * shellScaleFactor
                        clip: true
                        font.family: "Lato"
                        color: (atmosphereVariant == "dark") ? "#ffffff" : "#000000"
                    }
                }
            }
        }
    }
}
