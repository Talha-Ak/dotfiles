pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "d MMM | hh:mm ap");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
