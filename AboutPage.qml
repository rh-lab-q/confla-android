import QtQuick 2.0
import "Theme.js" as Theme


Page {
    id: page

    property alias title: header.title
    property string text

    Flickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                id: header
            }

            Text {
                id: contentLabel
                wrapMode: Text.Wrap;
                font.pointSize: Theme.secondary_pointSize;
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.paddingLarge;
                textFormat: Text.RichText
                color: Theme.primary_color
                text: "<style type='text/css'>a:link{color:"+Theme.section_header_color+"; } a:visited{color:"+Theme.section_header_color+"}</style>  "+ page.text
                onLinkActivated:{
                    Qt.openUrlExternally(link)
                }

            }

        }
    }
}
