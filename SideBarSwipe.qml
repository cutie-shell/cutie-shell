import QtQuick 2.0

    Rectangle {
      width: 5 * shellScaleFactor
      height: 20 * shellScaleFactor
      y: 15 * shellScaleFactor
      x:0
      color: "red"
      MouseArea {
      width: 5 * shellScaleFactor
      height: 20 * shellScaleFactor
        // open or close the drawer
        onClicked: {
            root.state == "drawer" ? root.state = "normal" : root.state = "drawer"
            Qt.inputMethod.hide();
        }
    }

