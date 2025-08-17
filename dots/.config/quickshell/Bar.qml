import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

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

            Rectangle {
                property bool maximised: ToplevelManager.activeToplevel?.maximized
                anchors.fill: parent
                anchors.margins: maximised ? 0 : 4

                color: "#b31e1e2e"
                radius: ToplevelManager.activeToplevel?.maximized ? 0 : 8

                Behavior on anchors.margins {
                    MaximiseAnim {}
                }

                // Behavior for the radius remains the same.
                Behavior on radius {
                    MaximiseAnim {}
                }

                StyledText {
                    id: logo
                    text: " "
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 8
                    font.pixelSize: 18
                }

                StyledText {
                    id: workspaces
                    text: Hyprland.focusedWorkspace.id
                    anchors.left: logo.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 8
                    font.pixelSize: 18
                }

                WindowTitle {
                    anchors.centerIn: parent
                }

                StyledText {
                    text: Time.time
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 8
                }
            }
        }
    }

    component MaximiseAnim: NumberAnimation {
        duration: 150
        easing.type: Easing.OutQuad
    }
}
