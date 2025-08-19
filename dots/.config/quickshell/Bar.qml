import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Scope {
    Variants {
        model: Quickshell.screens

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

                StyledText {
                    id: logo

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8

                    text: " "
                    font.pointSize: 14
                }

                StyledText {
                    id: workspaces
                    text: Hyprland.focusedWorkspace?.id ?? ""
                    anchors.left: logo.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 8
                    font.pointSize: 14
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
                        id: time
                        text: Time.format("dd/MM/yy\n   hh:mm")
                        font.pointSize: 8
                    }
                }
            }
        }
    }
}
