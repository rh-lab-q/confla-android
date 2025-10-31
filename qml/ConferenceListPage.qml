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
                width: Theme.image_button_height
                fillMode: Image.PreserveAspectFit

                source: (model.icon !== undefined) ? model.icon : "";
            }


            Text {
                id: delegateText
                anchors.left: icon.right
                anchors.margins: Theme.paddingMedium
                anchors.right: parent.right
                text: model.title
                anchors.verticalCenter: parent.verticalCenter

                color: delegate.highlighted ? Theme.primary_color_highlight : Theme.primary_color;

                wrapMode: Text.Wrap;
                textFormat: Text.RichText;
                font.pointSize: Theme.primary_pointSize

            }
            onClicked: {
                let selectedObj = {
                    "url": model.url,
                    "icon": model.icon,
                    "title": model.title,
                    "version": model.version,
                }
                console.log(JSON.stringify(selectedObj, null, 2))

                selectConference(selectedObj, false);
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

        if (d.schedules !== undefined) {
            var confs = d.schedules;
            var conf;
            for (var i = 0; i < confs.length; i++) {
                conf = confs[i];

                var endDate = new Date(conf.end);
                endDate.setDate(endDate.getDate() + 1); // make sure not to hide event on its last day, because it is 00:00 not 23:59

                var now = new Date();

                if (endDate < now) {
                    // console.log("SKIP " + conf.title + " (in past " + endDate + ")")
                    continue;
                }

                if (/\.ics/.test(conf.url)) {
                    console.log("SKIP cannot parse ics " + conf.title)
                    continue
                }

                let selectObj = {
                    "url": conf.url,
                    "icon": (conf.metadata !== undefined && conf.metadata.icon !== undefined) ? conf.metadata.icon: "",
                    "title": conf.title,
                    "version": conf.version,
                }

                conferencesListModel.append(selectObj)
                // console.error(JSON.stringify(conf, null, 2));
            }
            if (confs.length === 1) {
                conf = confs[0];
                let selectObj = {
                    "url": conf.url,
                    "icon": (conf.metadata !== undefined && conf.metadata.icon !== undefined) ? conf.metadata.icon: "",
                    "title": conf.title,
                    "version": conf.version,
                }

                console.log("select conference: " + JSON.stringify(electObj, null, 2))
                selectConference(selectObj, true);
            }
        }

        // selectConference(
        //     {
        //         "url":"https://talks.openalt.cz/openalt-2025/schedule/export/schedule.xml",
        //         "icon":"https://gitlab.com/uploads/-/system/project/avatar/45099900/logo_konference-150.png",
        //         "title":"OpenALT 2025",
        //         "version":2025102700
        //     }
        //     , true)

        //        console.error("here " + JSON.stringify(d) )
    }
}
