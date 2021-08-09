import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
Button{
    id: key

    width: 48
    height: 48
   // color: "#56ffffff"
    // color: "#68000000"

   implicitWidth: 48
   implicitHeight: 48

   property real fontSize: 20

  text: "X"


    style: ButtonStyle {
          background: Rectangle {
              implicitWidth: 100
              implicitHeight: 25
             border.width: control.activeFocus ? 2 : 1
            border.color: "#56ffffff"
             radius: 4
             gradient: Gradient {
                  GradientStop { position: 0 ; color: control.pressed ? "#56ffffff" : "#56ffffff" }
                  GradientStop { position: 1 ; color: control.pressed ? "#56ffffff" : "#56ffffff" }
              }
       }
     }


}
