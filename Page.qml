import QtQuick 2.0
import "Theme.js" as Theme;

Rectangle {
    width: parent.width
    height: parent.height
    color: Theme.background_color
    visible: false;
    anchors.top: parent.top;
    anchors.bottom: parent.bottom;
    anchors.topMargin: Theme.margin
    anchors.bottomMargin: Theme.margin
}
