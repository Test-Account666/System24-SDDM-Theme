import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "components"

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#2d3641"

    // Scale factor relative to base design (1920x1080)
    property real scaleFactor: Math.min(width / 1920, height / 1080)

    Connections {
        target: sddm

        onLoginSucceeded: {
            popupMessage.text = "Login successful!"
            overlay.visible = true
            overlay.opacity = 0.5
        }

        onLoginFailed: {
            passField.text = ""
            popupMessage.text = "Login failed, please try again."
            overlay.visible = true
            overlay.opacity = 0.5
        }

        onInformationMessage: {
            popupMessage.text = message
            overlay.visible = true
            overlay.opacity = 0.5
        }
    }


    // --- Outer pink outline ---
    Rectangle {
        id: outerOutline
        anchors.centerIn: parent
        width: (mainColumn.implicitWidth + 256 * root.scaleFactor)
        height: (mainColumn.implicitHeight + 256 * root.scaleFactor)
        color: "transparent"
        border.width: 2 * root.scaleFactor
        border.color: "#ff69b4"
        radius: 4 * root.scaleFactor

        // --- Overlay text that breaks the border ---
        Rectangle {
            id: textBackground
            anchors.horizontalCenter: parent.horizontalCenter
            y: -10 * root.scaleFactor
            color: root.color
            width: loginLabel.implicitWidth + (8 * root.scaleFactor)
            height: loginLabel.implicitHeight
            z: 1
            anchors.horizontalCenterOffset: -230 * root.scaleFactor

            Text {
                id: loginLabel
                text: "login screen"
                font.family: "DM Mono"
                font.pixelSize: 15 * root.scaleFactor
                font.bold: true
                color: "#ff69b4"
                anchors.centerIn: parent
            }
        }

        Image {
            id: systemLogo
            source: "system24-logo.png"
            fillMode: Image.PreserveAspectFit
            width: 256 * root.scaleFactor
            height: 64 * root.scaleFactor
            anchors.horizontalCenter: parent.horizontalCenter
            y: 35 * root.scaleFactor
        }

        Column {
            id: mainColumn
            anchors.centerIn: parent
            spacing: 24 * root.scaleFactor

            // --- Login Group ---
            CustomGroupBox {
                id: loginGroup
                scaleFactor: root.scaleFactor
                title: "credentials"
                implicitWidth: 360 * root.scaleFactor
                implicitHeight: column.childrenRect.height + (32 * root.scaleFactor)

                Column {
                    id: column
                    anchors.fill: parent
                    anchors.margins: 16 * root.scaleFactor
                    spacing: 12 * root.scaleFactor

                    CustomComboBox {
                        id: userComboBox
                        scaleFactor: root.scaleFactor
                        model: userModel
                        width: parent.width
                        height: 40 * root.scaleFactor
                        anchors.margins: 16 * root.scaleFactor
                        currentIndex: userModel.lastIndex

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: !overlay.visible
                            propagateComposedEvents: true
                            acceptedButtons: Qt.NoButton
                            onEntered: loginGroup.hovered = true
                            onExited: loginGroup.hovered = false
                        }
                    }

                    TextField {
                        id: passField
                        placeholderText: "Password"
                        echoMode: TextInput.Password
                        font.family: "DM Mono"
                        font.pixelSize: 16 * root.scaleFactor
                        width: parent.width
                        height: 40 * root.scaleFactor
                        placeholderTextColor: "#999999"
                        color: "#ffffff"
                        background: Rectangle {
                            color: "#353e4c"
                            border.width: 2 * root.scaleFactor
                            border.color: (passField.focus || passField.hovered) ? "#ff69b4" : "#484f5d"
                            radius: 2 * root.scaleFactor
                        }

                        Component.onCompleted: passField.forceActiveFocus()

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: !overlay.visible
                            propagateComposedEvents: true
                            acceptedButtons: Qt.NoButton
                            onEntered: loginGroup.hovered = true
                            onExited: loginGroup.hovered = false
                        }

                        Keys.onReturnPressed: {
                            if (!overlay.visible) sddm.login(userComboBox.currentText, passField.text, session.currentIndex)
                        }
                    }

                    CustomButton {
                        id: loginButton
                        text: "Login"
                        anchors.horizontalCenter: parent.horizontalCenter
                        scaleFactor: root.scaleFactor
                        onClicked: {
                            if (!overlay.visible) sddm.login(userComboBox.currentText, passField.text, session.currentIndex)
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: !overlay.visible
                            enabled: !overlay.visible
                            propagateComposedEvents: true
                            acceptedButtons: Qt.NoButton
                            onEntered: loginGroup.hovered = true
                            onExited: loginGroup.hovered = false
                        }
                    }
                }
            }

            // --- Session Group ---
            CustomGroupBox {
                id: sessionGroup
                scaleFactor: root.scaleFactor
                title: "session"
                implicitWidth: 360 * root.scaleFactor
                implicitHeight: session.height + (32 * root.scaleFactor)

                CustomComboBox {
                    id: session
                    scaleFactor: root.scaleFactor
                    model: sessionModel
                    anchors.fill: parent
                    height: 40 * root.scaleFactor
                    anchors.margins: 16 * root.scaleFactor
                    currentIndex: sessionModel.lastIndex

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !overlay.visible
                        propagateComposedEvents: true
                        acceptedButtons: Qt.NoButton
                        onEntered: sessionGroup.hovered = true
                        onExited: sessionGroup.hovered = false
                    }
                }
            }

            // --- Power Group ---
            CustomGroupBox {
                id: powerGroup
                scaleFactor: root.scaleFactor
                title: "power"
                implicitWidth: 360 * root.scaleFactor
                implicitHeight: 56 * root.scaleFactor

                Row {
                    id: powerRow
                    spacing: 12 * root.scaleFactor
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    CustomButton {
                        text: "Reboot"
                        scaleFactor: root.scaleFactor
                        onClicked: {
                            if (!overlay.visible) sddm.reboot()
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: !overlay.visible
                            enabled: !overlay.visible
                            propagateComposedEvents: true
                            acceptedButtons: Qt.NoButton
                            onEntered: powerGroup.hovered = true
                            onExited: powerGroup.hovered = false
                        }
                    }

                    CustomButton {
                        text: "Shutdown"
                        scaleFactor: root.scaleFactor
                        onClicked: {
                            if (!overlay.visible) sddm.powerOff()
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: !overlay.visible
                            enabled: !overlay.visible
                            propagateComposedEvents: true
                            acceptedButtons: Qt.NoButton
                            onEntered: powerGroup.hovered = true
                            onExited: powerGroup.hovered = false
                        }
                    }
                }
            }
        }

        // --- Time & Date Display ---
        Column {
            id: timeDateColumn
            anchors.bottom: outerOutline.bottom
            anchors.horizontalCenter: outerOutline.horizontalCenter
            anchors.bottomMargin: 48 * root.scaleFactor

            Text {
                id: currentTime
                font.family: "DM Mono"
                font.pixelSize: 18 * root.scaleFactor
                color: "#ff69b4"
                text: Qt.formatTime(new Date(), "HH:mm:ss")
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }

            Text {
                id: currentDate
                font.family: "DM Mono"
                font.pixelSize: 14 * root.scaleFactor
                color: "#ffffff"
                text: Qt.formatDate(new Date(), "dddd, dd. MMMM yyyy")
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    currentTime.text = Qt.formatTime(new Date(), "HH:mm:ss")
                    currentDate.text = Qt.formatDate(new Date(), "dddd, dd. MMMM yyyy")
                }
            }
        }

        // --- Overlay Popup ---
        Item {
            anchors.centerIn: parent
            z: 997

            Rectangle {
                id: overlay
                width: Screen.width
                height: Screen.height
                color: "black"
                opacity: 0.0
                visible: false
                anchors.centerIn: parent
                z: 998  // ensure it sits on top
                Behavior on opacity { NumberAnimation { duration: 200 } }

                // When visible becomes false, also reset opacity
                onVisibleChanged: {
                    if (!visible) {
                        opacity = 0.0
                        popup.opacity = 0.0
                    }

                    if (visible) popup.opacity = 1.0
                }

                // Block all input behind popup
                MouseArea {
                    anchors.fill: overlay
                    enabled: overlay.visible
                    hoverEnabled: overlay.visible
                    preventStealing: true
                }
            }

            // Popup container
            Rectangle {
                id: popup
                width: 400 * root.scaleFactor
                height: 200 * root.scaleFactor
                color: "#353e4c"
                radius: 6 * root.scaleFactor
                anchors.centerIn: overlay
                border.width: 2 * root.scaleFactor
                border.color: "#ff69b4"
                focus: overlay.visible // ensure it can capture key events
                opacity: 0.0
                z: 999

                Keys.onReturnPressed: {
                    overlay.visible = false
                    passField.forceActiveFocus()
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 12 * root.scaleFactor

                    Text {
                        id: popupMessage
                        text: ""
                        font.pixelSize: 16 * root.scaleFactor
                        font.family: "DM Mono"
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        width: parent.width * 0.9
                    }

                    CustomButton {
                        scaleFactor: root.scaleFactor
                        text: "OK"
                        onClicked: {
                            overlay.visible = false
                            passField.forceActiveFocus()
                        }
                    }
                }
            }
        }
    }
}
