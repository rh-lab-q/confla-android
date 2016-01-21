import QtQuick 2.0
import QtPositioning 5.0
import "Theme.js" as Theme

Page {
    id: page;

    property alias deviceLat: map.currentPositionLat
    property alias deviceLon: map.currentPositionLon
    property alias mapWidget: map;
    property bool pageActive: true;
    property bool map_visible: false;

    signal showDetail(string name, string description, url icon, double lat, double lon);

    Flickable {
        anchors.fill: parent;
        contentHeight: map_visible ? page.height : (pageHeader.height + listColumn.height)


        PageHeader {
            id: pageHeader;
            //% "Places"
            title: qsTrId("map-title")
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    map_visible = !map_visible;
                }
            }
        }

        Column {
            id: listColumn
            anchors.top: pageHeader.bottom;
            visible: !map_visible;
            width: page.width


            Repeater {
                model: map.places;
                delegate: BackgroundItem {
                    id: delegate;
                    width: page.width
                    height: Math.max(placesDelegate.height, placesDelegateTitle.paintedHeight)  + Theme.paddingSmall
                    Image {
                        id: placesDelegate
                        anchors.left: parent.left;
                        anchors.verticalCenter: parent.verticalCenter;
                        anchors.margins: Theme.paddingSmall;
                        source: model.icon;
                        smooth: true
                        fillMode: Image.PreserveAspectFit
                        width: 0.5 * dpix;
                        height: 0.5 * dpiy;


                    }
                    Image {
                        anchors.centerIn: placesDelegate;
                        source: "qrc:/images/marker-icon.png"
                        visible:( placesDelegate.status !== Image.Ready)
                        width: placesDelegate.width;
                        height: placesDelegate.height;
                        fillMode: Image.PreserveAspectFit
                    }


                    Text {
                        id: placesDelegateTitle
                        anchors.left: placesDelegate.right
                        anchors.right: parent.right;
                        anchors.top: parent.top;
                        anchors.bottom: parent.bottom;
                        verticalAlignment: Text.AlignVCenter;
                        color: delegate.highlighted ? Theme.primary_color_highlight : Theme.primary_color
                        font.pointSize: Theme.primary_pointSize

                        wrapMode: Text.Wrap;
                        text: model.name;
                    }
                    onClicked: {
                        showDetail(model.name, model.description, model.icon, model.lat, model.lon);
                        map.setCenterLatLon(lat, lon)
                    }
                }
            }
        }


        PinchMap {

            id: map
            anchors.top: pageHeader.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            clip: true;
            visible: map_visible;
            pageActive: map_visible && page.pageActive;
            //                        && (page.status !== PageStatus.Inactive)

            onMapItemClicked: {

                showDetail(name, description, icon, lat, lon);

            }

        }
    }


    Button {
        id: switchToListBtn
        image: map_visible ? "./images/ic_list_white_48dp.png" : "./images/ic_map_white_48dp.png"
        anchors.bottom: parent.bottom;
        anchors.right: parent.right;
        onClicked: {
            map_visible = !map_visible;
        }
    }

    Button {
        visible: map_visible;
        image: "./images/ic_gps_fixed_white_48dp.png"
        anchors.right: switchToListBtn.left;
        anchors.bottom: parent.bottom
        onClicked: {
            map.setCenterLatLon(map.currentPositionLat, map.currentPositionLon);
        }
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: map_visible;
        onPositionChanged: {
            var coord = position.coordinate;
            map.currentPositionLat = coord.latitude;
            map.currentPositionLon = coord.longitude;
            map.currentPositionValid = position.latitudeValid
        }
    }

    function reload(d) {
        if (d.places !== undefined) {
            map.places.clear();
            var places = d.places;
            for (var i = 0; i < places.length; i++) {
                var item = places[i];
                map.places.append(item);
            }
        }
    }


}
