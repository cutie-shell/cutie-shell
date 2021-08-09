import QtQuick 2.0

Rectangle{
id: downbar
width: 480
height: 26
color: "#b5000000"

Image {
    id: image
    x: 226
    y: 0
    width: 29
    height: 25
    source: "apps/setup-wizard-new/44831719.png"
    anchors.horizontalCenterOffset: 1
    anchors.horizontalCenter: parent.horizontalCenter
    fillMode: Image.PreserveAspectFit
}


}
