import QtQuick 2.2
import QtQuick.Controls 1.1
import cz.mlich 1.0
import "Theme.js" as Theme

ApplicationWindow {
    id: app
    visible: true
    width: 480
    height: 800
    //% "DevConf"
    title: qsTrId("application-title")
    color: Theme.background_color


    StackView {
        id: pageStack;
        initialItem: mainPage;
        anchors.fill: parent;
        width: parent.width;
        height: parent.height
    }


    MainPage {
        id: mainPage
    }

    AboutPage {
        id: aboutPage;
    }

    SchedulePage {
        id: schedulePage
        onSaveFavorites: {
            dataSource.configSet("favorites",JSON.stringify(favoritesModel));
        }

    }

    EventDetailPage {
        id: eventDetailPage;
        onAddToFavorites: {
            schedulePage.addToFavorites(hash);
        }
        onRemoveFromFavorites: {
            schedulePage.removeFromFavorites(hash);
        }
    }

    MapPage {
        id: mapPage;
        onShowDetail: {
            placesDetailPage.name = name;
            placesDetailPage.description = description;
            placesDetailPage.image = icon;
            placesDetailPage.lat = lat;
            placesDetailPage.lon = lon;
            pageStack.push(placesDetailPage)
        }
    }

    PlaceDetailPage {
        id: placesDetailPage;
        onShowOnMap: {
            mapPage.mapWidget.setZoomLevel(15)
            mapPage.mapWidget.setCenterLatLon(lat, lon);
            mapPage.map_visible = true;
            pageStack.pop();

        }
    }

    PhotoDetailPage {
        id: photoDetailPage
    }

    Data {
        id: dataSource;
    }


    Component.onCompleted: {
        dataSource.init_data()
        focusScope.forceActiveFocus();
    }


    FocusScope {
        id: focusScope;
        anchors.fill: parent;
        focus: true;

        Keys.onPressed: {

            switch (event.key ) {
            case Qt.Key_Back:
            case Qt.Key_Left:
                if (pageStack.depth > 1) {
                    event.accepted = true
                    pageStack.pop();
                }

                break;
            case Qt.Key_Right:
                break;
            }

        }
    }

    Timer {
        running: true;
        repeat: true;
        interval: 600000; // 10 minutes
        onTriggered: {
            dataSource.updateUI();
        }
    }

    FileReader {
        id: filereader;
    }

    Downloader {
        id: downloader;
    }


}
