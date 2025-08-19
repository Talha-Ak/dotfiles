import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.utils

PanelWindow {
    required property var modelData
    screen: modelData
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 40

    BarContainer {
        id: bar
        anchors.fill: parent

        RowLayout {
            anchors {
                left: bar.left
                top: bar.top
                bottom: bar.bottom

                leftMargin: 8
            }
            spacing: 8

            StyledText {
                text: " "
                font.pointSize: 14
            }

            Workspaces {
                Layout.fillHeight: true
            }
        }

        WindowTitle {
            anchors.centerIn: parent
        }

        RowLayout {
            anchors.right: bar.right
            anchors.verticalCenter: bar.verticalCenter
            anchors.rightMargin: 8
            spacing: 16

            SystemTray {
                Layout.fillHeight: true
            }

            StyledText {
                text: Time.format("dd/MM/yy\n   hh:mm")
                font.pointSize: 8
            }
        }
    }
}
