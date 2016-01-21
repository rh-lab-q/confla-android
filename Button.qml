import QtQuick 2.0
import "Theme.js" as Theme

Rectangle {
    id: button;
    width: dpix * 0.5;
    height: dpiy * 0.5;
    anchors.margins: Theme.paddingMedium

    property alias image: icon.source;
    radius: 3;

    color: mouse.pressed ? Theme.background_color_pressed : Theme.background_color;
    border.color: Theme.background_color_pressed ;
    border.width: 1;
    signal clicked();
    Image {
        id: icon
        anchors.centerIn: parent;

        width: button.width * 0.8;
        height: button.height * 0.8;
        fillMode: Image.PreserveAspectFit
    }
    MouseArea {
        id: mouse;
        anchors.fill: parent;
        onClicked: {
            button.clicked();
        }
    }
}

