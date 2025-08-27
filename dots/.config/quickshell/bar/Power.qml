pragma ComponentBehavior: Bound

import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import qs.utils

// TODO: Mousearea does not send signals on start.

MouseArea {
    id: root
    required property var bar

    readonly property var chargeState: UPower.displayDevice.state
    readonly property bool isCharging: chargeState == UPowerDeviceState.Charging
    readonly property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    readonly property real percentage: UPower.displayDevice.percentage
    readonly property real watts: UPower.displayDevice.changeRate
    readonly property real timeToEmpty: UPower.displayDevice.timeToEmpty
    readonly property real timeToFull: UPower.displayDevice.timeToFull

    function statusStr() {
        const power = root.isPluggedIn ? `Plugged in, ${root.isCharging ? "Charging" : "Not Charging"}` : "Discharging";
        const watts = `(${Math.round(root.watts * 10) / 10}W)`;
        return power + " " + watts;
    }

    function timeLeft() {
        return Math.round((root.isCharging ? root.timeToFull : root.timeToEmpty) / 60);
    }

    implicitWidth: Math.max(batPercent.implicitWidth, batIcon.implicitWidth)

    hoverEnabled: true

    function getIcon() {
        const v = root.percentage;
        if (v >= 0.95)
            return root.isCharging ? "󰂅" : "󰁹";
        else if (v > 0.85)
            return root.isCharging ? "󰂋" : "󰂂";
        else if (v > 0.75)
            return root.isCharging ? "󰂊" : "󰂁";
        else if (v > 0.65)
            return root.isCharging ? "󰢞" : "󰂀";
        else if (v > 0.55)
            return root.isCharging ? "󰂉" : "󰁿";
        else if (v > 0.45)
            return root.isCharging ? "󰢝" : "󰁾";
        else if (v > 0.35)
            return root.isCharging ? "󰂈" : "󰁽";
        else if (v > 0.25)
            return root.isCharging ? "󰂇" : "󰁼";
        else if (v > 0.15)
            return root.isCharging ? "󰂆" : "󰁻";
        else if (v > 0.05)
            return root.isCharging ? "󰢜" : "󰁺";
        else
            return root.isCharging ? "󰢟" : "󱃍";
    }

    onEntered: bar.tooltip.setItem(tooltip)
    onExited: bar.tooltip.removeItem(tooltip)

    function getPercentage() {
        let percent = Math.round(root.percentage * 100);
        return `${percent}%`;
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 0

        StyledText {
            id: batIcon
            Layout.alignment: Qt.AlignHCenter
            rightPadding: 2

            text: root.getIcon()
            font.pointSize: 12
        }

        StyledText {
            id: batPercent
            text: root.getPercentage()
            font.pointSize: 7
        }
    }

    property TooltipItem tooltip: TooltipItem {
        tooltip: root.bar.tooltip
        owner: root

        ColumnLayout {
            spacing: 2
            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: root.timeLeft() + "m remaining"
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: root.statusStr()
                font.pointSize: 8
            }
        }
    }
}
