import Quickshell.Wayland
import QtQuick

Rectangle {
    property bool maximised: ToplevelManager.activeToplevel?.maximized ?? false
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

    component MaximiseAnim: NumberAnimation {
        duration: 150
        easing.type: Easing.OutQuad
    }
}
