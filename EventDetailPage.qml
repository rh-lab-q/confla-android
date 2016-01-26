import QtQuick 2.0
import "functions.js" as F
import "Theme.js" as Theme

Page {
    id: page

    property alias um: usersModel;
    property alias title: header.title
    property alias talkName: talkNameLabel.text
    property alias description: descriptionLabel.text

    property string startDay;
    property string startTime
    property string endTime
    property alias room: roomLabel.text
    property alias roomColor: roomLabel.color
    property alias tags: tagsLabel.text;

    property bool inFavorites: false;

    property string hash;

    signal addToFavorites(string hash);
    signal removeFromFavorites(string hash);


    ListModel {
        id: usersModel;
    }


    Flickable {
        anchors.fill: parent;
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium


            PageHeader {
                id: header;
                title: "event"
            }

            Text {
                id: talkNameLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingMedium;
                //                font.family: Theme.fontFamilyHeading
                font.pointSize: Theme.header_pointSize
                color: Theme.primary_color
                wrapMode: Text.WordWrap

            }

            Text {
                id: timeLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingMedium;
                color: Theme.secondary_color
                font.pointSize: Theme.secondary_pointSize
                text: startTime + " - " + endTime

            }

            Text {
                id: roomLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingMedium;
                color: Theme.secondary_color
                font.pointSize: Theme.secondary_pointSize
            }




            Repeater {
                model: usersModel;
                delegate: BackgroundItem {
                    id: usersDelegate
                    highlight_enabled: false;

                    height: Math.max(avatarImage.height, nameLabel.paintedHeight + companyLabel.paintedHeight + positionLabel.paintedHeight + 2*Theme.paddingMedium) + 2 * Theme.paddingMedium

                    Image {
                        id: dummyImage;
                        z: avatarImage.z -1;
                        anchors.fill: avatarImage;
                        source: "qrc:/images/blank_boy.png"
                        visible: avatarImage.status !== Image.Ready;
                        width: avatarImage.width;
                        height: avatarImage.height
                    }

                    Image {
                        id: avatarImage;
                        z: usersDelegate.z+2
                        anchors.left: parent.left
                        anchors.top: parent.top;
                        source: model.avatar;
                        width: 1.5 * dpix;
                        height: 1.5 * dpiy;
                        anchors.margins: Theme.paddingMedium;

                    }

                    Text {
                        id: nameLabel
                        anchors.top: parent.top;
                        anchors.left: avatarImage.right
                        anchors.right: parent.right
                        anchors.margins: Theme.paddingMedium;

                        text: model.name
                        color: Theme.primary_color
                        font.pointSize: Theme.primary_pointSize
                        wrapMode: Text.WordWrap

                    }

                    Text {
                        id: companyLabel
                        anchors.left: avatarImage.right
                        anchors.top: nameLabel.bottom
                        anchors.right: parent.right
                        anchors.margins: Theme.paddingMedium;
                        text: model.company
                        color: Theme.secondary_color
                        font.pointSize: Theme.secondary_pointSize
                        wrapMode: Text.WordWrap

                    }
                    Text {
                        id: positionLabel
                        anchors.right: parent.right
                        anchors.margins: Theme.paddingMedium;
                        anchors.top: companyLabel.bottom
                        anchors.left: avatarImage.right
                        text: model.position
                        color: Theme.secondary_color
                        font.pointSize: Theme.secondary_pointSize
                        wrapMode: Text.WordWrap

                    }
                }
            }

            Text {
                id: tagsLabel;
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingMedium;
                font.pointSize: Theme.secondary_pointSize
                color: Theme.section_header_color
                wrapMode: Text.WordWrap
                textFormat: Text.RichText;
            }

            Text {
                id: descriptionLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingMedium;
                font.pointSize: Theme.secondary_pointSize
                color: Theme.secondary_color
                wrapMode: Text.WordWrap
                textFormat: Text.RichText;

            }
            LineButton {
                image: inFavorites ? "./images/ic_favorite_white_48dp.png" : "./images/ic_favorite_grey600_48dp.png";
                text: inFavorites ?
                          //% "Remove from favorites"
                          qsTrId("remove-from-favorites")
                        :
                          //% "Add to favorites"
                          qsTrId("add-to-favorites")
                onClicked: {
                    if (inFavorites) {
                        removeFromFavorites(hash);
                        inFavorites = false;
                    } else {
                        addToFavorites(hash);
                        inFavorites = true;
                    }
                }
            }

            LineButton {
//                visible: false;
                image: "./images/ic_stars_white_48dp.png";

                //% "Leave your feedback here"
                text: qsTrId("open-feedback-form")
                onClicked: {
                    Qt.openUrlExternally("http://www.devconf.cz/feedback/"+hash)
                }
            }

        }
    }
}
