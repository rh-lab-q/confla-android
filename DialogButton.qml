import QtQuick 2.3
import "Theme.js" as Theme;

Rectangle {
    id: btn;
    property alias title: primaryText.text;
    property alias subtitle: tertiaryText.text
    property alias icon: iconImage.source

    signal clicked();

    height: 3 * Theme.marginSmall + primaryText.paintedHeight + tertiaryText.paintedHeight;
    anchors.left: parent.left;
    anchors.right: parent.right;


//    height: Theme.tertiary_pointSize + 2 * Theme.margin
    color: m.pressed ? Theme.background_color_pressed : Theme.background_color

    Image {
        id: iconImage;
        anchors.left: parent.left;
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Theme.margin
        anchors.rightMargin: Theme.margin

    }


    Text {
        id: primaryText
        anchors.topMargin: Theme.marginSmall
        anchors.leftMargin: Theme.margin
        anchors.rightMargin: Theme.margin
        anchors.top: (tertiaryText.text !== "") ? parent.top : undefined;
        anchors.verticalCenter: (tertiaryText.text === "") ? parent.verticalCenter: undefined;
        anchors.left: (iconImage.status === Image.Null) ? parent.left : iconImage.right;
        anchors.right: parent.right
        wrapMode: Text.WordWrap
        color: m.pressed ? Theme.primary_color_highlight : Theme.primary_color
        font.pointSize: Theme.primary_pointSize

    }

    Text {
        id: tertiaryText
        anchors.top: primaryText.bottom
        anchors.left: (iconImage.status === Image.Null) ? parent.left : iconImage.right;
        anchors.right: parent.right
        anchors.topMargin: Theme.marginSmall
        anchors.leftMargin: Theme.margin
        anchors.rightMargin: Theme.margin
        wrapMode: Text.WordWrap
        font.pointSize: Theme.tertiary_pointSize
        text: ""
        color: m.pressed ? Theme.tertiary_color_highlight : Theme.tertiary_color
    }

    MouseArea {
        id: m;
        anchors.fill: parent;
        onClicked: {
            btn.clicked()
        }
    }

//    Rectangle {
//        id: secondaryAction
//        color:  "#ff0000";
//        width: parent.height;
//        height: parent.height;
//        anchors.right: parent.right
//        anchors.verticalCenter: parent.verticalCenter
//    }
}
