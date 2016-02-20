import QtQuick 2.0
import "Theme.js" as Theme

Rectangle {
    property alias title: pageHeaderText.text
    color: Theme.background_color
    width: parent.width;
    height: pageHeaderText.paintedHeight

    Text {
        id: pageHeaderText
        anchors.fill: parent;
        verticalAlignment: Text.AlignVCenter
        anchors.margins: Theme.margin
        horizontalAlignment: Text.AlignRight;
        color: Theme.header_color;
        font.pointSize: Theme.header_pointSize;
        wrapMode: Text.WrapAnywhere
    }

}
