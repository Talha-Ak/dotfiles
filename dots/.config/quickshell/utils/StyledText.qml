import QtQuick

Text {
    id: text
    color: "#cdd6f4"

    font {
        family: "CaskaydiaCove NF"
        pointSize: 10
    }

    readonly property alias textWidth: metrics.boundingRect.width
    readonly property alias textHeight: metrics.boundingRect.height

    TextMetrics {
        id: metrics
        font: text.font
        text: text.text
    }
}
