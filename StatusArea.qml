import QtQuick 2.14


//Rectangle {
  //  color: "#2E3440"
   // width: 360 + 20
   // height: 65
   // anchors {
   //     top: parent.top
   //     right: parent.right
   //     rightMargin: -20
  //  }
  //  radius: 22
   // z: 4

    MouseArea {
        width: 360 + 20
        height: 65
        anchors {
            top: parent.top
            right: parent.right
            rightMargin: -20
        }
      //  anchors.fill: parent
      //  anchors.rightMargin: 0
       // anchors.bottomMargin: 0
       // anchors.leftMargin: 0
       // anchors.topMargin: 0
        drag.target: settingSheet; drag.axis: Drag.YAxis; drag.minimumY: -735; drag.maximumY: 0
        //onPressAndHold: {
        //    screenshotTimer.start();
        //}
        onClicked: {
            if (settingSheet.y > -735) { root.state = "normals" } else { root.state = "setting" }
        }
        onReleased: {
            if (settingSheet.y > -735) { root.state = "setting" } else { root.state = "normals" }
        }
    }

