// TODO: Better Tray Items

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: layout
    spacing: 4

    Repeater {
        id: items
        model: ScriptModel {
            values: SystemTray.items.values.filter(it => it.status != Status.Passive)
        }

        MouseArea {
            id: tray
            required property SystemTrayItem modelData

            Layout.fillHeight: true
            implicitWidth: icon.implicitWidth + 8

            acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
            onClicked: e => {
                switch (e.button) {
                case Qt.LeftButton:
                    modelData.activate();
                    break;
                case Qt.MiddleButton:
                    modelData.secondaryActivate();
                    break;
                case Qt.RightButton:
                    if (modelData.hasMenu)
                        menu.open();
                    break;
                }
            }

            QsMenuAnchor {
                id: menu

                menu: tray.modelData.menu

                anchor.window: tray.QsWindow.window
                anchor.adjustment: PopupAdjustment.Flip
                anchor.onAnchoring: {
                    const window = tray.QsWindow.window;
                    const widgetRect = window.contentItem.mapFromItem(tray, 0, tray.height, tray.width, tray.height);

                    menu.anchor.rect = widgetRect;
                }
            }

            IconImage {
                id: icon

                implicitSize: 16
                anchors.centerIn: parent

                source: tray.modelData.icon
                asynchronous: true
            }
        }
    }
}
