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

                selectConference(
                            {
                                "url": model.url,
                                "url_id": model.url_id,
                                "url_json": model.url_json,
                                "url_feedback": model.url_feedback,
                                "icon": model.icon,
                                "name": model.name,
                                "splash": model.splash,
                                "checksum": model.checksum,
                            }

                            , false);
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
                conferencesListModel.append(
                            {
                                "url": conf.url,
                                "url_id": conf.url_id,
                                "url_json": conf.url_json,
                                "url_feedback": conf.url_feedback,
                                "icon": conf.icon,
                                "name": conf.name,
                                "splash": conf.splash,
                                "checksum": conf.checksum,
                            }
                            )
                //                            console.error(JSON.stringify(conf));
            }
            if (confs.length === 1) {
                conf = confs[0];
                selectConference(
                            {
                                "url": conf.url,
                                "url_id": conf.url_id,
                                "url_json": conf.url_json,
                                "url_feedback": conf.url_feedback,
                                "icon": conf.icon,
                                "name": conf.name,
                                "splash": conf.splash,
                                "checksum": conf.checksum,
                            }
                            , true);
            }
        }

        //        console.error("here " + JSON.stringify(d) )
    }
}
