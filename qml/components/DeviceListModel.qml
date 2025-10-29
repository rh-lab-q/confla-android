import QtQuick 2.0

ListModel {
    ListElement {
        deviceType: "AsteroidOS"
        icon: "../pics/devices/asteroidos.png"
        pattern: "bass|sturgeon|narwhal|sparrow|dory|lenok|catfish|carp|smelt|anthias|pike|sawfish|ray|firefish|beluga|skipjack|koi|mooneye|swift|nemo|hoki|minnow|tetra|sprat|kingyo|medaka"
    }

    ListElement {
        deviceType: "Amazfit Bip Watch"
        icon: "../pics/devices/amazfit-bip.png"
        pattern: "^Amazfit Bip Watch$"
    }

    ListElement {
        deviceType: "Amazfit Bip Lite"
        icon: "../pics/devices/amazfit-bip.png"
        auth: true
        pattern: "^Amazfit Bip Lite$"
    }

    ListElement {
        deviceType: "Amazfit Bip S"
        icon: "../pics/devices/amazfit-bips.png"
        auth: true
        pattern: "^Amazfit Bip S$"
    }

    ListElement {
        deviceType: "Amazfit GTS"
        icon: "../pics/devices/amazfit-gts.png"
        auth: true
        pattern: "^Amazfit GTS$"
    }

    ListElement {
        deviceType: "Amazfit Neo"
        icon: "../pics/devices/amazfit-neo.png"
        auth: true
        pattern: "^Amazfit Neo$"
    }

    ListElement {
        deviceType: "Amazfit GTS 2"
        icon: "../pics/devices/amazfit-gts2.png"
        auth: true
        pattern: "^Amazfit GTS 2$"
    }

    ListElement {
        deviceType: "Amazfit GTR 3 Pro"
        icon: "../pics/devices/amazfit-gtr3.png"
        auth: true
        pattern: "^Amazfit GTR 3 Pro$"
    }

    ListElement {
        deviceType: "Amazfit GTR"
        icon: "../pics/devices/amazfit-gtr.png"
        auth: true
        pattern: "^Amazfit GTR$"
    }

    ListElement {
        deviceType: "Amazfit GTR 2"
        icon: "../pics/devices/amazfit-gtr2.png"
        auth: true
        pattern: "^Amazfit GTR 2$"
    }

    ListElement {
        deviceType: "Amazfit Cor"
        icon: "../pics/devices/amazfit-cor.png"
        pattern: "^Amazfit Cor$"
    }

    ListElement {
        deviceType: "Mi Band 2"
        icon: "../pics/devices/miband2.png"
        pattern: "^MI Band 2$"
    }

    ListElement {
        deviceType: "Mi Band 3"
        icon: "../pics/devices/miband3.png"
        pattern: "^Mi Band 3$"
    }

    ListElement {
        deviceType: "Mi Smart Band 4"
        icon: "../pics/devices/miband4.png"
        auth: true
        pattern: "^Mi Smart Band 4$"
    }

    ListElement {
        deviceType: "Amazfit Stratos 3"
        icon: "../pics/devices/miband4.png"
        auth: true
        pattern: "^Amazfit Stratos 3$"
    }

    ListElement {
        deviceType: "Amazfit Balance"
        icon: "../pics/devices/amazfit-balance.png"
        auth: true
        pattern: "^Amazfit Balance$"
    }

    ListElement {
        deviceType: "Pebble"
        icon: "../pics/devices/pebble.png"
        auth: false
        pattern: "^Pebble Time"
    }

    ListElement {
        deviceType: "InfiniTime"
        icon: "../pics/devices/pinetime.png"
        auth: false
        pattern: "Pinetime|InfiniTime"
    }

    ListElement {
        deviceType: "Bangle.js"
        icon: "../pics/devices/banglejs.png"
        auth: false
        pattern: "Bangle\\.js.*|Pixl\\.js.*|Puck\\.js.*|MDBT42Q.*|Espruino.*"
    }

    ListElement {
        deviceType: "Kospet DK08"
        icon: "../pics/devices/kospet_dk08.png"
        auth: false
        pattern: "DK08"
    }

}
