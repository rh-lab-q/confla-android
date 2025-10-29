import QtQuick 2.0
import "functions.js" as F
import cz.mlich 1.0


Rectangle {
    id: pinchmap;

    property int zoomLevel: 13;
    property int oldZoomLevel: 99
    property int maxZoomLevel: 17;
    property int minZoomLevel: 2;
    property int minZoomLevelShowGeocaches: 9;
    property int tileSize: 512;
    property int cornerTileX: 32;
    property int cornerTileY: 32;
    property int numTilesX: Math.ceil(width/tileSize) + 2;
    property int numTilesY: Math.ceil(height/tileSize) + 2;
    property int maxTileNo: Math.pow(2, zoomLevel) - 1;
    property bool showTargetIndicator: false;
    property bool targetDragable: false;
    property double targetLat
    property double targetLon

    property bool mapDisabled: false; // tiles should be visible by default

    property bool showPositionError: true
    property bool showCurrentPosition: true;
    property bool currentPositionValid: false;
    property double currentPositionLat
    property double currentPositionLon
    property double currentPositionAzimuth: 0;
    property double currentPositionError: 0;
    property double currentPositionSpeed: 0;
    property double currentPositionAltitude: 0;

    property bool rotationEnabled: false

    property bool pageActive: false;
    property bool mapTileVisible: pageActive

    //    onTargetLatChanged: { latitude = targetLat;  }
    //    onTargetLonChanged: { longitude = targetLon; }

    property double latitude: currentPositionLat ;// FlightData.configGet("currentPositionLat", 49.803575)
    property double longitude: currentPositionLon;// FlightData.configGet("currentPositionLon", 15.475555)

    property variant scaleBarLength: getScaleBarLength(latitude);

    property alias angle: rot.angle

    property string remoteUrl: "http://a.tile.openstreetmap.org/%(zoom)d/%(x)d/%(y)d.png";
    property string localUrl: ":/Maps/OSM/%(zoom)d/%(x)d/%(y)d.png"

    property int earthRadius: 6371000

    property bool needsUpdate: false;
    property alias places: placesModel;
    property alias attribution: attributionText.text;

    signal mapItemClicked(string name, string description, url icon, double lat, double lon);

    ListModel {
        id: placesModel;
    }


    signal pannedManually

    transform: Rotation {
        angle: 0
        origin.x: pinchmap.width/2
        origin.y: pinchmap.height/2
        id: rot
    }

    onMaxZoomLevelChanged: {
        if (pinchmap.maxZoomLevel < pinchmap.zoomLevel) {
            setZoomLevel(maxZoomLevel);
        }
    }

    onPageActiveChanged:  {
        mapTileVisible = pageActive

        if (pageActive && needsUpdate) {
            needsUpdate = false;
            pinchmap.setCenterLatLon(pinchmap.latitude, pinchmap.longitude);
        }
    }
    
    onWidthChanged: {
        if (!pageActive) {
            needsUpdate = true;
        } else {
            pinchmap.setCenterLatLon(pinchmap.latitude, pinchmap.longitude);
        }
    }

    onHeightChanged: {
        if (!pageActive) {
            needsUpdate = true;
        } else {
            pinchmap.setCenterLatLon(pinchmap.latitude, pinchmap.longitude);
        }
    }



    function setZoomLevel(z) {
        setZoomLevelPoint(z, pinchmap.width/2, pinchmap.height/2);
    }

    function zoomIn() {
        setZoomLevel(pinchmap.zoomLevel + 1)
    }

    function zoomOut() {
        setZoomLevel(pinchmap.zoomLevel - 1)
    }

    function setZoomLevelPoint(z, x, y) {
        if (z === zoomLevel) {
            return;
        }
        if (z < pinchmap.minZoomLevel || z > pinchmap.maxZoomLevel) {
            return;
        }
        var p = getCoordFromScreenpoint(x, y);
        zoomLevel = z;
        setCoord(p, x, y);
    }

    function pan(dx, dy) {
        map.offsetX -= dx;
        map.offsetY -= dy;
    }

    function panEnd() {
        var changed = false;
        var threshold = pinchmap.tileSize;

        while (map.offsetX < -threshold) {
            map.offsetX += threshold;
            cornerTileX += 1;
            changed = true;
        }
        while (map.offsetX > threshold) {
            map.offsetX -= threshold;
            cornerTileX -= 1;
            changed = true;
        }

        while (map.offsetY < -threshold) {
            map.offsetY += threshold;
            cornerTileY += 1;
            changed = true;
        }
        while (map.offsetY > threshold) {
            map.offsetY -= threshold;
            cornerTileY -= 1;
            changed = true;
        }
        updateCenter();
    }

    function updateCenter() {
        var l = getCenter()
        longitude = l[1]
        latitude = l[0]
        //        updateGeocaches();
    }

    function requestUpdate() {
        var start = getCoordFromScreenpoint(0,0)
        var end = getCoordFromScreenpoint(pinchmap.width,pinchmap.height)
        //         controller.updateGeocaches(start[0], start[1], end[0], end[1])
        //        updateGeocaches()
        console.debug("Update requested.")
    }

    function requestUpdateDetails() {
        var start = getCoordFromScreenpoint(0,0)
        var end = getCoordFromScreenpoint(pinchmap.width,pinchmap.height)
        //        controller.downloadGeocaches(start[0], start[1], end[0], end[1])
        console.debug("Download requested.")
    }

    function getScaleBarLength(lat) {
        var destlength = width/5;
        var mpp = getMetersPerPixel(lat);
        var guess = mpp * destlength;
        var base = 10 * -Math.floor(Math.log(guess)/Math.log(10) + 0.00001)
        var length_meters = Math.round(guess/base)*base
        var length_pixels = length_meters / mpp
        return [length_pixels, length_meters]
    }

    function getMetersPerPixel(lat) {
        return Math.cos(lat * Math.PI / 180.0) * 2.0 * Math.PI * earthRadius / (256 * (maxTileNo + 1))
    }

    function deg2rad(deg) {
        return deg * (Math.PI /180.0);
    }

    function deg2num(lat, lon) {
        var rad = deg2rad(lat % 90);
        var n = maxTileNo + 1;
        var xtile = ((lon % 180.0) + 180.0) / 360.0 * n;
        var ytile = (1.0 - Math.log(Math.tan(rad) + (1.0 / Math.cos(rad))) / Math.PI) / 2.0 * n;
        return [xtile, ytile];
    }

    function setLatLon(lat, lon, x, y) {
        var oldCornerTileX = cornerTileX
        var oldCornerTileY = cornerTileY
        var tile = deg2num(lat, lon);
        var cornerTileFloatX = tile[0] + (map.rootX - x) / tileSize // - numTilesX/2.0;
        var cornerTileFloatY = tile[1] + (map.rootY - y) / tileSize // - numTilesY/2.0;
        cornerTileX = Math.floor(cornerTileFloatX);
        cornerTileY = Math.floor(cornerTileFloatY);
        map.offsetX = -(cornerTileFloatX - Math.floor(cornerTileFloatX)) * tileSize;
        map.offsetY = -(cornerTileFloatY - Math.floor(cornerTileFloatY)) * tileSize;
        updateCenter();
    }

    function setCoord(c, x, y) {
        setLatLon(c[0], c[1], x, y);
    }

    function setCenterLatLon(lat, lon) {
        setLatLon(lat, lon, pinchmap.width/2, pinchmap.height/2);
    }

    function setCenterCoord(c) {
        setCenterLatLon(c[0], c[1]);
    }

    function getCoordFromScreenpoint(x, y) {
        var realX = - map.rootX - map.offsetX + x;
        var realY = - map.rootY - map.offsetY + y;
        var realTileX = cornerTileX + realX / tileSize;
        var realTileY = cornerTileY + realY / tileSize;
        return num2deg(realTileX, realTileY);
    }

    function getScreenpointFromCoord(lat, lon) {
        var tile = deg2num(lat, lon)
        var realX = (tile[0] - cornerTileX) * tileSize
        var realY = (tile[1] - cornerTileY) * tileSize
        var x = realX + map.rootX + map.offsetX
        var y = realY + map.rootY + map.offsetY
        return [x, y]
    }

    function getMappointFromCoord(lat, lon) {
        //        console.count()
        var tile = deg2num(lat, lon)
        var realX = (tile[0] - cornerTileX) * tileSize
        var realY = (tile[1] - cornerTileY) * tileSize
        return [realX, realY]
        
    }

    function getCenter() {
        return getCoordFromScreenpoint(pinchmap.width/2, pinchmap.height/2);
    }

    function sinh(aValue) {
        return (Math.pow(Math.E, aValue)-Math.pow(Math.E, -aValue))/2;
    }

    function num2deg(xtile, ytile) {
        var n = Math.pow(2, zoomLevel);
        var lon_deg = xtile / n * 360.0 - 180;
        var lat_rad = Math.atan(sinh(Math.PI * (1 - 2 * ytile / n)));
        var lat_deg = lat_rad * 180.0 / Math.PI;
        return [lat_deg % 90.0, lon_deg % 180.0];
    }

    function tileUrl(tx, ty) {
        if (mapDisabled) {
            return "./images/noimage-disabled.png"
        }

        if (tx < 0 || tx > maxTileNo) {
            return "./images/noimage.png"
        }

        if (ty < 0 || ty > maxTileNo) {
            return "./images/noimage.png"
        }
        var local = F.getMapTile(localUrl, tx, ty, zoomLevel);
        var remote = F.getMapTile(remoteUrl, tx, ty, zoomLevel);

        //        if (!file_reader.file_exists(local)) {
        //            console.log ("wget "+remote + " --output-document=" +local )
        //        }
        //        return remote;
        return (file_reader.file_exists_local(local)) ? ("qrc"+local) : remote
//        return remote;
    }

    function imageStatusToString(status) {
        switch (status) {
            //% "Ready"
        case Image.Ready: return qsTrId("image-status-ready");
            //% "Not Set"
        case Image.Null: return qsTrId("image-status-not-set");
            //% "Error"
        case Image.Error: return qsTrId("image-status-error");
            //% "Loading ..."
        case Image.Loading: return qsTrId("image-status-loading");
            //% "Unknown"
        default: return qsTrId("image-status-unknown");
        }
    }


    //    ColorModification {
    //        id: colorModification
    //    }


    Grid {

        id: map;
        columns: numTilesX;
        width: numTilesX * tileSize;
        height: numTilesY * tileSize;
        property int rootX: -(width - parent.width)/2;
        property int rootY: -(height - parent.height)/2;
        property int offsetX: 0;
        property int offsetY: 0;
        x: rootX + offsetX;
        y: rootY + offsetY;


        Repeater {
            id: tiles


            model: (pinchmap.numTilesX * pinchmap.numTilesY);
            Rectangle {
                id: tile
                property alias source: img.source;
                property int tileX: cornerTileX + (index % numTilesX)
                property int tileY: cornerTileY + Math.floor(index / numTilesX)

                Rectangle {
                    id: progressBar;
                    property real p: 0;
                    height: 16;
                    width: parent.width - 32;
                    anchors.centerIn: img;
                    color: "#c0c0c0";
                    border.width: 1;
                    border.color: "#000000";
                    Rectangle {
                        anchors.left: parent.left;
                        anchors.margins: 2;
                        anchors.top: parent.top;
                        anchors.bottom: parent.bottom;
                        width: (parent.width - 4) * progressBar.p;
                        color: "#000000";
                    }
                    visible: mapTileVisible
                }
                Text {
                    anchors.top: progressBar.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    y: parent.height/2 - 32
                    text: imageStatusToString(img.status)
                    visible: mapTileVisible
                }

                Image {
                    visible: (img.visible) && (img.status === Image.Null)
                    source: "./images/noimage.png"
                }


                Image {
                    id: img;
                    anchors.fill: parent;
                    onProgressChanged: { progressBar.p = progress }
                    source: mapTileVisible ? tileUrl(tileX, tileY) : "";
                    visible: mapTileVisible;
                }


                width: tileSize;
                height: tileSize;
                color: "#c0c0c0";
            }

        }
    }

    //        Item {
    //            id: waypointDisplayContainer
    //            Repeater {
    //                id: waypointDisplay
    //                delegate: Waypoint {
    //                    coordinate: model.coordinate
    //                    targetPoint: getMappointFromCoord(model.coordinate.lat, model.coordinate.lon)
    //                    verticalSpacing: model.numSimilar
    //                    z: 2000
    //                }
    //            }
    //        }

    Image {
        id: targetIndicator
        source: "./images/target-indicator-cross.png"
        property variant t: getMappointFromCoord(targetLat, targetLon)
        x: map.x + t[0] - width/2
        y: map.y + t[1] - height/2

        visible: showTargetIndicator
        transform: Rotation {
            id: rotationTarget
            origin.x: targetIndicator.width/2
            origin.y: targetIndicator.height/2
        }
    }

    Image {
        id: positionIndicator
//        source: currentPositionValid ? "./images/position-circle.png" : "./images/position-circle-red.png"
        source: "./images/target-indicator-cross.png";
        property variant t: getMappointFromCoord(currentPositionLat, currentPositionLon)
        x: map.x + t[0] - width/2
        y: map.y + t[1] - height + positionIndicator.width/2
        smooth: true

        visible: showCurrentPosition
        transform: Rotation {
            origin.x: positionIndicator.width/2
            origin.y: positionIndicator.height - positionIndicator.width/2
            angle: currentPositionAzimuth
        }
    }

    Repeater {
        model: placesModel;
        delegate: Item {
            Image {
                id: placesDelegate
                source: model.icon;
                property variant t: getMappointFromCoord(model.lat, model.lon)
                x: map.x + t[0] - width/2
                y: map.y + t[1] - height;
                smooth: true
            }
            Image {
                x: placesDelegate.x;
                y: placesDelegate.y
                source: "./images/marker-icon.png"
                visible:( placesDelegate.status !== Image.Ready)
            }
        }
    }

    Rectangle {
        id: scaleBar
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.topMargin: 16
        anchors.top: parent.top
        color: "black"
        border.width: 2
        border.color: "white"
        smooth: false
        height: 4
        width: scaleBarLength[0]
    }

    Text {
        text: F.formatDistance(scaleBarLength[1], {'distanceUnit':'m'})
        anchors.horizontalCenter: scaleBar.horizontalCenter
        anchors.top: scaleBar.bottom
        anchors.topMargin: 8
        style: Text.Outline
        styleColor: "white"
        font.pixelSize: 24
    }


    PinchArea {
        id: pincharea;
        anchors.fill: parent;

        property double __oldZoom;


        function calcZoomDelta(p) {
            pinchmap.setZoomLevelPoint(Math.round((Math.log(p.scale)/Math.log(2)) + __oldZoom), p.center.x, p.center.y);
            if (rotationEnabled) {
                rot.angle = p.rotation
            }
            pan(p.previousCenter.x - p.center.x, p.previousCenter.y - p.center.y);
        }

        onPinchStarted: {
            __oldZoom = pinchmap.zoomLevel;
        }

        onPinchUpdated: {
            calcZoomDelta(pinch);
        }

        onPinchFinished: {
            calcZoomDelta(pinch);
        }

        MouseArea {
            id: mousearea;

            property bool __isPanning: false;
            property bool __draging: false;
            property int __lastX: -1;
            property int __lastY: -1;
            property int __firstX: -1;
            property int __firstY: -1;
            property bool __wasClick: false;
            property int maxClickDistance: 80;

            anchors.fill : parent;
            preventStealing: true;

            onWheel:  {
                var zoom_diff = (wheel.angleDelta.y > 0) ? 1 : -1;
                setZoomLevelPoint(pinchmap.zoomLevel + zoom_diff, wheel.x, wheel.y);
            }


            onPressed: {
                pannedManually()

                var distance = F.euclidDistance(targetIndicator.x, targetIndicator.y, mouse.x, mouse.y);
                if (targetDragable && (distance < maxClickDistance)) { // dragThreshold
                    __draging = true;
                } else {
                    __isPanning = true;
                }
                __lastX = mouse.x;
                __lastY = mouse.y;
                __firstX = mouse.x;
                __firstY = mouse.y;
                __wasClick = true;
            }

            onReleased: {

                if (F.euclidDistance(__firstX, __firstY, mouse.x, mouse.y) < 40) { // if not panning

                    // find nearest place
                    if (places.count > 0) {
                        var minIndex = 0;
                        var item = places.get(0);
                        var screen = getScreenpointFromCoord(item.lat, item.lon);
                        var distance = F.euclidDistance(mouse.x, mouse.y, screen[0], screen[1]);
                        var minDistance = distance;
                        for (var i = 1; i < places.count; i++) {
                            item = places.get(i)
                            screen = getScreenpointFromCoord(item.lat, item.lon);
                            distance = F.euclidDistance(mouse.x, mouse.y, screen[0], screen[1]);
                            if (distance < minDistance) {
                                minDistance = distance;
                                minIndex = i;
                            }
                        }

                        if (minDistance < maxClickDistance) {
                            item = places.get(minIndex);
                            mapItemClicked(item.name, item.description, item.icon, item.lat, item.lon)
                        }
                    }
                }


                if (__isPanning) {
                    panEnd();
                }
                if (__draging) {
                    var pos = getCoordFromScreenpoint(mouse.x, mouse.y)
                    targetLat = pos[0]
                    targetLon = pos[1]
                }

                __isPanning = false;
                __draging = false;

            }

            onPositionChanged: {
                if (__isPanning) {
                    var dx = mouse.x - __lastX;
                    var dy = mouse.y - __lastY;
                    pan(-dx, -dy);
                    __lastX = mouse.x;
                    __lastY = mouse.y;
                    /*
                    once the pan threshold is reached, additional checking is unnecessary
                    for the press duration as nothing sets __wasClick back to true
                    */
                    if (__wasClick && Math.pow(mouse.x - __firstX, 2) + Math.pow(mouse.y - __firstY, 2) > maxClickDistance) {
                        __wasClick = false;
                    }
                }
                if (__draging) {
                    var pos = getCoordFromScreenpoint(mouse.x, mouse.y)
                    targetLat = pos[0]
                    targetLon = pos[1]
                }
            }

            onCanceled: {
                __isPanning = false;
                __draging = false;
            }
        }

    }

    Text {
        id: attributionText
        anchors.left: parent.left;
        anchors.bottom: parent.bottom;
        anchors.margins: 3;
        text : "© OpenStreetMap contributors"
    }


    FileReader {
        id: file_reader;
    }
}
