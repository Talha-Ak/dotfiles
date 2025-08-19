pragma ComponentBehavior: Bound

import Quickshell.Wayland
import QtQuick

Item {
    id: root

    property int animationDuration: 300
    property string fontFamily: "CaskaydiaCove NF"
    property int fontSize: 10

    property Item current: text1

    clip: true
    implicitHeight: current.implicitHeight
    implicitWidth: current === text1 ? text1.implicitWidth : text2.implicitWidth

    Behavior on implicitWidth {
        NumberAnimation {
            duration: root.animationDuration
            easing.type: Easing.OutQuint
        }
    }

    Title {
        id: text1
    }

    Title {
        id: text2
    }

    TextMetrics {
        id: metrics

        text: ToplevelManager.activeToplevel?.title || "Desktop"
        font.family: root.fontFamily
        font.pointSize: root.fontSize
        elide: Qt.ElideMiddle
        elideWidth: 800

        onElideWidthChanged: root.current.text = elidedText
        onTextChanged: {
            const next = root.current === text1 ? text2 : text1;
            next.text = elidedText;
            root.current = next;
        }
    }

    component Title: StyledText {
        anchors.verticalCenter: parent.verticalCenter

        width: implicitWidth
        height: implicitHeight

        font.family: root.fontFamily
        font.pointSize: root.fontSize
        opacity: root.current === this ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: root.animationDuration
                easing.type: Easing.OutQuart
            }
        }
    }
}
