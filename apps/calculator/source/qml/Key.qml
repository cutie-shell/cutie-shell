import QtQuick 2.4
import "." as App

App.KeyForm {
    id: key

    implicitWidth: dp(48)
    implicitHeight: dp(48)

    fontSize: dp(20)

    property var engine
    property bool operable: supported && !engine.noop(value)
    property bool supported
    property string value

    onClicked: engine.process(key.value);

    Component.onCompleted: key.supported = engine.supports(key.value);
}
