import QtQuick
import Qt5Compat.GraphicalEffects
import QtWayland.Compositor
import QtQuick.Controls
import Cutie

Item {
    id: homeScreen
    anchors.fill: parent
    opacity: 0
    enabled: root.state == "homeScreen"

    property alias searchFocus: globalSearch.focus
    property alias tabOpacity: tabListView.opacity
    property alias globalSearchText: globalSearch.text

    function forceTabFocus() {
        tabListView.forceActiveFocus();
    }

    GridView {
        id: tabListView
        anchors.fill: parent
        anchors.topMargin: 70
        model: shellSurfaces
        cellWidth: view.width / 2 - 5
        cellHeight: view.height / 2 + 20
        opacity: globalSearch.focus ? 0.0 : 1.0
        z: 1

        Behavior on opacity {
            PropertyAnimation { duration: 300 }
        }

        delegate: Item {
            id: appThumb
            width: tabListView.cellWidth
            height: tabListView.cellHeight

            Item {
                id: appBg
                width: appThumb.width - 20
                height: appThumb.height - 20
                x: 10

                Item {
                    id: tileBlurMask
                    anchors.fill: tileBlur
                    clip: true
                    visible: false
                    Rectangle {
                        width: appBg.width
                        height: appBg.height
                        x: appThumb.x+appBg.x+tabListView.x-tabListView.contentX
                        y: appThumb.y+appBg.y+tabListView.y-tabListView.contentY
                        color: "black"
                        radius: 10
                    }
                }

                FastBlur {
                    id: tileBlur
                    width: homeScreen.width
                    height: homeScreen.height
                    x: tabListView.contentX-appThumb.x-appBg.x-tabListView.x
                    y: tabListView.contentY-appThumb.y-appBg.y-tabListView.y
                    source: realWallpaper
                    radius: 70
                    visible: false
                }

                Item {
                    id: appRoundMask
                    anchors.fill: parent
                    anchors.bottomMargin: 25
                    clip: true
                    visible: false
                    Rectangle {
                        anchors.fill: parent
                        anchors.bottomMargin: -25
                        color: "black"
                        radius: 10
                    }
                }

                WaylandQuickItem {
                    id: appPreview
                    anchors.fill: parent
                    anchors.bottomMargin: 25
                    surface: modelData.surface
                    inputEventsEnabled: false
                    clip: true
                    visible: false
                    onSurfaceDestroyed: shellSurfaces.remove(index)

                    Component.onCompleted: {
                        if (modelData.toplevel) {
                            modelData.toplevel.sendMaximized(Qt.size(view.width, view.height - 30))
                        }

                        if (modelData.sendConfigure) {
                            modelData.sendConfigure(Qt.size(view.width, view.height - 30), 0);
                        }

                        appScreen.shellSurface = modelData;
                        appScreen.shellSurfaceIdx += 1;
                        root.oldState = root.state;
                        root.state = "appScreen";
                    }
                }

                OpacityMask {
                    anchors.fill: tileBlur
                    source: tileBlur
                    maskSource: tileBlurMask
                }

                Rectangle {
                    color: Atmosphere.secondaryAlphaColor
                    anchors.fill: appBg
                    opacity: 1/3
                    radius: 10
                }

                OpacityMask {
                    anchors.fill: appPreview
                    source: appPreview
                    maskSource: appRoundMask
                }

                Item {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 25
                    clip: true

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 50
                        radius: 10
                        color: Atmosphere.primaryColor
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 7
                        color: Atmosphere.textColor
                        text: modelData.toplevel.title
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        font.family: "Lato"
                        font.bold: false
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    drag.target: appBg; drag.axis: Drag.XAxis; drag.minimumX: -parent.width; drag.maximumX: parent.width
                    onClicked: {
                        root.state = "appScreen";
                        appScreen.shellSurface = modelData;
                        appScreen.shellSurfaceIdx = index;
                    }

                    onReleased: {
                        if (Math.abs(appBg.x - 10) > parent.width / 3) {
                            if (modelData.toplevel)
                                modelData.toplevel.sendClose();
                            else modelData.surface.destroy();
                            if (appScreen.shellSurfaceIdx == index){
                                if (shellSurfaces.count != 1) {
                                    if (index == shellSurfaces.count - 1) {
                                        appScreen.shellSurface = shellSurfaces.get(index + 1).shellSurface;
                                        appScreen.shellSurfaceIdx = index + 1;
                                    } else {
                                        appScreen.shellSurface = shellSurfaces.get(index - 1).shellSurface;
                                        appScreen.shellSurfaceIdx = index - 1;
                                    }
                                } else {
                                    appScreen.shellSurface = null;
                                    appScreen.shellSurfaceIdx = -1;
                                }
                            }
                        }
                        else { 
                            appThumb.opacity = 1;
                        }
                        appBg.x = 10;
                    }

                    onPositionChanged: {
                        if (drag.active) {
                            appThumb.opacity = 1 - Math.abs(appBg.x - 10) / parent.width 
                        }
                    }
                }
            }
        }
    } 

    ListModel { id: searchResults }
    
    Rectangle {
        id: searchRect
        y: 50 + tabListView.opacity * (parent.y + parent.height - 150)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        color: Atmosphere.primaryColor
        radius: 10
        height: 70
        z: 3
        
        Behavior on y {
            PropertyAnimation { duration: 300 }
        }

        TextField {
            id: globalSearch
            color: Atmosphere.textColor
            clip: true
            font.family: "Lato"
            font.pixelSize: 15 
            padding: 10
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20
            inputMethodHints: Qt.ImhNoPredictiveText

            onFocusChanged: {
                tabListView.opacity = focus ? 0 : 1;
            }

            background: Rectangle {
                id: backgroundRect
                anchors.bottom: parent.bottom
                height: 3
                x: 5
                width: parent.width - 10
                radius: 2
                opacity: parent.focus ? 1.0 : 0.5
                color: Atmosphere.textColor
            }

            onTextChanged: {
                searchResults.clear();
                if (text === "") return;

                for (let i = 0; i < launcherApps.count; i++) {
                    let addApp = () => {
                        searchResults.append({
                            displayText: launcherApps.get(i)["Desktop Entry/Name"],
                            appExec: launcherApps.get(i)["Desktop Entry/Exec"],
                        });
                    };

                    if (launcherApps.get(i)["Desktop Entry/Name"].includes(text)) {
                        addApp();
                        continue;
                    }

                    if (launcherApps.get(i)["Desktop Entry/GenericName"])
                    if (launcherApps.get(i)["Desktop Entry/GenericName"].includes(text)) {
                        addApp();
                        continue;
                    }

                    if (launcherApps.get(i)["Desktop Entry/Comment"])
                    if (launcherApps.get(i)["Desktop Entry/Comment"].includes(text)) { 
                        addApp();
                        continue;
                    }
                    
                    if (launcherApps.get(i)["Desktop Entry/Categories"]) {
                        let keys = launcherApps.get(i)["Desktop Entry/Categories"].split(";");
                        for (let k of keys) {
                            if (k.includes(text)) {
                                addApp();
                                break;
                            }
                        }
                    }
                }

                let tokens = text.split(" ");
                tokens.forEach(t => {
                    console.log(t);
                    if (/^[\+]?[(]?[0-9]*[)]?[-\.]?[0-9]*[-\.]?[0-9]*$/.test(t)) {
                        searchResults.append({
                            displayText: "Call " + t,
                            phoneCall: t,
                        });
                        searchResults.append({
                            displayText: "SMS " + t,
                            sms: t,
                        });
                    }
                });
            }
        }
    }

    Rectangle {
        anchors.top: searchRect.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        opacity: 1 - tabListView.opacity
        z: 3
        color: Atmosphere.primaryColor
        radius: 10
        height: inputPanel.y - y - 20
        clip: true

        ListView {
            id: searchView
            anchors.fill: parent
            model: searchResults
            anchors.topMargin: 20
            anchors.bottomMargin: 20
            
            delegate: Button { 
                id: searchResBtn
                height: 40
                width: searchView.width
                focusPolicy: Qt.NoFocus

                onClicked: {
                    if (model.appExec) settings.execApp(model.appExec);
                    if (model.phoneCall) settings.execApp("cutie-phone " + model.phoneCall);
                    if (model.sms) settings.execApp("cutie-messaging " + model.sms);
                    tabListView.forceActiveFocus();
                    tabListView.opacity = 1;
                    globalSearch.text = "";
                }

                background: Rectangle {
                    anchors.fill: searchResBtn
                    color: searchResBtn.down ? Atmosphere.secondaryColor : "transparent"
                }

                contentItem: Text {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    text: displayText
                    font.pixelSize: 15
                    clip: true
                    font.family: "Lato"
                    color: Atmosphere.textColor
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
