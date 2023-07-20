import QtQuick 2.0

Item {
    id: root
   
// public
    property bool password: false

    signal accepted(string text);   // onAccepted: print('onAccepted', text)
    signal rejected();              // onRejected: print('onRejected')
   
// private
    width: 500;  height: 500 // default size

    property double rowSpacing:     0.01 * width  // horizontal spacing between keyboard
    property double columnSpacing:  0.02 * height // vertical   spacing between keyboard
    property bool   shift:          false
    property bool   symbols:        false
    property double columns:        10
    property double rows:           5
             
    MouseArea {anchors.fill: parent} // don't allow touches to pass to MouseAreas underneath
         
    Rectangle { // input
        width: root.width;  height: 0.2 * root.height
       
        Button { // close v
            id: closeButton
           
            text: '\u2193' // BLACK DOWN-POINTING TRIANGLE
            width: height;  height: 0.8 * parent.height
            anchors.verticalCenter: parent.verticalCenter
            x: columnSpacing
           
            onClicked: rejected() // emit
        }
       
        TextInput {
            id: textInput
           
            cursorVisible: true
            anchors {left: closeButton.right;  right: clearButton.left;  verticalCenter: parent.verticalCenter;  margins: 0.03 * root.width}
            font.pixelSize: 0.5 * parent.height
            clip: true
            echoMode: password? TextInput.Password: TextInput.Normal
           
            onAccepted: if(acceptableInput) root.accepted(text) // keyboard Enter key
        }
       
        Button { // clear x
            id: clearButton
           
            text: '\u2715' // BLACK DOWN-POINTING TRIANGLE
            width: height;  height: 0.8 * parent.height
            anchors {verticalCenter: parent.verticalCenter;  right: parent.right;  rightMargin: columnSpacing}
            enabled:   textInput.text
           
            onClicked: textInput.text = ''
        }
    }