import QtQuick 2.0
import "Theme.js" as Theme

BackgroundItem {

    id: delegate

    property string title: ""
    property string description: ""
    property int date;
    property url link;
    property alias img: avatarImage.source;

    height: Math.max(rssDateLabel.paintedHeight + rssDescriptionLabel.paintedHeight + 2 * Theme.paddingLarge, 2 * Theme.paddingLarge + avatarImage.height)

    Image {
        id: dummyImage;
        z: avatarImage.z -1;
        anchors.fill: avatarImage;
        source: "qrc:/images/blank_boy.png"
        visible: avatarImage.status !== Image.Ready;
    }

    Image {

        id: avatarImage;
        z: delegate.z+2
        anchors.left: parent.left
        anchors.top: parent.top;
        width: 0.8 * dpix;
        height: 0.8 * dpiy;
        anchors.margins: Theme.paddingMedium;
        fillMode: Image.PreserveAspectCrop;

    }

    Text {
        id: rssDescriptionLabel
        anchors.top: parent.top;
        anchors.left: avatarImage.right;
        anchors.right: parent.right;
        anchors.margins: Theme.paddingLarge;


        color: delegate.highlighted ? Theme.secondary_color_highlight : Theme.secondary_color;
        wrapMode: Text.Wrap;
        font.pointSize: Theme.secondary_pointSize
        textFormat: Text.RichText;

        text: "<b>" + delegate.title + "</b> " + delegate.description

    }

    Text {
        id: rssDateLabel
        anchors.top: rssDescriptionLabel.bottom;
        anchors.left: avatarImage.right;
        anchors.right: parent.right;
        anchors.topMargin: Theme.paddingLarge
        anchors.leftMargin: Theme.paddingLarge;
        anchors.rightMargin: Theme.paddingLarge;
        horizontalAlignment: Text.AlignRight


        color: delegate.highlighted ? Theme.secondary_color_highlight : Theme.secondary_color;
        wrapMode: Text.Wrap;
        font.pointSize: Theme.tertiary_pointSize
        //        text: Format.formatDate(new Date(date*1000), Formatter.TimepointRelative)
        text: new Date(date*1000).toLocaleDateString()
    }


    onClicked: {
        Qt.openUrlExternally(link)
    }

}
