import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: control
    property real scaleFactor: 1

    font.family: "DM Mono"
    font.pixelSize: 14 * scaleFactor

    property color hoverColor: "#505866"
    property color normalColor: "#3f4754"
    property color borderColor: "#ff69b4"
    property color textColor: "#e0e3e8"

    background: Rectangle {
        implicitWidth: 100 * scaleFactor
        implicitHeight: control.font.pixelSize * 2.5
        color: control.hovered ? hoverColor : normalColor
        border.color: control.down ? "#a06de8" : borderColor
        border.width: 2 * scaleFactor
        radius: 2 * scaleFactor
    }

    contentItem: Text {
        text: control.text
        color: textColor
        anchors.centerIn: parent
        font: control.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
