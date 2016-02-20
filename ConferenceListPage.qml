import QtQuick 2.0
import "functions.js" as F
import "Theme.js" as Theme

Page {
    id: page

    signal selectConference(variant conf_data, bool replace );

    ListModel {
        id: conferencesListModel;
    }

    ListView {
        model: conferencesListModel
        anchors.fill: parent
        spacing: Theme.paddingMedium
        delegate: BackgroundItem {
            id: delegate
            height: Math.max(delegateText.paintedHeight, icon.height) + 2*Theme.paddingMedium;

            Image {
                id: icon;
                anchors.top: parent.top;
                anchors.left: parent.left
                anchors.topMargin: Theme.paddingMedium;
                anchors.leftMargin: Theme.paddingMedium;

                source: (model.icon !== undefined) ? model.icon : "";
            }


            Text {
                id: delegateText
                anchors.left: icon.right
                anchors.margins: Theme.paddingMedium
                text: model.name
                anchors.verticalCenter: parent.verticalCenter

                color: delegate.highlighted ? Theme.primary_color_highlight : Theme.primary_color;

                wrapMode: Text.Wrap;
                textFormat: Text.RichText;
                font.pointSize: Theme.primary_pointSize

            }
            onClicked: {
                selectConference(model.name, model.url, model.checksum, model.feedback_url, false);
            }

        }

    }

    Text {
        visible: (conferencesListModel.count == 0);
        //% "List of conferences is empty"
        text: qsTrId("conference-list-page-list-is-empty")
        anchors.fill: parent;
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
        wrapMode: Text.Wrap;
        textFormat: Text.RichText;
        font.pointSize: Theme.primary_pointSize
        color: Theme.primary_color;


    }


    function reload(d) {
        conferencesListModel.clear();
        if (d.conferences !== undefined) {
            var confs = d.conferences;
            var conf;
            for (var i = 0; i < confs.length; i++) {
                conf = confs[i];
                conferencesListModel.append(conf)
//                            console.error(JSON.stringify(conf));
            }
            if (confs.length === 1) {
                conf = confs[0];
                selectConference(conf, true);
            }
        }

        //        console.error("here " + JSON.stringify(d) )
    }
}
