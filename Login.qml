import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

Item {
    signal loginFailed
    signal loginSuccess

    Column {
        anchors.centerIn: parent
        spacing: 10

        TextField {
            id: username

            property int animationDuration: 200         // Transition duration

            property color borderFocusColor: "#2980b9"  // Darker blue when focused
            property color borderNormalColor: "#3498db" // Blue border

            // Customizable properties
            property color normalColor: "#ffffff"       // White background
            property color textColor: "#333333"         // Dark text

            // Text properties
            color: textColor
            font.pixelSize: 16
            font.weight: Font.Normal
            height: 50
            placeholderText: "Username"

            // Selection highlighting
            selectByMouse: true
            selectedTextColor: "white"
            selectionColor: borderFocusColor

            // Text field styling
            width: 250

            // Placeholder text

            // Custom background
            background: Rectangle {
                border.color: saleId.activeFocus ? borderFocusColor : borderNormalColor

                // Border with animated color change
                border.width: 2
                color: normalColor

                // Subtle shadow effect
                layer.enabled: true

                // Rounded corners
                radius: 8

                // Smooth border color transition
                Behavior on border.color {
                    ColorAnimation {
                        duration: animationDuration
                    }
                }
                layer.effect: DropShadow {
                    color: "#40000000"
                    horizontalOffset: 0
                    radius: 6.0
                    samples: 13
                    verticalOffset: 2
                }
            }

            // Focus and hover effects
            MouseArea {
                acceptedButtons: Qt.NoButton
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
            }
        }
        TextField {
            id: password

            property int animationDuration: 200         // Transition duration

            property color borderFocusColor: "#2980b9"  // Darker blue when focused
            property color borderNormalColor: "#3498db" // Blue border

            // Customizable properties
            property color normalColor: "#ffffff"       // White background
            property color textColor: "#333333"         // Dark text

            // Text properties
            color: textColor
            echoMode: TextInput.Password
            font.pixelSize: 16
            font.weight: Font.Normal
            height: 50
            placeholderText: "Password"

            // Selection highlighting
            selectByMouse: true
            selectedTextColor: "white"
            selectionColor: borderFocusColor

            // Text field styling
            width: 250

            // Placeholder text

            // Custom background
            background: Rectangle {
                border.color: password.activeFocus ? borderFocusColor : borderNormalColor

                // Border with animated color change
                border.width: 2
                color: normalColor

                // Subtle shadow effect
                layer.enabled: true

                // Rounded corners
                radius: 8

                // Smooth border color transition
                Behavior on border.color {
                    ColorAnimation {
                        duration: animationDuration
                    }
                }
                layer.effect: DropShadow {
                    color: "#40000000"
                    horizontalOffset: 0
                    radius: 6.0
                    samples: 13
                    verticalOffset: 2
                }
            }

            // Focus and hover effects
            MouseArea {
                acceptedButtons: Qt.NoButton
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
            }
        }
        Button {
            id: styledButton

            property int animationDuration: 150         // Smooth transition duration

            property color hoverColor: "#2980b9"        // Darker blue on hover
            // Customizable properties
            property color normalColor: "#3498db"       // Vibrant blue
            property color pressedColor: "#21618C"      // Even darker blue when pressed
            property color textColor: "white"

            height: 50

            // Subtle scale animation on press
            scale: pressed ? 0.95 : 1.0

            // Button text and styling
            text: "Login"
            width: 250

            // Custom button background
            background: Rectangle {
                color: styledButton.down ? pressedColor : (styledButton.hovered ? hoverColor : normalColor)

                // Subtle shadow effect
                layer.enabled: true
                radius: 8  // Rounded corners

                // Smooth color transition
                Behavior on color {
                    ColorAnimation {
                        duration: animationDuration
                    }
                }
                layer.effect: DropShadow {
                    color: "#80000000"
                    horizontalOffset: 0
                    radius: 8.0
                    samples: 17
                    verticalOffset: 3
                }
            }

            // Text styling
            contentItem: Text {
                color: textColor
                font.pixelSize: 16
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                text: styledButton.text
                verticalAlignment: Text.AlignVCenter
            }
            Behavior on scale {
                NumberAnimation {
                    duration: animationDuration
                }
            }

            onClicked: {
                if (authManager.login(username.text, password.text)) {
                    loginSuccess();
                } else {
                    loginFailed();
                }
            }
        }
    }
}
