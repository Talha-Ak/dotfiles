pragma ComponentBehavior: Bound

import Quickshell.Services.UPower
import QtQuick
import qs.utils

Item {
    id: root
    property real percentage: UPower.displayDevice.percentage
    property bool charging: UPower.displayDevice.state === UPowerDeviceState.Charging || UPower.displayDevice.state === UPowerDeviceState.FullyCharged

    property Item current: icon1

    implicitHeight: current.implicitHeight
    implicitWidth: current === icon1 ? icon1.implicitWidth : icon2.implicitWidth

    function getIcon() {
        const v = root.percentage;
        if (v >= 0.95)
            return root.charging ? "󰂅" : "󰁹";
        else if (v > 0.85)
            return root.charging ? "󰂋" : "󰂂";
        else if (v > 0.75)
            return root.charging ? "󰂊" : "󰂁";
        else if (v > 0.65)
            return root.charging ? "󰢞" : "󰂀";
        else if (v > 0.55)
            return root.charging ? "󰂉" : "󰁿";
        else if (v > 0.45)
            return root.charging ? "󰢝" : "󰁾";
        else if (v > 0.35)
            return root.charging ? "󰂈" : "󰁽";
        else if (v > 0.25)
            return root.charging ? "󰂇" : "󰁼";
        else if (v > 0.15)
            return root.charging ? "󰂆" : "󰁻";
        else if (v > 0.05)
            return root.charging ? "󰢜" : "󰁺";
        else
            return root.charging ? "󰢟" : "󱃍";
    }

    onPercentageChanged: {
        const next = root.current === icon1 ? icon2 : icon1;
        next.text = getIcon();
        root.current = next;
    }

    onChargingChanged: {
        const next = root.current === icon1 ? icon2 : icon1;
        next.text = getIcon();
        root.current = next;
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }

    Icon {
        id: icon1
    }

    Icon {
        id: icon2
    }

    StyledText {
        id: text
        anchors.top: root.current.bottom
        anchors.horizontalCenter: root.horizontalCenter
        text: `${Math.round(root.percentage, 2) * 100}%`

        font.pointSize: 6
    }

    component Icon: StyledText {
        width: implicitWidth
        height: implicitHeight
        anchors.horizontalCenter: root.horizontalCenter
        text: root.getIcon()
        font.pointSize: 12

        opacity: root.current === this ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuint
            }
        }
    }
}
