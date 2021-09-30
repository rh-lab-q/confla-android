import QtQuick.LocalStorage 2.0 as Sql
import QtQuick 2.0

Item {

    property string dbName: "openalt"
    property string dbVersion: "1.0"
    property string dbDisplayName: "openalt"
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
        var url = "https://www.openalt.cz/wall/sched.org/?list";
        //        var url = "http://pcmlich.fit.vutbr.cz/openalt2017/get_list.php";
//                var url = "http://pcmlich.fit.vutbr.cz/openalt2017/get_list.php";
//        var url = "http://pcmlich.fit.vutbr.cz/tmp/if.json"
//        var url = "http://localhost:8000/export/conference_list/?lang="+Qt.locale().name;
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
        //        http.send(params)
        http.send()

    }

    function init_conference(conf_data) {
        data = JSON.parse(configGet(conf_data['url_id']+"/cache",'{}'));
        updateUIConference(conf_data);

        var cache_checksum = configGet(conf_data['url_id']+"/checksum", 'INVALID_CHECKSUM');

        if (conf_data['checksum'] !== cache_checksum) {
//            console.error("init_conference " + conf_data['checksum'] + " -> " + cache_checksum)

            download_conference(conf_data);
        }




    }


    function download_conference(conf_data) {

        var url = conf_data['url_json'] + "?json&lang="+Qt.locale().name;
        console.log("Downloading " + url + " ...")
        var http = new XMLHttpRequest()
        http.open("GET", url, true)

        status = "updating"
        http.onreadystatechange = function(){
            if (http.readyState == 4) {
                if (http.status == 200) {
                    if (conferenceDetailPage.url_id === conf_data['url_id'] ) { // update UI only when showing same page
                        data = JSON.parse(http.responseText);
                        status = "idle"
                        updateUIConference(conf_data);
                    }

                    configSet(conf_data['url_id']+"/cache", http.responseText)
                    if (data.checksum !== undefined) {
                        configSet(conf_data['url_id']+"/checksum", data.checksum)
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

    function getFavorites(url_id) {
        return JSON.parse(configGet(url_id+"/favorites", "[]"));
    }

    function setFavorites(url_id, _fav) {
        configSet(url_id+"/favorites", JSON.stringify(_fav));
    }

    function updateUIConference(conf_data) {
        console.log(JSON.stringify(conf_data))
        conferenceDetailPage.name = conf_data['name'];
        conferenceDetailPage.url_id = (conf_data['url_id'] !== undefined) ? conf_data['url_id'] : '';
        conferenceDetailPage.feedback_url = (conf_data['url_feedback'] !== undefined) ? conf_data['url_feedback'] : '';
        conferenceDetailPage.reload(data);
        schedulePage.reloadFavorites(getFavorites(conf_data['url_id']));
        schedulePage.reload(data)
        mapPage.reload(data);

    }

    function updateUI() {

        conferenceListPage.reload(conferences)

        //        coverPage.reload(data)
        //        coverPage.coundownTarget = data.days[0]

        //        secondPage.load(data.events);
    }

    function getSpeakerDetail(name) {
        var usersArray = data.users
        for (var i = 0; i < usersArray.length; i++) {
            var user = usersArray[i];
            if (user.username === name) {
                return user;
            }
        }
    }
}
