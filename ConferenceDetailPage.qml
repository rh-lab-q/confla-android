import QtQuick 2.0
import "functions.js" as F
import "Theme.js" as Theme

Page {
    id: page
    property alias name: conferenceName.title;
    property string url_id: ""
    property string feedback_url: ""

    Flickable {
        anchors.fill: parent

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium

            PageHeader {
                id: conferenceName
            }

            SectionHeader {
                //% "About"
                text: qsTrId("section-header-about")
                visible: (aboutModel.count > 0)
            }


            Repeater {
                model: aboutModel
                delegate: BackgroundItem {
                    id: aboutDelegate
                    width: column.width;
                    height: aboutDelegateText.paintedHeight + Theme.paddingLarge;
                    Text {
                        id: aboutDelegateText
                        x: Theme.paddingLarge
                        text: title
                        anchors.verticalCenter: parent.verticalCenter

                        color: aboutDelegate.highlighted ? Theme.primary_color_highlight : Theme.primary_color;

                        wrapMode: Text.Wrap;
                        font.pointSize: Theme.primary_pointSize

                    }
                    onClicked: {
                        aboutPage.title = model.title;
                        aboutPage.text = model.text;
                        pageStack.push(aboutPage);
                    }

                }
            }

            Repeater {
                model: venueMapModel
                delegate: BackgroundItem {
                    id: venueMapDelegate
                    width: column.width;
                    height: venueMapDelegateText.paintedHeight + Theme.paddingLarge;
                    Text {
                        id: venueMapDelegateText
                        x: Theme.paddingLarge
                        text: title
                        anchors.verticalCenter: parent.verticalCenter

                        color: venueMapDelegate.highlighted ? Theme.primary_color_highlight : Theme.primary_color;
                        wrapMode: Text.Wrap;
                        font.pointSize: Theme.primary_pointSize

                    }
                    onClicked: {
                        var local_url = IMAGE_CACHE_FOLDER + "/" + filereader.getBasename(model.image)

                        photoDetailPage.addr = (filereader.file_exists(local_url)) ? local_url : model.image;

                        pageStack.push(photoDetailPage)
                    }

                }
            }


            BackgroundItem {
                id: mapDelegate
                width: column.width
                height: mapDelegateText.paintedHeight + Theme.paddingLarge;
                visible: (mapPage.mapWidget.places.count > 0)

                Text {
                    id: mapDelegateText;
                    x: Theme.paddingLarge
                    //% "Important Places"
                    text: qsTrId("section-about-places")
                    anchors.verticalCenter: parent.verticalCenter

                    color: mapDelegate.highlighted ? Theme.primary_color_highlight : Theme.primary_color
                    wrapMode: Text.Wrap;
                    //                    font.family: Theme.fontFamily
                    font.pointSize: Theme.primary_pointSize;

                }
                onClicked: {
                    pageStack.push(mapPage)
                }

            }


            SectionHeader {
                //% "Schedule"
                text: qsTrId("section-header-schedule")
                visible: (daysModel.count > 0)
            }

            Repeater {
                model: daysModel
                delegate: BackgroundItem {
                    id: daysDelegate
                    height: daysDelegateText.paintedHeight + Theme.paddingLarge;
                    Text {
                        id: daysDelegateText
                        x: Theme.paddingLarge
                        text: name
                        anchors.verticalCenter: parent.verticalCenter

                        color: daysDelegate.highlighted ? Theme.primary_color_highlight : Theme.primary_color;
                        wrapMode: Text.Wrap;
                        font.pointSize: Theme.primary_pointSize

                    }
                    onClicked: {
                        schedulePage.filter_favorites = false;
                        schedulePage.filter_start = parseInt(timestamp, 10)
                        schedulePage.filter_end = parseInt(timestamp, 10) + 24 * 3600
                        schedulePage.updateFilter();

                        pageStack.push(schedulePage)
                    }

                }
            }

            BackgroundItem {
                id: favoritesDelegate
                width: column.width
                height: favoritesDelegateText.paintedHeight + Theme.paddingLarge;
                visible: (schedulePage.favoritesModel.length > 0)
                Text {
                    id: favoritesDelegateText
                    x: Theme.paddingLarge
                    //% "Favorites"
                    text: qsTrId("section-favorites")
                    anchors.verticalCenter: parent.verticalCenter
                    color: favoritesDelegate.highlighted ? Theme.primary_color_highlight : Theme.primary_color;
                    wrapMode: Text.Wrap;
                    font.pointSize: Theme.primary_pointSize


                }
                onClicked: {
                    schedulePage.filter_favorites = true;
                    schedulePage.updateFilter();
                    pageStack.push(schedulePage)
                }

            }

            SectionHeader {
                //% "Upcoming talks"
                text: qsTrId("section-header-upcoming-talks")
                visible: (currentEvents.count > 0)
            }

            Repeater {
                model: currentEvents;
                delegate: ScheduleDelegate {
                    startTime: parseInt(model.event_start, 10);
                    endTime: parseInt(model.event_end, 10);
                    roomShort: model.room_short;
                    roomColor:  model.room_color;
                    speakers_str: model.speakers_str;
                    topic: model.topic
                    inFavorites: schedulePage.isInFavorites(model.session_id);

                    onClicked: {
                        //                        eventDetailPage.title = model.type;
                        eventDetailPage.talkName = model.topic
                        eventDetailPage.description = model.description
                        eventDetailPage.startTime = F.format_time(model.event_start);
                        eventDetailPage.endTime = F.format_time(model.event_end);
                        eventDetailPage.startDay = model.event_day;
                        eventDetailPage.room = model.room;
                        eventDetailPage.roomColor = model.room_color
                        eventDetailPage.um.clear()
                        var speakersArray = JSON.parse(model.speakers);
                        for (var i = 0; i < speakersArray.length; i++) {
                            var detail = dataSource.getSpeakerDetail(speakersArray[i])
                            if (detail !== undefined) {
                                eventDetailPage.um.append(detail)
                            }
                        }

                        eventDetailPage.tags = model.tags_str;
                        eventDetailPage.session_id = model.session_id;
                        eventDetailPage.inFavorites = schedulePage.isInFavorites(model.session_id);
                        pageStack.push(eventDetailPage);
                    }

                }
            }


            SectionHeader {
                //% "News"
                text: qsTrId("section-header-news")
                visible: (rssModel.count > 0)
            }

            Repeater {
                id: rssRepeater
                model: rssModel
                delegate: RssItemDelegate {
                    //                    img: (model.avatar !== undefined) ? model.avatar : ""
                    img: model.avatar;
                    title: model.title
                    description: model.description
                    link: model.link
                    date: model.time
                }

            }



        }
    }

    ListModel {
        id: aboutModel
    }

    ListModel {
        id: daysModel;
    }

    ListModel {
        id: rssModel;
    }

    ListModel {
        id: currentEvents
    }

    ListModel {
        id: venueMapModel;
    }



    function reload(d) {

        aboutModel.clear()
        if (d.about !== undefined) {
            var aboutArray = d.about;
            for (var i = 0; i < aboutArray.length; i++) {
                aboutModel.append(aboutArray[i])
            }
        }

        daysModel.clear();
        if (d.days !== undefined) {
            var daysArray = d.days;
            for (var i = 0; i < daysArray.length; i++) {
                var ts = parseInt(daysArray[i], 10);
                var date = new Date(ts* 1000);
                var dayName = F.dayOfWeek(date.getDay())
                daysModel.append({'timestamp': parseInt(ts, 10), 'name': dayName})
            }
        }

        rssModel.clear();
        if (d.rss !== undefined) {
            var rss = d.rss;
            for (var i = 0; i < rss.length; i++) {
                rssModel.append(rss[i])
            }
        }

        currentEvents.clear();
        if (d.sessions !== undefined) {

            var now = Math.floor(new Date().getTime()/1000);
            var sessions = d.sessions
            var j = 0;
            for (var i = 0; i < sessions.length; i++) {
                var item = sessions[i];
                if (item.event_start > now) {
                    var dayInt = new Date(parseInt(item.event_start, 10) * 1000).getDay();
                    item.event_day = F.dayOfWeek(dayInt)

                    var obj;
                    if ((typeof item.speakers) == (typeof "")) { // this is ugly workarround - this should be object (array of strings)
                        obj = eval(item.speakers);
                        item.speakers = JSON.stringify(obj);
                    } else {
                        obj = item.speakers;
                        item.speakers = JSON.stringify(item.speakers)
                    }
                    item.speakers_str = F.make_speakers_str(obj, d.users); // need to work with object

                    if ((typeof item.tags) == (typeof "")) { // this is ugly workarround - this should be object (array of strings)
                        obj = eval(item.tags);
                    } else {
                        obj = item.tags;
                    }

                    item.tags_str = F.make_tags_str(obj)

                    currentEvents.append(item)
                    j++;
                }
                if (j >= 8) {
                    break;
                }
            }
        } // endif (d.sessions !== undefined)


        venueMapModel.clear();
        if (d.venueMap !== undefined) {
            var venueMap = d.venueMap;

            for (var i = 0; i < venueMap.length; i++) {
                var item = venueMap[i]
                venueMapModel.append(item);

                var remote_url = item.image
                var local_url = IMAGE_CACHE_FOLDER + "/" + filereader.getBasename(remote_url)


                if (!filereader.file_exists(local_url)) {
                    downloader.append(remote_url, local_url)
                }


            }
        }


    }


}


