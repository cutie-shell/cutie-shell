import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "." as App

Rectangle {
    id: calculator

    property real maximumWidth: main.Layout.maximumWidth + main.anchors.margins * 2
    property real maximumHeight: main.Layout.maximumHeight + main.anchors.margins * 2

    property real minimumWidth: main.Layout.minimumWidth + main.anchors.margins * 2
    property real minimumHeight: main.Layout.minimumHeight + main.anchors.margins * 2

    implicitWidth: main.implicitWidth + main.anchors.margins * 2
    implicitHeight: main.implicitHeight + main.anchors.margins * 2

    color: "transparent"

    App.Engine {
        id: engine

        Component.onCompleted: engine.start();
    }

    ColumnLayout {
        id: main

        anchors.fill: parent
        anchors.margins: dp(8)
        spacing: dp(8)

        App.Display {
            engine: engine
            implicitWidth: keypad.implicitWidth
        }

        App.Keypad {
            id: keypad
            engine: engine
        }
    }

    focus: true

    Keys.onPressed: {
        App.Actions.keyPressed(event, calculator);
        if (!event.accepted) {
            event.accepted = engine.process(event.text);
        }
    }
}
