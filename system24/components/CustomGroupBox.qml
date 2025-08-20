import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: groupBoxRoot
    property real scaleFactor: 1

    color: "#2d3641"
    border.width: 2 * scaleFactor
    radius: 4 * scaleFactor

    property string title: ""
    property bool hovered: false
    property bool hoveredIntern: false
    property color hoverColor: "#ff69b4"
    property color normalColor: "#cccccc"

    implicitWidth: 360 * scaleFactor
    implicitHeight: 100 * scaleFactor
    border.color: (hovered || hoveredIntern) ? hoverColor : normalColor

    Rectangle {
        id: labelBackground
        anchors.horizontalCenter: parent.horizontalCenter
        y: -10 * scaleFactor
        color: groupBoxRoot.color
        width: labelText.implicitWidth + (8 * scaleFactor)
        height: labelText.implicitHeight
        z: 1
        anchors.horizontalCenterOffset: -115 * scaleFactor

        Text {
            id: labelText
            text: groupBoxRoot.title
            font.family: "DM Mono"
            font.pixelSize: 15 * scaleFactor
            font.bold: true
            color: (groupBoxRoot.hovered || groupBoxRoot.hoveredIntern) ? hoverColor : normalColor
            anchors.centerIn: parent
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onEntered: groupBoxRoot.hoveredIntern = true
        onExited: groupBoxRoot.hoveredIntern = false
    }
}
