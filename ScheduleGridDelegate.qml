import QtQuick 2.0
import "functions.js" as F
import "Theme.js" as Theme


BackgroundItem {
    id: scheduleGridDelegate

    property int startTime;
    property int endTime;
//    property alias roomShort: roomLabel.text;
    property alias roomColor: roomColorLabel.color;
    property string speakers_str;
    property string topic;
    property int currentTimestamp;
    property bool inFavorites: false;

    clip: true;
    border.color: Theme.background_color_pressed;
    color: roomColor
//    border.color: inFavorites ? Qt.lighter(Theme.header_color) : Theme.background_color_pressed;


    Text {
        id: roomColorLabel
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.margins: Theme.paddingMedium
        font.pointSize: Theme.tertiary_pointSize;
        color: Theme.primary_color
        //               font.family: Theme.fontFamilyHeading
        font.weight: Font.Bold
        text: "|"
    }

    Text {
        anchors.left: roomColorLabel.left;
        anchors.top: parent.top;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.margins: Theme.paddingMedium
        font.pointSize: Theme.tertiary_pointSize;

        text: (speakers_str !== "") ? (speakers_str + ": " + topic) : topic
        color: (currentTimestamp > endTime)
               ? (scheduleGridDelegate.highlighted ? Theme.secondary_color_highlight : Theme.secondary_color)
               : (scheduleGridDelegate.highlighted ? Theme.primary_color_highlight : Theme.primary_color)
        wrapMode: Text.Wrap;
        textFormat: Text.RichText;

    }

    Image {
        visible: inFavorites;
        source: "./images/ic_favorite_white_48dp.png"
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        fillMode: Image.PreserveAspectFit;
        height: 24;
        anchors.margins: Theme.paddingMedium;
        opacity: 0.5;
    }


}
