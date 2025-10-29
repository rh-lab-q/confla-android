/* -*- coding: utf-8-unix -*-
 *
 * Copyright (C) 2018 Rinigus
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import QtQuick.Window 2.2
import Lomiri.Components 1.3
import Lomiri.Components.Themes 1.3

QtObject {
    // font sizes and family
    property string themeFontFamily: Qt.application.font.family
    property string themeFontFamilyHeading: Qt.application.font.family
    property int  themeFontSizeHuge: themeFontSizeExtraLarge*1.2
    property int  themeFontSizeExtraLarge: FontUtils.sizeToPixels("x-large")
    property int  themeFontSizeLarge: FontUtils.sizeToPixels("large")
    property int  themeFontSizeMedium: FontUtils.sizeToPixels("medium")
    property int  themeFontSizeSmall: FontUtils.sizeToPixels("small")
    property int  themeFontSizeExtraSmall: FontUtils.sizeToPixels("x-small")
    property real themeFontSizeOnMap: themeFontSizeSmall

    // colors
    // block background (navigation, poi panel, bubble)
    property color blockBg: theme.palette.normal.background
    // variant of navigation icons
    property string navigationIconsVariant: darkTheme ? "white" : "black"
    // descriptive items
    property color themeHighlightColor: theme.palette.normal.backgroundText
    // navigation items (to be clicked)
    property color themePrimaryColor: theme.palette.normal.baseText
    // navigation items, secondary
    property color themeSecondaryColor: theme.palette.normal.baseText
    // descriptive items, secondary
    property color themeSecondaryHighlightColor: theme.palette.normal.activity;

    // button sizes
    property real themeButtonWidthLarge: units.gridUnit*32
    property real themeButtonWidthMedium: units.gridUnit*22

    // icon sizes
    property real themeIconSizeLarge: units.gridUnit*7
    property real themeIconSizeMedium: units.gridUnit*5
    property real themeIconSizeSmall: units.gridUnit*4

    // used icons
    property string iconBluetooth: "image://theme/bluetooth-active"
    property string iconBattery: "image://theme/battery-good-symbolic"
    property string iconSteps: "qrc:///qml/custom-icons/icon-m-steps2.png"
    property string iconHeartrate: "qrc:///qml/custom-icons/icon-m-heartrate2.png"
    property string iconDeviceScan: "image://theme/toolkit_input-search"


    property string iconStravaLogin: "image://theme/user-admin"
    property string iconUploadToStrava: "image://theme/share"
    property string iconDownloadData: "image://theme/transfer-progress-download"
    property string iconAbout: "image://theme/info" //Qt.resolvedUrl("../../icons/help-about-symbolic.svg")
    property string iconBack: "image://theme/back" //Qt.resolvedUrl("../../icons/go-previous-symbolic.svg")
    property string iconBackward: "image://theme/back"
    property string iconClear: "image://theme/edit-delete" //Qt.resolvedUrl("../../icons/edit-delete-symbolic.svg")
    property string iconClose: "image://theme/close" //Qt.resolvedUrl("../../icons/window-close-symbolic.svg")
    property string iconDelete: "image://theme/delete" //Qt.resolvedUrl("../../icons/edit-delete-symbolic.svg")
    property string iconDown: "image://theme/down" //Qt.resolvedUrl("../../icons/go-down-symbolic.svg")
    property string iconEdit: "image://theme/edit" //Qt.resolvedUrl("../../icons/document-edit-symbolic.svg")
    property string iconEditClear: "image://theme/edit-clear" //Qt.resolvedUrl("../../icons/edit-clear-symbolic.svg")
    property string iconEmail: "image://theme/mail-read-symbolic"
    property string iconFavorite: "image://theme/bookmark-new-symbolic" // Qt.resolvedUrl("../icons/uuitk/bookmark-new-symbolic.svg")
//    property string iconFavoriteSelected: Qt.resolvedUrl("../icons/uuitk/user-bookmarks-symbolic.svg")
    property string iconForward: "image://theme/next" //Qt.resolvedUrl("../../icons/go-next-symbolic.svg")
    property string iconMenu: "image://theme/navigation-menu" //Qt.resolvedUrl("../../icons/open-menu-symbolic.svg")
    property string iconPause: "image://theme/media-playback-pause" //Qt.resolvedUrl("../../icons/media-playback-pause-symbolic.svg")
    property string iconPhone: "image://theme/call-start" //Qt.resolvedUrl("../../icons/call-start-symbolic.svg")
    property string iconPreferences: "image://theme/settings" //Qt.resolvedUrl("../../icons/preferences-system-symbolic.svg")
    property string iconRefresh: "image://theme/view-refresh" //Qt.resolvedUrl("../../icons/view-refresh-symbolic.svg")
    property string iconSave: "image://theme/save" //Qt.resolvedUrl("../../icons/document-save-symbolic.svg")
    property string iconSearch: "image://theme/find" //Qt.resolvedUrl("../../icons/edit-find-symbolic.svg")
    property string iconShare: "image://theme/share" //Qt.resolvedUrl("../../icons/emblem-shared-symbolic.svg")
    property string iconStart: "image://theme/media-playback-start" //Qt.resolvedUrl("../../icons/media-playback-start-symbolic.svg")
    property string iconStop: "image://theme/media-playback-stop" //Qt.resolvedUrl("../../icons/media-playback-stop-symbolic.svg")
    property string iconUp: "image://theme/up"
    property string iconWebLink: "image://theme/stock_website" //Qt.resolvedUrl("../../icons/web-browser-symbolic.svg")

    property string iconContact: "image://theme/preferences-desktop-accounts-symbolic"    // "User Settings"
    property string iconWatch: "image://theme/smartwatch-symbolic"                        // "Device settings"
    property string iconLevels: "image://theme/settings"                                  // "Application settings"
    property string iconAlarm: "image://theme/alarm"                                      // "Alarms"
    property string iconWeather: "image://theme/weather-app-symbolic"                     // "Weather"
    property string iconStrava: "image://theme/transfer-progress"                         // "Strava"
    property string iconDiagnostic: "image://theme/info"                                  // "Debug Info"
    property string iconFavoriteSelected: "image://theme/bookmark"                        // "Donate"

    property string customIconPrefix: "qrc:///qml/custom-icons/"
    property string customIconSuffix: ".png"

    property string iconLocation: "image://theme/location"
    property string iconClock: "image://theme/clock"

    // item sizes
    property real themeItemSizeLarge: themeFontSizeLarge * 3
    property real themeItemSizeSmall: themeFontSizeMedium * 3
    property real themeItemSizeExtraSmall: themeFontSizeSmall * 3

    // paddings and page margins
    property real themeHorizontalPageMargin: units.gridUnit*2
    property real themePaddingLarge: units.gridUnit*2
    property real themePaddingMedium: units.gridUnit*1
    property real themePaddingSmall: units.gridUnit*0.8

    property real themePixelRatio: units.gridUnit / 8.0

    property bool darkTheme: (blockBg.r + blockBg.g + blockBg.b) <
                             (themePrimaryColor.r + themePrimaryColor.g +
                              themePrimaryColor.b)
}
