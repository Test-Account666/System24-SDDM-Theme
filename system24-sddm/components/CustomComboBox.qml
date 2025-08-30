import QtQuick 2.15
import QtQuick.Controls 2.15

ComboBox {
    id: control
    property real scaleFactor: 1

    font.family: "DM Mono"
    font.pixelSize: 14 * scaleFactor

    property color hoverColor: "#ff69b4"
    property color normalBorderColor: "#484f5d"
    property color normalTextColor: "white"
    property color highlightColor: "#ff69b4"

    textRole: "name"

    background: Rectangle {
        color: "#353e4c"
        border.width: 2 * scaleFactor
        border.color: control.hovered ? hoverColor : normalBorderColor
        radius: 2 * scaleFactor
    }

    contentItem: Text {
        text: control.displayText
        color: normalTextColor
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        leftPadding: 12 * scaleFactor
        rightPadding: 12 * scaleFactor
        font: control.font
    }

    delegate: Component {
        ItemDelegate {
            id: del
            width: ListView.view ? ListView.view.width : control.width
            height: 40 * scaleFactor
            hoverEnabled: true
            highlighted: ListView.isCurrentItem
            property string name: model.name
            property real targetOffset: hovered ? 8 * scaleFactor : 0
            property real animatedOffset: 0
            property real smoothing: 0.15

            Timer {
                interval: 16
                repeat: true
                running: true
                onTriggered: del.animatedOffset += (del.targetOffset - del.animatedOffset) * del.smoothing
            }

            background: Rectangle {
                anchors.fill: parent
                color: del.hovered ? "#444c5a" : "#353e4c"
                border.width: 2 * scaleFactor
                border.color: del.hovered ? control.hoverColor : control.normalBorderColor
                radius: 2 * scaleFactor
            }

            contentItem: Text {
                text: del.name
                color: del.highlighted ? control.highlightColor : control.normalTextColor
                font: control.font
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                x: (12 * scaleFactor) + del.animatedOffset
                width: parent.width - (24 * scaleFactor)
                height: parent.height
            }

            onClicked: {
                control.currentIndex = index
                control.popup.close()
            }
        }
    }

    popup: Popup {
        parent: control
        x: 0
        y: control.height
        width: control.width
        padding: 0
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        contentItem: ListView {
            clip: true
            model: control.model
            delegate: control.delegate
            currentIndex: control.currentIndex
            implicitHeight: Math.min(contentHeight, 10 * (40 * scaleFactor))
            interactive: contentHeight > height
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { }
        }
    }
}
