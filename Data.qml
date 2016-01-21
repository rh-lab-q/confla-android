import QtQuick.LocalStorage 2.0 as Sql
import QtQuick 2.0

Item {

    property string dbName: "rhdevconf"
    property string dbVersion: "1.0"
    property string dbDisplayName: "rhdevconf"
    property int dbEstimatedSize: 100;

    property variant data
    property int lastUpdate: 0
    property string status: "idle"

    //    property variant secondPage




    function configSet(key, value) {
        //        console.log(key + " = " + value)

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
                        }
                        else {
                            result = default_value;
                            console.log(key + " : " + result + " (default)")
                        }
                    }
                    )
        return result;
    }

    function init_data() {
        lastUpdate = parseInt(configGet("lastUpdate", 0), 10);

        if (lastUpdate === 0) {
            read_static();
        } else {
            read_cache()
        }

        check_updates();
    }

    function read_static() {

        var url = ":/data.json";
//        if (filereader.file_exists(url)) {
            data = JSON.parse(filereader.read_local(url))
            status = "static"

            console.log("data static")

            updateUI();
//        } else {
//            console.error("file not exists " + url)
//            status = "error"
//        }

    }

    function read_cache() {
        console.log("data cache")
        data = JSON.parse(configGet("cache", "[]"))
        updateUI();
    }

    function check_updates() {
        console.log("check updates")
//        var url = "http://pcmlich.fit.vutbr.cz/devconf/?ts=1&lang="+Qt.locale().name;
//        var url = "http://pcmlich.fit.vutbr.cz/devconf/?ts=1&lang=cs_CZ" ;
        var url = "http://devconf.cz/wall/sched.org/?ts=1&lang="+Qt.locale().name;

        var http = new XMLHttpRequest()
        http.open("GET", url, true)

        status = "checking"
        http.onreadystatechange = function(){
            if (http.readyState == 4) {
                if (http.status == 200) {

                    status = "idle"
                    try {
                    var internet_timestamp = JSON.parse(http.responseText);
                    } catch (e) {
                        status = "exception"
                    }

                    if (internet_timestamp > lastUpdate) {
                        console.log("lastUpdate is old "+ internet_timestamp + " > " + lastUpdate)
                        download();
                    }

                } else { // offline or error while downloading
                    status = "offline"
                    console.log("error downloading in check_updates()")
                }
            }
        }
        http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;");
        //http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");
        //        http.send(params)
        http.send()

    }

    function download() {
        console.log("data download")

//        var url = "http://pcmlich.fit.vutbr.cz/devconf/?json=1&lang="+Qt.locale().name;
//        var url = "http://pcmlich.fit.vutbr.cz/devconf/?json=1&lang=cs_CZ";
        var url = "http://devconf.cz/wall/sched.org/?json&lang="+Qt.locale().name;
        var http = new XMLHttpRequest()
        http.open("GET", url, true)

        status = "updating"
        http.onreadystatechange = function(){
            if (http.readyState == 4) {
                if (http.status == 200) {

                    data = JSON.parse(http.responseText);

                    if (data.timestamp !== undefined) {
                        configSet("cache", http.responseText)
                        configSet("lastUpdate", data.timestamp)
                    }

                    status = "idle"
                    updateUI();
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

    function getFavorites() {
        return JSON.parse(configGet("favorites", "[]"));
    }

    function setFavorites(fav) {
        configSet("favorites",JSON.stringify(fav));
    }

    function updateUI() {

        mainPage.reload(data);
        schedulePage.reloadFavorites(getFavorites());
        schedulePage.reload(data)
        mapPage.reload(data);
//        coverPage.reload(data)
//        coverPage.coundownTarget = data.days[0]

//        secondPage.load(data.events);
    }

    function getSpeakerDetail(name) {
        var usersArray = data.users
        for (var i = 0; i < usersArray.length; i++) {
            var user = usersArray[i];
            if (user.name === name) {
                return user;
            }
        }
    }
}
