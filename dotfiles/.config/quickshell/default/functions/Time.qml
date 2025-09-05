pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import './../'

Singleton {
    id: root
    property string time: Qt.formatDateTime(clock.date, Config.dateTimeFormat).toLowerCase()

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}