pragma Singleton

import Quickshell
import QtQuick

Singleton {
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    function format(fmt: string): string {
        return Qt.formatDateTime(clock.date, fmt);
    }
}
