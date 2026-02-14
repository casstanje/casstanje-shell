pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import './../'

Singleton {
    id: root
    property string time: Qt.formatDateTime(clock.date, Config.dateTimeFormat).toLowerCase()
    property string year: Qt.formatDateTime(clock.date, "yyyy").toLowerCase()
    property string date: Qt.formatDateTime(clock.date, "MMMM d.").toLowerCase()
    property string justTime: Qt.formatDateTime(clock.date, "hh:mm").toLowerCase()
    property string seconds: Qt.formatDateTime(clock.date, "ss").toLowerCase()

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}