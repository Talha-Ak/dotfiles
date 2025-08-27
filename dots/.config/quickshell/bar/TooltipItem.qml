import QtQuick

Item {
    required property var tooltip
    required property Item owner
    property bool show: false
    default property alias data: content.data

    property real targetRelativeX: owner.width / 2

    implicitHeight: content.implicitHeight + content.anchors.topMargin + content.anchors.bottomMargin
    implicitWidth: content.implicitWidth + content.anchors.leftMargin + content.anchors.rightMargin

    Item {
        id: content
        anchors.fill: parent
        anchors.margins: 8

        implicitHeight: children[0].implicitHeight
        implicitWidth: children[0].implicitWidth
    }
}
