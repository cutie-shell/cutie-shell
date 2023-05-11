import QtQuick
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings
import QtWayland.Compositor

InputPanel {
    id: inputPanel
    y: parent.height
    anchors.left: parent.left
    anchors.right: parent.right

    Component.onCompleted: VirtualKeyboardSettings.styleName = "cutie"

    onStateChanged: {
        for (var i = 0; i < shellSurfaces.count; i++) {
            if (state == "visible") {
                shellSurfaces.get(i).shellSurface.toplevel.sendResizing(Qt.size(view.width, (view.height - height) - 30));
            } else {
                shellSurfaces.get(i).shellSurface.toplevel.sendResizing(Qt.size(view.width, view.height - 30));
            }
        }
    }

    states: State {
        name: "visible"
        when: inputPanel.active && root.state != "locked"
        PropertyChanges {
            target: inputPanel
            y: parent.height - inputPanel.height
        }
    }
    transitions: Transition {
        id: inputPanelTransition
        from: ""
        to: "visible"
        reversible: true
        ParallelAnimation {
            NumberAnimation {
                properties: "y"
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }
    }
    Binding {
        target: InputContext
        property: "animating"
        value: inputPanelTransition.running
    }
}