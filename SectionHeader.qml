import QtQuick 2.0
import "Theme.js" as Theme

Rectangle {
    property alias text: sectionHeaderText.text
    color: Theme.background_color
    width: parent.width;
    height: sectionHeaderText.paintedHeight

    Text {
        id: sectionHeaderText
        anchors.fill: parent;
        verticalAlignment: Text.AlignVCenter
        anchors.margins: Theme.margin
        horizontalAlignment: Text.AlignRight;
        color: Theme.section_header_color;
        font.pointSize: Theme.section_header_pointSize;
    }

}
