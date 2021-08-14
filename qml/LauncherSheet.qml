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
        height: 5 * shellScaleFactor
        width: parent.width
        z: 100

        MouseArea { 
            enabled: launcherState.state != "closed"
            drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: 0; drag.maximumY: view.height
            anchors.fill: parent

            onReleased: {
                if (parent.y < view.height / 2) { 
                    launcherState.state = "opened"
                    launcherContainer.state = "opened"
                }
                else { 
                    launcherState.state = "closed"
                    launcherContainer.state = "closed"
                }
                parent.y = 0
            }

            onPressed: {
                launcherState.state = "closing";
                launcherContainer.state = "closing";
                launcherContainer.y = 0;
            }

            onPositionChanged: {
                if (drag.active) {
                    launcherSheet.opacity = 1 - parent.y / view.height 
                    launcherContainer.y = parent.y
                }
            }
        }
    }

    FastBlur {
        anchors.fill: parent
        source: wallpaper
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
                delegate: Item {
                    Button {
                        id: appIconButton
                        height: view.width / 4
                        width: view.width / 4
                        icon.name: appIcon
                        icon.color: "transparent"
                        icon.height: view.width / 6
                        icon.width: view.width / 6
                        background: Rectangle {
                            color: "transparent"
                        }

                        onClicked: {
                            settings.execApp(appExec);
                            root.state = "appScreen"
                            launcherState.state = "closed"
                            launcherContainer.state = "closed"
                        }
                    }
                    Text {
                        anchors.bottom: appIconButton.bottom
                        anchors.horizontalCenter: appIconButton.horizontalCenter
                        text: appName
                        font.pixelSize: 7 * shellScaleFactor
                        font.family: "Lato"
                        font.weight: Font.Light
                        clip: true
                        color: (atmosphereVariant == "dark") ? "#ffffff" : "#000000"
                    }
                }
            }
        }
    }
}
