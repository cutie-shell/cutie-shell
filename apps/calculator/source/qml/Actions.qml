pragma Singleton

import QtQuick 2.4
import QtQuick.Controls 1.3
import "." as App

QtObject {
    id: actionsSingleton

    property Action appQuitAction: Action {
        text: qsTr("E&xit")
        tooltip: qsTr("Exit the application")
        onTriggered: Qt.quit();
    }

    property Action scaleDownAction: Action {
        text: qsTr("Scale Down")
        onTriggered: {
            App.Units.scaleFactor = Math.max(1.0, App.Units.scaleFactor - 1.0);
        }
    }

    property Action scaleUpAction: Action {
        text: qsTr("Scale Up")
        onTriggered: {
            App.Units.scaleFactor += 1.0;
        }
    }

    function keyPressed(event, source) {
        if (event.key === Qt.Key_Escape) {
            event.accepted = true; // Otherwise menuBarArea gets focus for some strange reason.
        } else if (event.matches(StandardKey.Quit) ||
                (event.key === Qt.Key_Q && event.modifiers === Qt.ControlModifier)) {
            appQuitAction.trigger(source);
        } else if (event.key === Qt.Key_Minus && event.modifiers === (Qt.ControlModifier | Qt.KeypadModifier)) {
            scaleDownAction.trigger(source);
        } else if (event.key === Qt.Key_Plus && event.modifiers === (Qt.ControlModifier | Qt.KeypadModifier)) {
            scaleUpAction.trigger(source);
        } else {
            event.accepted = false;
            return;
        }
        event.accepted = true;
    }

    Component.onCompleted: {
        // Keep all the shortcut assignments here simply to group them together for clarity.
        appQuitAction.shortcut = "Ctrl+Q";
        // There is currently a bug in QML when this file is a singleton whereby the shortcuts
        // no longer work. Therefore the key handling is also handled in the keyPressed function.
    }
}
