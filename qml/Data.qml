import QtQuick.LocalStorage 2.0 as Sql
import QtQuick 2.0
import "functions.js" as F

Item {

    property string dbName: "confla"
    property string dbVersion: "1.0"
    property string dbDisplayName: "confla"
    property int dbEstimatedSize: 10000;

    property variant conferences;
    property variant data;
    property int lastUpdate: 0
    property string status: "idle"

    //    property variant secondPage

    function configSet(key, value) {
//        console.log("configSet(" +key + "," + value + ")")

        var db = Sql.LocalStorage.openDatabaseSync(dbName, dbVersion, dbDisplayName, dbEstimatedSize);
        db.transaction(
                    function(tx) {
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Keys(key TEXT PRIMARY KEY, value TEXT)');
                        var rs = tx.executeSql('SELECT * FROM Keys WHERE key==?', [ key ]);

                        if (rs.rows.length === 0){
                            tx.executeSql('INSERT INTO Keys VALUES(?, ?)', [ key, value ]);
                        } else {
                            tx.executeSql('UPDATE Keys SET value=? WHERE key==?', [value, key]);
                        }
                    })
    }

    function configGet(key, default_value) {
        var db = Sql.LocalStorage.openDatabaseSync(dbName, dbVersion, dbDisplayName, dbEstimatedSize);
        var result = "";
        db.transaction(
                    function(tx) {

                        tx.executeSql('CREATE TABLE IF NOT EXISTS Keys(key TEXT PRIMARY KEY, value TEXT)');
                        var rs = tx.executeSql('SELECT * FROM Keys WHERE key=?', [ key ]);
                        if (rs.rows.length === 1 && rs.rows.item(0).value.length > 0){
                            result = rs.rows.item(0).value
//                            console.log("configGet(" +key + ", " + result + ", "+ default_value +")")
                        }
                        else {
                            result = default_value;
//                            console.log("configGet(" +key + ", " + default_value +") (default)")
                        }
                    }
                    )
        return result;
    }

    function init_data() {
        read_cache();
        check_updates();

    }

    function read_cache() {
        try {
            var json = configGet("conferences", "{}");
            conferences = JSON.parse(json);
        } catch (e) {
            console.log(e)
            console.log(json)
        }
        updateUI();
    }

    function check_updates() {
        var url = "https://ggt.gaa.st/menu.json"
        var http = new XMLHttpRequest()
        http.open("GET", url, true)
        console.log("Downloading " + url + " ...")

        http.onreadystatechange = function(){
            if (http.readyState == 4) {
                if (http.status == 200) {
                    try {
                        conferences = JSON.parse(http.responseText);
                        configSet("conferences", http.responseText)
                        updateUI();
                    } catch (e) {
                        console.log(e)
                        console.log(http.responseText);
                    }

                }
            }
        }
        http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;");
        //http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");
        http.send()

    }

    function init_conference(conf_data) {
        data = JSON.parse(configGet(conf_data['url']+"/cache",'{}'));
        updateUIConference(conf_data);

        var cache_version = configGet(conf_data['url']+"/version", 'INVALID_version');

        if (conf_data['version'] !== cache_version) {
            console.error("init_conference " + conf_data['version'] + " -> " + cache_version)

            download_conference(conf_data);
        }

    }

    function xmlToJSON(xml) {
        var doc = xml.documentElement

        if (!doc) {
            console.error("Invalid XML document")
            return "{}"
        }

        var sessions = []
        var days = []
        var users = []
        var tracks = []


        for (var i = 0; i < doc.childNodes.length; ++i) {
            var dayNode = doc.childNodes[i]
            if (dayNode.nodeName === "conference") {
                for (var j = 0; j < dayNode.childNodes.length; ++j) {
                    var trackNode = dayNode.childNodes[j]
                    if (trackNode.nodeName !== "track")
                        continue

                    var name = ""
                    var slug = ""
                    var color = ""

                    if (trackNode.attributes && trackNode.attributes.length > 0) {
                        for (var a = 0; a < trackNode.attributes.length; ++a) {
                            var attr = trackNode.attributes[a]
                            switch (attr.nodeName) {
                            case "name":
                                name = attr.nodeValue
                                break
                            case "slug":
                                slug = attr.nodeValue
                                break
                            case "color":
                                color = attr.nodeValue
                                break
                            }
                        }
                    }

                    tracks.push({
                                    name: name,
                                    slug: slug,
                                    color: color
                                })
                }
            }

            if (dayNode.nodeName === "day") {
                var dayDate = ""
                if (dayNode.attributes && dayNode.attributes.length > 0) {
                    for (var a = 0; a < dayNode.attributes.length; ++a) {
                        if (dayNode.attributes[a].nodeName === "date") {
                            dayDate = dayNode.attributes[a].nodeValue
                            break
                        }
                    }
                }

                // Extract day start timestamp
                var dayStart = ""
                if (dayNode.attributes && dayNode.attributes.length > 0) {
                    for (var a = 0; a < dayNode.attributes.length; ++a) {
                        if (dayNode.attributes[a].nodeName === "start") {
                            dayStart = dayNode.attributes[a].nodeValue
                            break
                        }
                    }
                }

                if (dayStart) {
                    days.push(Math.floor(new Date(dayStart).getTime() / 1000))
                }


                for (var j = 0; j < dayNode.childNodes.length; ++j) {
                    var roomNode = dayNode.childNodes[j]
                    if (roomNode.nodeName !== "room") {
                        continue
                    }

                    var roomName = ""
                    if (roomNode.attributes && roomNode.attributes.length > 0) {
                        for (var a = 0; a < roomNode.attributes.length; ++a) {
                            if (roomNode.attributes[a].nodeName === "name") {
                                roomName = roomNode.attributes[a].nodeValue
                                break
                            }
                        }
                    }

                    for (var k = 0; k < roomNode.childNodes.length; ++k) {
                        var eventNode = roomNode.childNodes[k]
                        if (eventNode.nodeName !== "event") {
                            continue
                        }

                        var title = ""
                        var start = ""
                        var duration = ""
                        var description = ""
                        var track = ""
                        var persons = []
                        var person_ids = []
                        var session_id = ""
                        if (eventNode.attributes && eventNode.attributes.length > 0) {
                            for (var a = 0; a < eventNode.attributes.length; ++a) {
                                if (eventNode.attributes[a].nodeName === "id") {
                                    session_id = eventNode.attributes[a].nodeValue
                                    break
                                }
                            }
                        }

                        for (var l = 0; l < eventNode.childNodes.length; ++l) {
                            var eventChild = eventNode.childNodes[l]

                            switch (eventChild.nodeName) {
                            case "title":
                                title = eventChild.firstChild.nodeValue
                                break
                            case "track":
                                track = eventChild.childNodes.length > 0 ? eventChild.firstChild.nodeValue : ""
                                break
                            case "abstract":
                                description = eventChild.childNodes.length > 0 ? eventChild.firstChild.nodeValue : ""
                                break
                            case "start":
                                start = eventChild.firstChild.nodeValue
                                break
                            case "duration":
                                duration = eventChild.firstChild.nodeValue
                                break
                            case "persons":
                                for (var m = 0; m < eventChild.childNodes.length; ++m) {
                                    var person_name = ""
                                    var person_id = ""

                                    var p = eventChild.childNodes[m]
                                    if (p.nodeName === "person" && p.firstChild) {
                                        person_name = p.firstChild.nodeValue
                                        if (p.attributes && p.attributes.length > 0) {
                                            for (var n = 0; n < p.attributes.length; ++n) {
                                                if (p.attributes[n].nodeName === "id") {
                                                    person_ids.push(p.attributes[n].nodeValue)
                                                    person_id = p.attributes[n].nodeValue
                                                }
                                            }
                                        }
                                        users.push({
                                                       "username":person_id,
                                                       "name": person_name,
                                                       "avatar": "",
                                                       "company": "",
                                                       "position": "",
                                                   }) // fixme unique
                                    }
                                }
                                break

                            }
                        }

                        var event_start = Math.floor(new Date(dayDate + "T" + start + ":00").getTime() / 1000);
                        var parts = duration.split(":");
                        var hours = parseInt(parts[0], 10);
                        var minutes = parseInt(parts[1], 10);
                        var event_end = event_start + (hours * 3600 + minutes * 60);
                        var color = "#000000"
                        for (var t = 0; t < tracks.length; ++t) {
                            if (tracks[t].name === track) {
                                color = tracks[t].color
                                break
                            }
                        }

                        sessions.push({
                                          "session_id": session_id,
                                          "title": title,
                                          "speakers": person_ids,
                                          "description": description,
                                          "track": track,
                                          "tags": [track],
                                          "start": start,
                                          "day": dayDate,
                                          "event_start": event_start,
                                          "event_end": event_end,
                                          "duration": duration,
                                          "room": roomName,
                                          "room_short": roomName,
                                          "room_color": color,
                                      })

                    }
                }

            }
        }

        var data_struct = {
            // "about" : "",
            "days": days,
            // "rss": [],
            "sessions": sessions,
            "users": users,
            "tracks": tracks,
            // "venueMap": [],
        }

// console.log(JSON.stringify(data_struct, null, 2))

        console.log("sessions.length: " + sessions.length)

        return JSON.stringify(data_struct)

    }


    function download_conference(conf_data) {

        var url = conf_data['url'];
        console.log("Downloading " + url + " ...")
        var http = new XMLHttpRequest()
        http.open("GET", url, true)

        status = "updating"
        http.onreadystatechange = function(){
            if (http.readyState == 4) {
                if (http.status == 200) {
                    console.log("RESPONSE " + http.status + " " + http.statusText)

                    console.log("conferenceDetailPage.url " + conferenceDetailPage.url)
                    console.log("conf_data['url'] " + conf_data['url'])
                    // if (conferenceDetailPage.url === conf_data['url'] ) { // update UI only when showing same page
                    var obj = JSON.parse(xmlToJSON(http.responseXML))
                    data = Object.assign({}, obj, conf_data)
                    status = "idle"
                    updateUIConference(data);
                    // }

                    configSet( conf_data['url']+"/cache", data )
                    if (data.version !== undefined) {
                        configSet(conf_data['url']+"/version", data.version)
                    }

                } else { // offline or error while downloading
                    console.log("error downloading ")
                    status = "offline"
                }
            }

        }
        http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;");
        //http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");
        //        http.send(params)
        http.send()

    }

    function getFavorites(url) {
        return JSON.parse(configGet(url+"/favorites", "[]"));
    }

    function setFavorites(url, _fav) {
        configSet(url+"/favorites", JSON.stringify(_fav));
    }

    function updateUIConference(conf_data) {
        // console.log(JSON.stringify(conf_data, null, 2))
        conferenceDetailPage.name = conf_data['title'];
        conferenceDetailPage.reload(conf_data);
        schedulePage.reloadFavorites(getFavorites(conf_data['url']));
        schedulePage.reload(conf_data)
        mapPage.reload(conf_data);

    }

    function updateUI() {

        conferenceListPage.reload(conferences)

        //        coverPage.reload(data)
        //        coverPage.coundownTarget = data.days[0]

        //        secondPage.load(data.events);
    }

    function getSpeakerDetail(name) {
        var usersArray = data.users
        if (!Array.isArray(usersArray)) {
            console.error("User array not loaded. Searching for " + name)
            return {}
        }
        for (var i = 0; i < usersArray.length; i++) {
            var user = usersArray[i];
            if (user.username === name) {
                return user;
            }
        }
        console.error("Cannot find user " + name)
        return {}
    }
}
