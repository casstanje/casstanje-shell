pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root
  readonly property string time: {
    Qt.formatDateTime(clock.date, "ddd dd/MM/yy | hh:mm")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}