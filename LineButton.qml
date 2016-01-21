import QtQuick 2.0
import "Theme.js" as Theme


BackgroundItem {
    id: lineButton
    height: Math.max(innerText.paintedHeight, innerImage.sourceSize.height) + Theme.paddingLarge;
    width: parent.width;
    anchors.left: parent.left;
    anchors.right: parent.right;
    property alias text: innerText.text;
    property alias image: innerImage.source


    Image {
        id: innerImage;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.left: parent.left;
        anchors.margins: Theme.paddingLarge
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: innerText
        anchors.top: parent.top;
        anchors.left: innerImage.right
        anchors.right: parent.right

        anchors.margins: Theme.paddingLarge
        color: lineButton.highlighted ? Theme.primary_color_highlight : Theme.primary_color;

        wrapMode: Text.Wrap;
//        font.family: Theme.fontFamily
        font.pointSize: Theme.secondary_pointSize;

    }
}



