import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtGraphicalEffects 1.12
import "." as App

Window {
    id: appWindow
    height: 800
    width: 480
    property var dp: App.Units.dp

    title: qsTr("Calculator")

    color: "#00000000"

    contentItem.implicitWidth: calculator.implicitWidth
    contentItem.implicitHeight: calculator.implicitHeight



    Component.onCompleted: {
        App.Units.pixelDensity = Qt.binding(function()
                                            { return Screen.pixelDensity; });
       App.Units.scaleFactor = 2.0;
        visible = true;
    }



    //    toolBar: App.ToolBar { }


    App.Calculator {
        id: calculator
        x: 177
        y: 250
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

}
