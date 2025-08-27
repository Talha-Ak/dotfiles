import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: root

    default property alias items: containment.data
    readonly property bool isMaximised: ToplevelManager.activeToplevel?.maximized ?? false

    implicitHeight: 40
    anchors {
        top: true
        left: true
        right: true
    }

    color: "transparent"

    property real maximiseInterp: isMaximised ? 0 : 1
    Behavior on maximiseInterp {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutQuad
        }
    }

    readonly property Tooltip tooltip: tooltip
    readonly property real tooltipY: height
    Tooltip {
        id: tooltip
        bar: root
    }

    function boundedX(targetX: real, width: real): real {
        return Math.max(bg.anchors.leftMargin + width, Math.min(bg.width + bg.anchors.leftMargin - width, targetX));
    }

    Rectangle {
        id: bg
        anchors.fill: parent

        anchors.topMargin: 5 * root.maximiseInterp
        anchors.leftMargin: 6 * root.maximiseInterp
        anchors.rightMargin: 6 * root.maximiseInterp

        color: "#b31e1e2e"
        radius: 8 * root.maximiseInterp

        Item {
            id: containment

            anchors {
                fill: parent
                leftMargin: 8
                rightMargin: 8
            }
        }
    }
}
