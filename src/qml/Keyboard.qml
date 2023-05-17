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
            let surface = shellSurfaces.get(i).shellSurface;
            if (state == "visible") {
                if (surface.toplevel)
                    surface.toplevel.sendMaximized(Qt.size(view.width, (view.height - height) - 30));
                else if (surface.sendConfigure)
                    surface.sendConfigure(Qt.size(view.width, (view.height - height) - 30), 0);
            } else {
                if (surface.toplevel)
                    surface.toplevel.sendMaximized(Qt.size(view.width, view.height - 30));
                else if (surface.sendConfigure)
                    surface.sendConfigure(Qt.size(view.width, view.height - 30), 0);
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