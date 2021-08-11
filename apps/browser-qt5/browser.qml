import QtQuick 2.14
import QtWebEngine 1.7
import QtQuick.Window 2.2
import QtGraphicalEffects 1.12

Window {
    title: webview.title
    width: 480
    height: 800
    visible: true

    function fixUrl(url) {
        url = url.replace( /^\s+/, "").replace( /\s+$/, ""); // remove white space
        url = url.replace( /(<([^>]+)>)/ig, ""); // remove <b> tag 
        if (url == "") return url;
        if (url[0] == "/") { return "file://"+url; }
        if (url[0] == '.') { 
            var str = itemMap[currentTab].url.toString();
            var n = str.lastIndexOf('/');
            return str.substring(0, n)+url.substring(1);
        }
        //FIXME: search engine support here
        if (url.startsWith('chrome://')) { return url; } 
        if (url.indexOf('.') < 0) { return "https://duckduckgo.com/?q="+url; }
        if (url.indexOf(":") < 0) { return "https://"+url; } 
        else { return url;}
    }

    Image {
        id: bug
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        source: "wallpaper.jpg"
        sourceSize.height: 800
        sourceSize.width: 2000
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        fillMode: Image.PreserveAspectCrop
    }
    FastBlur {
            anchors.fill: bug
            source: bug
            radius: 65

        }

    FontLoader {
        id: icon
        source: "qrc:/Font Awesome 5 Free-Solid-900.otf"
    }

    Rectangle { 
        id: headerBar  
        width: parent.width
        height: 50
        anchors { top: parent.top; left: parent.left }
        color: "#00ffffff"
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Item {
            id: backButton
            width: 30; height: 30; anchors { left: headerBar.left; leftMargin: 8; margins: 20; top: parent.top; topMargin: 10 }
            Text {
                id: backButtonIcon
                x: 7
                y: -3
                color: "#30ffffff"
                text: "\uF053"
                font { family: icon.name; pointSize: 28 }
            }

            MouseArea { 
                anchors.fill: parent; anchors.margins: -5; 
                enabled: webview.canGoBack 
             //   onPressed: backButtonIcon.color = "#bf616a";
                onClicked: { webview.goBack() }
             //   onReleased: backButtonIcon.color = "#434C5E";
            }
        }

        Rectangle {
            id: urlBar
            width: 293
            height: 34
            color: "#30ffffff"; border.width: 0; border.color: "#2E3440";
            visible: true
            anchors {
                top: parent.top
                left: parent.left
                margins: 20; topMargin: 8; leftMargin: 119
            }
            radius: 26

            TextInput { 
                id: urlText
                width: 272
                height: 26
                text: ""
                anchors.leftMargin: 13
                anchors.topMargin: 4
                font.pointSize: 16; color: "#2E3440"; selectionColor: "#434C5E"
                anchors { left: parent.left; top: parent.top; right: stopButton.left; margins: 11; }
                inputMethodHints: Qt.ImhNoAutoUppercase // url hint 
                clip: true
                
                onAccepted: { 
                    webview.url = fixUrl(urlText.text)
                }
                onActiveFocusChanged: { 
                    if (urlText.activeFocus) { 
                        webview.stop();
                        urlText.selectAll();
                        Qt.inputMethod.show();
                    } else {
                        parent.border.color = "#2E3440"; parent.border.width = 0;
                    }
                }
                onTextChanged: {
                    //if (urlText.activeFocus && urlText.text !== "") {
                    //    Tab.queryHistory(urlText.text)
                    //} else { historyModel.clear() }
                }
            }
        }
        Rectangle {
            id: urlProgressBar
            height: 4
            visible: webview.loadProgress < 100
            width: parent.width * (webview.loadProgress/100)
            anchors { bottom: headerBar.bottom; left: parent.left }
            color: "#bf616a"
        }

        Item {
            id: forwardButton
            x: 44
            width: 30
            height: 30
            anchors.left: headerBar.left
            anchors.top: parent.top
            anchors.margins: 20
            rotation: 180
            anchors.topMargin: 12
            anchors.leftMargin: 60
            Text {
                id: backButtonIcon1
                x: 7
                y: -3
                color: "#30ffffff"
                text: "\uf053"
                font.pointSize: 28
                font.family: icon.name
            }
            //

            MouseArea {
                anchors.fill: parent
                anchors.margins: -5
             //   onPressed: backButtonIcon1.color = "#bf616a"
                enabled: webview.canGoForward
                onClicked: { webview.goForward() }
               // onReleased: backButtonIcon1.color = "#434C5E"
            }
        }

        Item {
            id: hamburger
            x: 442
            width: 36
            height: 30
            anchors.left: headerBar.left
            anchors.top: parent.top
            anchors.margins: 20
            anchors.topMargin: 10
            anchors.leftMargin: 436
            rotation: 180
            Text {
                id: iconham
                x: 8
                y: 0
                width: 32
                height: 35
                color: "#30ffffff"
                text: "\uf0c9"
                font.pointSize: 24
                font.family: icon.name
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -5
              //  onPressed: iconham.color = "#bf616a"
             //   enabled: webview.canGoBack
            //    onClicked: { webview.goBack() }
             //   onReleased: iconham.color = "#434C5E"
            }
        }
    }

    WebEngineView {
        id: webview
        settings.webRTCPublicInterfacesOnly: true
        settings.touchIconsEnabled: true
        settings.spatialNavigationEnabled: true
        settings.screenCaptureEnabled: true
        settings.printElementBackgrounds: true
        settings.playbackRequiresUserGesture: true
        settings.localContentCanAccessRemoteUrls: true
        settings.linksIncludedInFocusChain: true
        settings.localContentCanAccessFileUrls: true
        settings.allowGeolocationOnInsecureOrigins: true
        settings.allowRunningInsecureContent: true
        settings.allowWindowActivationFromJavaScript: true
        settings.autoLoadIconsForPage: true
        settings.errorPageEnabled: true
        settings.focusOnNavigationEnabled: true
        settings.hyperlinkAuditingEnabled: true
        settings.javascriptCanPaste: true
        settings.javascriptCanOpenWindows: true
        settings.javascriptCanAccessClipboard: true
        settings.localStorageEnabled: true
        settings.pluginsEnabled: true
        settings.showScrollBars: true
        settings.webGLEnabled: true
        settings.fullScreenSupportEnabled: true
        settings.javascriptEnabled: true
        settings.autoLoadImages: true
        settings.accelerated2dCanvasEnabled: true
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 1
        anchors { top: headerBar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        url: "https://duckduckgo.com"
        profile: WebEngineProfile {
            offTheRecord: true
        }
        onLoadingChanged: {
            urlText.text = webview.url;
        }
    }

}
