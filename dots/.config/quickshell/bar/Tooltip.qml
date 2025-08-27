import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Shapes

Scope {
    id: root
    required property var bar

    property TooltipItem currentItem: null

    onCurrentItemChanged: {
        if (currentItem != null) {
            if (tooltipItem) {
                currentItem.parent = tooltipItem;
            }
        }
    }

    function setItem(item: TooltipItem) {
        currentItem = item;
    }

    function removeItem(item: TooltipItem) {
        if (currentItem == item) {
            // TODO: need to remove this and do some actual fading.
            currentItem.parent = null;
            currentItem = null;
        }
    }

    property real scaleMul: currentItem ? 1 : 0
    Behavior on scaleMul {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutQuint
        }
    }

    PopupWindow {
        id: popup

        anchor {
            window: root.bar
            rect.x: 12
            rect.y: root.bar.tooltipY
        }

        // TODO: make dynamic
        implicitWidth: root.bar.width
        implicitHeight: 200

        color: "transparent"

        visible: true

        HyprlandWindow.opacity: root.scaleMul

        mask: Region {
            item: (root.currentItem ?? false) ? tooltipItem : null
        }

        Item {
            id: tooltipItem

            transform: [
                Translate {
                    y: -tooltipItem.height * (1 - root.scaleMul)
                }
            ]

            readonly property var targetWidth: root.currentItem?.implicitWidth ?? -1
            readonly property var targetHeight: root.currentItem?.implicitHeight ?? -1
            readonly property real targetX: {
                if (root.currentItem == null)
                    return 0;
                const target = root.bar.mapFromItem(root.currentItem.owner, root.currentItem.targetRelativeX, 0).x;
                return root.bar.boundedX(target, currentItem.implicitWidth / 2);
            }

            height: targetHeight

            property var x1: targetX - targetWidth / 2
            property var x2: targetX + targetWidth / 2
            width: x2 - x1

            x: x1 - popup.anchor.rect.x

            Shape {
                id: bg
                anchors.fill: parent
                property int radius: 8

                ShapePath {
                    fillColor: "#b31e1e2e"
                    strokeWidth: 0

                    startX: 0
                    startY: 0

                    PathLine { x: tooltipItem.width; y: 0 }
                    PathLine { x: tooltipItem.width; y: tooltipItem.height - bg.radius }
                    PathArc { x: tooltipItem.width - bg.radius; y: tooltipItem.height; radiusX: bg.radius; radiusY: bg.radius}
                    PathLine { x: bg.radius; y: tooltipItem.height }
                    PathArc { x: 0; y: tooltipItem.height - bg.radius; radiusX: bg.radius; radiusY: bg.radius}
                    PathLine { x: 0; y: 0 }
                }
            }

            // Rectangle {
            //     anchors.fill: parent
            //     color: "#b31e1e2e"
            //     radius: 8
            // }
        }
    }
}
