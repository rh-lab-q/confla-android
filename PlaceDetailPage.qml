import QtQuick 2.0
import "Theme.js" as Theme

Page {
    property alias name: title_label.text
    property string description;
    property alias image: placesDelegate.source;
    property double lat
    property double lon

    signal showOnMap();


    Flickable {
        anchors.fill: parent;
        contentHeight: pageHeader.height + title_label.height + description_label.height + Theme.paddingSmall + 2 * Theme.paddingMedium;
        //        PullDownMenu {
        //            MenuItem {
        //                //% "Show on map"
        //                text: qsTrId("place-detail-menu-show-on-map");
        //                onClicked: {
        //                    showOnMap();
        //                }
        //            }
        //            MenuItem {
        //                //% "Navigate to"
        //                text: qsTrId("place-detail-menu-navigate-to");
        //                onClicked: {
        //                    Qt.openUrlExternally("geo:"+lat+","+lon)
        //                }
        //            }
        //        }

        PageHeader {
            id: pageHeader
            anchors.top: parent.top;
            anchors.right: parent.right;
            anchors.left: parent.left;
            //% "Place"
            title: qsTrId("place-detail-header-place")
        }

        Image {
            id: placesDelegate
            anchors.left: parent.left;
            anchors.verticalCenter: title_label.verticalCenter;

            anchors.margins: Theme.paddingSmall;
            smooth: true
            width: 0.5 * dpix;
            height: 0.5 * dpiy;
            fillMode: Image.PreserveAspectFit

        }
        Image {
            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.margins: Theme.paddingMedium
            anchors.centerIn: placesDelegate;
            source: "./images/marker-icon.png"
            visible:( placesDelegate.status !== Image.Ready)
            width: placesDelegate.width;
            height: placesDelegate.height;
            fillMode: Image.PreserveAspectFit
        }


        Text {
            id: title_label
            anchors.margins: Theme.paddingSmall;
            anchors.top: pageHeader.bottom;
            anchors.left: placesDelegate.right;
            anchors.right: parent.right
            wrapMode: Text.Wrap;
            color: Theme.primary_color
            verticalAlignment: Text.AlignVCenter;
            font.pointSize: Theme.primary_pointSize;


        }

        Text {
            id: description_label;
            anchors.margins: Theme.paddingMedium;
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: title_label.bottom
            color: Theme.secondary_color
            wrapMode: Text.Wrap;
            font.pointSize: Theme.primary_pointSize;

            textFormat: Text.RichText;
            text: "<style type='text/css'>a:link{color:"+Theme.primaryColor+"; } a:visited{color:"+Theme.primaryHighlightColor+"}</style>  "+ description
            onLinkActivated: {
                Qt.openUrlExternally(link);
            }

        }

        LineButton {
            id: showOnMapButton
            anchors.topMargin: Theme.paddingLarge
            anchors.top: description_label.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            //% "Show on Map"
            text: qsTrId("show-on-map")
            image: "./images/ic_map_white_48dp.png"

            onClicked: {
                showOnMap();
            }

        }

        LineButton {
            id: navigateToButton
            anchors.topMargin: Theme.paddingLarge
            anchors.top: showOnMapButton.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            image: "./images/ic_directions_white_48dp.png"
            //% "Navigate to"
            text: qsTrId("navigate-to")
            onClicked: {
                Qt.openUrlExternally("geo:"+lat+","+lon)
            }
        }


    }

}
