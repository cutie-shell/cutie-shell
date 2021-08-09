import QtQuick 2.0


    MouseArea {
      anchors{ top: parent.top; left: parent.left }
      width: 1
      height: 40
      y: 25
      x:0
        // open or close the drawer
        onClicked: {
            root.state == "drawer" ? root.state = "normal" : root.state = "drawer"
            Qt.inputMethod.hide();
        }
    }

