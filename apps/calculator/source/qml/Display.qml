import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "." as App

Rectangle {
    id: display

    property var engine

    implicitHeight: main.implicitHeight

    border.color: "#56ffffff"
    color: "#56ffffff"
    border.width: dp(1)
    radius: dp(2)

    ColumnLayout {
        id: main

        anchors.left: parent.left
        anchors.leftMargin: dp(4)
        anchors.right: parent.right
        anchors.rightMargin: dp(4)
        spacing: dp(4)

        Label {
            text: engine.display
            font.pixelSize: dp(32)
            horizontalAlignment: Text.AlignRight
            Layout.fillWidth: true
        }

        Label {
            text: engine.expression
            font.pixelSize: dp(12)
            Layout.fillWidth: true
        }

        RowLayout {

            Label {
                text: "R: " + engine.result
                font.pixelSize: dp(16)
            }

            Item {
                Layout.fillWidth: true
            }

            Label {
                text: "M: " + engine.memory
                font.pixelSize: dp(16)
            }
        }
    }
}
