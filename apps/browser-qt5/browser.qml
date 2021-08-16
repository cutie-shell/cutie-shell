import QtQuick 2.14
import QtWebEngine 1.7
import QtQuick.Window 2.2
import QtGraphicalEffects 1.12
import Cutie 1.0

Window {
    title: webview.title
    visible: true
    color: "transparent"

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

    Atmosphere {
        id: atmospheresHandler
    }

    FontLoader {
        id: icon
        source: "qrc:/Font Awesome 5 Free-Solid-900.otf"
    }

    Rectangle { 
        id: headerBar  
        width: parent.width
        height: 25
        anchors { top: parent.top; left: parent.left }
        color: "transparent"
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Item {
            id: backButton
            width: 20; height: 20; anchors { left: headerBar.left; leftMargin: 2; margins: 2; top: parent.top; topMargin: 4 }
            Text {
                id: backButtonIcon
                color: (atmospheresHandler.variant == "dark") ? "#ffffff" : "#000000"
                text: "\uF053"
                font { family: icon.name; pixelSize: 18 }
            }

            MouseArea { 
                anchors.fill: parent; anchors.margins: -1; 
                enabled: webview.canGoBack 
             //   onPressed: backButtonIcon.color = "#bf616a";
                onClicked: { webview.goBack() }
             //   onReleased: backButtonIcon.color = "#434C5E";
            }
        }

        Item {
            id: forwardButton
            width: 20
            height: 20
            anchors.left: backButton.right
            anchors.top: parent.top
            anchors.topMargin: 4
            Text {
                id: backButtonIcon1
                color: (atmospheresHandler.variant == "dark") ? "#ffffff" : "#000000"
                text: "\uf054"
                font.pixelSize: 18
                font.family: icon.name
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -1
             //   onPressed: backButtonIcon1.color = "#bf616a"
                enabled: webview.canGoForward
                onClicked: { webview.goForward() }
               // onReleased: backButtonIcon1.color = "#434C5E"
            }
        }

        Rectangle {
            id: urlBar
            height: 20
            color: (atmospheresHandler.variant == "dark") ? "#ffffff" : "#000000"
            border.width: 0; border.color: "#2E3440";
            visible: true
            anchors {
                top: parent.top
                left: forwardButton.right
                right: hamburger.left
                margins: 2; topMargin: 3;
            }
            radius: 5
            clip: true

            TextInput { 
                id: urlText
                text: ""
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.pointSize: 10 ; selectionColor: "#434C5E"
                color: (atmospheresHandler.variant == "dark") ? "#000000" : "#ffffff"
                inputMethodHints: Qt.ImhNoAutoUppercase // url hint 
                clip: true
                
                onAccepted: { 
                    webview.url = fixUrl(urlText.text);
                }
                onActiveFocusChanged: { 
                    if (urlText.activeFocus) {
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
            height: 1
            visible: webview.loadProgress < 100
            width: parent.width * (webview.loadProgress/100)
            anchors { bottom: headerBar.bottom; left: parent.left }
            color: "#bf616a"
        }

        Item {
            id: hamburger
            width: 20
            height: 20
            anchors.right: headerBar.right
            anchors.top: parent.top
            anchors.topMargin: 4
            anchors.rightMargin: 2
            rotation: 180
            Text {
                id: iconham
                y: 0
                width: 20
                height: 20
                color: (atmospheresHandler.variant == "dark") ? "#ffffff" : "#000000"
                text: "\uf0c9"
                font.pointSize: 18
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
        settings.showScrollBars: false
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
            if (!urlText.activeFocus) {
                urlText.text = webview.url;
            }
        }
    }

}
