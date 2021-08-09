import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Material 2.1
import QtGraphicalEffects 1.0

ApplicationWindow{
    visible: true
    width: 480
    height: 800
    id: rootWindow

     visibility: Window.FullScreen
     flags: Qt.BypassWindowManagerHint | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint

    color: "transparent"
 background: Rectangle{
     Image {
                id: ui
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                source: "/../wallpaper.jpg"
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                sourceSize.height: 2000
                sourceSize.width: 800
                fillMode: Image.Pad
            }
            FastBlur {
                anchors.fill: ui
                source: ui
                anchors.rightMargin: 0
                 anchors.leftMargin: 0
                anchors.topMargin: 0
                radius: 90
                visible: false
            }
    }

    //id: rootWindow
    property int columns: 3



header: ToolBar {
        height: rootWindow.height * 0.1
       background: Item{}

       Rectangle {
           id: statusbarmm
           x: 0
           y: 8
           width: 480
           height: 40
           color: "#00ffffff"

           Image {
               id: image1
               x: 378
               y: 3
               width: 33
               height: 30
               source: "qrc:/../../../icons/network-cellular-signal-good.svg"
               sourceSize.height: 400
               sourceSize.width: 400
               fillMode: Image.PreserveAspectFit
           }

           Image {
               id: image2
               x: 438
               y: 3
               width: 35
               height: 31
               source: "qrc:/../../../icons/network-wireless-signal-good-symbolic.svg"
               sourceSize.height: 128
               sourceSize.width: 128
               fillMode: Image.PreserveAspectFit
           }

           Text {
               id: text13
               x: 410
               y: 7
               width: 22
               height: 22
               color: "#ffffff"
               text: qsTr("4G")
               font.pixelSize: 17
               font.bold: false
           }

           Image {
               id: image3
               x: 8
               y: 2
               width: 34
               height: 32
               source: "qrc:/../../../icons/battery-070.svg"
               sourceSize.height: 128
               sourceSize.width: 128
               fillMode: Image.PreserveAspectFit
           }

           Text {
               id: text14
               x: 39
               y: 7
               width: 36
               height: 22
               color: "#ffffff"
               text: qsTr("75%")
               font.pixelSize: 17
               font.bold: false
           }

           Text {
               id: text15
               x: 216
               y: 7
               width: 49
               height: 22
               color: "#ffffff"
               text: qsTr("17:46")
               font.pixelSize: 17
               font.bold: false
           }
       }


       TextField {
             id: searchField
              text: ""
              anchors {
                  horizontalCenter: parent.horizontalCenter
                  bottom: parent.bottom
              }

              width: rootWindow.width * 0.16
              onTextEdited: {
                 refresh()
              }

             Keys.onEscapePressed: Qt.quit()
              Keys.onDownPressed: swipeView.forceActiveFocus()
             onAccepted: {
                  var app = swipeView.currentItem.page[0]
                 if (app) {
                     exec(app[2])
               }
           }
        }


   }


    property var appPages: []

    function filter(app, q) {
        for (var i in app) {
            if (app[i].trim().toLowerCase().indexOf(q) > -1) {
                return true;
            }
        }
        return false;
    }

    function refresh(){
        var page = 0
        var itemsPerPage = 15
        console.log(searchField.text)
        appPages = [];
        appPages[page] = []

        pageRepeater.model = 0

        for (var i in apps) {
            if (appPages[page].length >= itemsPerPage)
                page++

            if (!appPages[page])
                appPages[page] = []

            var app = apps[i]
            if (filter(app, searchField.text))
                appPages[page].push(app)
        }

        pageRepeater.model = appPages.length
    }

    Component.onCompleted: {
        refresh()
        searchField.forceActiveFocus()
    }

    SwipeView {
        Keys.onEscapePressed: Qt.quit()
        id: swipeView
        anchors.fill: parent

        property int selectedIndex: 0

        function select(index) {
            selectedIndex = index
        }

        Keys.onUpPressed: {
            var place = selectedIndex - rootWindow.columns
            if (place >= 0)
                selectedIndex = place
        }

        Keys.onDownPressed: {
            var place = selectedIndex + rootWindow.columns
            if (place < currentItem.count())
                selectedIndex = place
        }

        Keys.onRightPressed: {
            selectedIndex = Math.min(selectedIndex + 1, currentItem.count() - 1)
        }
        Keys.onLeftPressed: {
            selectedIndex = Math.max(0, selectedIndex - 1)
        }

        Keys.onReturnPressed: {
            var app = appPages[currentIndex][selectedIndex]
            if (app) {
                exec(app[2])
            }
        }

        onFocusChanged: {
            if (focus) {
                select(0)
            }
        }

        Repeater {
            id: pageRepeater
            model: appPages.length

            Item {
                id: pageContainer
                function count() {
                    return page.length;
                }

                property var page: appPages[index]

                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.quit()
                }

                Grid {
                    spacing: rootWindow.height * 0.01
                    anchors.centerIn: parent
                    columns: rootWindow.columns
                    horizontalItemAlignment: Grid.AlignHCenter

                    populate: Transition {
                        id: trans
                        SequentialAnimation {
                            NumberAnimation {
                                properties: "opacity";
                                from: 1
                                to: 0
                                duration: 0
                            }
                            PauseAnimation {
                                duration: (trans.ViewTransition.index -
                                           trans.ViewTransition.targetIndexes[0]) * 20
                            }
                            ParallelAnimation {
                                NumberAnimation {
                                    properties: "opacity";
                                    from: 0
                                    to: 1
                                    duration: 600
                                    easing.type: Easing.OutCubic
                                }
                                NumberAnimation {
                                    properties: "y";
                                    from: trans.ViewTransition.destination.y + 50
                                    duration: 620
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }
                    }

                    Repeater {
                        model: page !== undefined ? page.length : 0

                        AppEntry {
                            app: page !== undefined ? page[index] : ["undefined", "", ""]
                            height: pageContainer.height * 0.17
                            width: height
                            padding: 10
                            selected: swipeView.selectedIndex === index
                            onHovered: {
                                swipeView.select(index)
                            }
                            onClicked: {
                                exec(app[2])
                            }
                        }
                    }
                }
            }
        }
    }

    function exec(program) {
        console.debug("Exec: " + program)
        proc.start(program)
        Qt.quit();
    }

footer: ToolBar {
        background: Item{}
        height: rootWindow.height * 0.05
        PageIndicator {
            count: swipeView.count
            currentIndex: swipeView.currentIndex
            anchors.centerIn: parent
        }
    }
}
