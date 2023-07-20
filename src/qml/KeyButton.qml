import QtQuick
import Cutie

CutieButton {
	id: root
    font.pixelSize: 24
    background: Rectangle {
        id: backgroundRect
        anchors.fill: parent
        radius: 5
        color: Atmosphere.primaryColor
        border.color: Atmosphere.secondaryColor
    	border.width: 1
        Rectangle {
            anchors.fill: parent
            radius: 5
            color: root.checked ? Atmosphere.accentColor : Atmosphere.secondaryColor
            opacity: if(root.text == "\u21E6" || 
            				root.text == "\u21E5" || 
            				root.text == "\u21B5" || 
            				root.text == "\u21E7") {
            			root.pressed || root.checked ? 1 : .5
        			} else {
        				root.pressed || root.checked ? .75 : 0
        			}
        }
    }
}