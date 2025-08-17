import Quickshell.Wayland
import QtQuick

Item {
    id: root

    property string textContent: ToplevelManager.activeToplevel?.title || ""
    property Item current: text1
    property int animationDuration: 150

    width: implicitWidth
    height: parent.height
    implicitWidth: current === text1 ? text1.implicitWidth : text2.implicitWidth

    Behavior on width {
        TitleAnim {}
    }

    // TODO: Use TextMetrics to elide text

    StyledText {
        id: text1

        anchors.verticalCenter: parent.verticalCenter
        opacity: root.current === this ? 1 : 0
        Behavior on opacity {
            TitleAnim {}
        }
    }

    StyledText {
        id: text2

        anchors.verticalCenter: parent.verticalCenter
        opacity: root.current === this ? 1 : 0
        Behavior on opacity {
            TitleAnim {}
        }
    }

    onTextContentChanged: {
        const next = root.current === text1 ? text2 : text1;
        next.text = textContent;
        root.current = next;
    }

    component TitleAnim: NumberAnimation {
        duration: root.animationDuration
        easing.type: Easing.OutQuart
    }
}
