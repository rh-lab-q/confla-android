import QtQuick 2.0
import "Theme.js" as Theme

Rectangle {
    id: backgroundItem;
    property bool highlighted: highlight_enabled && mouse.pressed;
    property bool highlight_enabled: true;
    width: (parent !== null) ? parent.width : 100;
    color: highlighted ? Theme.background_color_pressed : Theme.background_color
    signal clicked();

    MouseArea {
        id: mouse
        anchors.fill: parent;
        onClicked: {
            backgroundItem.clicked();
        }
    }
}
