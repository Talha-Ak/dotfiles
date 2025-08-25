import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.utils

Rectangle {
    width: layout.implicitWidth + 8
    radius: 0
    color: "#44000000"

    Behavior on width {
        NumberAnimation {
            duration: 75
            easing.type: Easing.OutQuad
        }
    }

    Row {
        id: layout
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: 8
        spacing: 4
        add: Transition {
            NumberAnimation {
                property: "scale"
                from: 0
                to: 1
                duration: 150
                easing.type: Easing.OutQuad
            }
        }

        move: Transition {
            NumberAnimation {
                properties: "scale"
                to: 1
                duration: 150
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                properties: "x,y"
                duration: 150
                easing.type: Easing.OutQuad
            }
        }

        Repeater {
            model: Hyprland.workspaces

            MouseArea {
                id: mouseArea
                required property HyprlandWorkspace modelData

                implicitWidth: 20
                implicitHeight: 25

                hoverEnabled: true
                onClicked: {
                    modelData.activate();
                }

                Rectangle {
                    id: workspace
                    width: 20
                    height: 20
                    anchors.centerIn: parent

                    radius: 4
                    color: mouseArea.containsMouse ? "#6c7086" : (mouseArea.modelData.active ? "#585b70" : "#b311111b")
                    Behavior on color {
                        ColorAnimation {
                            duration: 75
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                StyledText {
                    text: mouseArea.modelData.name
                    anchors.centerIn: parent
                }
            }
        }
    }
}
