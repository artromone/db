import QtQuick 2.1
import QtQuick.Controls 2.1

import QtGraphicalEffects 1.0

Item {
    signal navigateBack

    Column {
        anchors.centerIn: root
        spacing: 10

        Button {
            id: txt

            property int animationDuration: 150         // Smooth transition duration

            property color hoverColor: "#2980b9"        // Darker blue on hover
            // Customizable properties
            property color normalColor: "#3498db"       // Vibrant blue
            property color pressedColor: "#21618C"      // Even darker blue when pressed
            property color textColor: "white"

            height: 50

            // Subtle scale animation on press
            scale: pressed ? 0.95 : 1.0
            text: "Generate TXT Report"

            // Button text and styling
            width: 250

            // Custom button background
            background: Rectangle {
                color: txt.down ? pressedColor : (txt.hovered ? hoverColor : normalColor)

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
                text: txt.text
                verticalAlignment: Text.AlignVCenter
            }
            Behavior on scale {
                NumberAnimation {
                    duration: animationDuration
                }
            }

            onClicked: {
                dbManager.generateReportTXT("goods");
                dbManager.generateReportTXT("sales");
                dbManager.generateReportTXT("warehouse1");
                dbManager.generateReportTXT("warehouse2");
                logger.log("TXT Report generated");
            }
        }
        Button {
            id: pdf

            property int animationDuration: 150         // Smooth transition duration

            property color hoverColor: "#2980b9"        // Darker blue on hover
            // Customizable properties
            property color normalColor: "#3498db"       // Vibrant blue
            property color pressedColor: "#21618C"      // Even darker blue when pressed
            property color textColor: "white"

            height: 50

            // Subtle scale animation on press
            scale: pressed ? 0.95 : 1.0
            text: "Generate PDF Report"

            // Button text and styling
            width: 250

            // Custom button background
            background: Rectangle {
                color: pdf.down ? pressedColor : (pdf.hovered ? hoverColor : normalColor)

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
                text: pdf.text
                verticalAlignment: Text.AlignVCenter
            }
            Behavior on scale {
                NumberAnimation {
                    duration: animationDuration
                }
            }

            onClicked: {
                dbManager.generateReportPDF("goods");
                dbManager.generateReportPDF("sales");
                dbManager.generateReportPDF("warehouse1");
                dbManager.generateReportPDF("warehouse2");
                logger.log("PDF Report generated");
            }
        }
        Button {
            id: back

            property int animationDuration: 150         // Smooth transition duration

            property color hoverColor: "#2980b9"        // Darker blue on hover
            // Customizable properties
            property color normalColor: "#3498db"       // Vibrant blue
            property color pressedColor: "#21618C"      // Even darker blue when pressed
            property color textColor: "white"

            height: 50

            // Subtle scale animation on press
            scale: pressed ? 0.95 : 1.0
            text: "Back"

            // Button text and styling
            width: 250

            // Custom button background
            background: Rectangle {
                color: back.down ? pressedColor : (back.hovered ? hoverColor : normalColor)

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
                text: back.text
                verticalAlignment: Text.AlignVCenter
            }
            Behavior on scale {
                NumberAnimation {
                    duration: animationDuration
                }
            }

            onClicked: navigateBack()
        }
    }
}
