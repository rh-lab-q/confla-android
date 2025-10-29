import QtQuick 2.0
import "functions.js" as F
import "Theme.js" as Theme

BackgroundItem {

    id: scheduleDelegate
    height: Math.max(startTimeLabel.height + endTimeLabel.height + roomLabel.height + Theme.paddingMedium, roomLabel.height, titleLabel.height) + 2 * Theme.paddingMedium

    property int startTime;
    property int endTime;
    property alias roomShort: roomLabel.text;
    property color roomColor
    color: highlighted ? Qt.darker(roomColor): roomColor
    property string speakers_str;
    property string title;
    property int currentTimestamp;
    property bool inFavorites;

    Text {
        id: startTimeLabel
        text: F.format_time(startTime);
        font.pointSize: Theme.tertiary_pointSize;
        color: scheduleDelegate.highlighted ? Theme.secondary_color_highlight : Theme.secondary_color
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.margins: Theme.paddingMedium
        textFormat: Text.RichText;
    }
    Text {
        id: endTimeLabel
        text: F.format_time(endTime);
        font.pointSize: Theme.tertiary_pointSize;
        color: scheduleDelegate.highlighted ? Theme.secondary_color_highlight : Theme.secondary_color
        anchors.left: parent.left;
        anchors.top: startTimeLabel.bottom
        anchors.margins: Theme.paddingMedium
        textFormat: Text.RichText;

    }

    Text {
        id: roomLabel;
        font.pointSize: Theme.tertiary_pointSize;

        color: scheduleDelegate.highlighted ? Theme.secondary_color_highlight : Theme.secondary_color
        anchors.left: parent.left;
        anchors.top: endTimeLabel.bottom;
        anchors.margins: Theme.paddingMedium
        textFormat: Text.RichText;

    }

    Text {
        id: titleLabel
        anchors.left: startTimeLabel.right
        anchors.right: parent.right
        anchors.top: parent.top;
        anchors.margins: Theme.paddingMedium
        font.pointSize: Theme.secondary_pointSize

        text: (speakers_str !== "") ? (speakers_str + ": " + title) : title
        color: (currentTimestamp > endTime)
               ? (scheduleDelegate.highlighted ? Theme.secondary_color_highlight : Theme.secondary_color)
                 : (scheduleDelegate.highlighted ? Theme.primary_color_highlight : Theme.primary_color)
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
