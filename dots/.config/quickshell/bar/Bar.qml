import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.utils

BarContainer {
    id: root

    RowLayout {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        spacing: 4

        StyledText {
            text: " "
            font.pointSize: 14
        }

        Workspaces {
            Layout.fillHeight: true
        }
    }

    RowLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            bottom: parent.bottom
        }

        WindowTitle {}
    }

    RowLayout {
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        spacing: 8

        // Layout.fillHeight: true
        SystemTray {}

        Power {
            bar: root
            Layout.fillHeight: true
        }

        Clock {}
    }
}
