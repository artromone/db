import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4 as Controls1

import QtGraphicalEffects 1.0

Item {
    signal navigateBack

    function updateTable() {
        warehouseTableView.visible = false;
        var warehouseItems = dbManager.fetchWarehouse2Items();
        warehouseModel.clear();
        for (var i = 0; i < warehouseItems.length; i++) {
            warehouseModel.append(warehouseItems[i]);
        }
        warehouseTableView.visible = true;
    }

    Controls1.TableView {
        id: warehouseTableView

        property int activatedIdx: -1

        alternatingRowColors: false
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.top: root.top
        height: 500
        width: 500

        headerDelegate: Item {
            height: 35  // Slightly taller header

            Rectangle {
                anchors.fill: parent
                border.color: "#d3d3d3"
                border.width: 1
                color: "#f0f0f0"  // Soft light gray background

                // Subtle gradient for depth
                gradient: Gradient {
                    GradientStop {
                        color: "#f5f5f5"
                        position: 0.0
                    }
                    GradientStop {
                        color: "#e9e9e9"
                        position: 1.0
                    }
                }
            }
            Text {
                anchors.fill: parent
                anchors.margins: 8
                color: "#333333"  // Dark gray text
                elide: Text.ElideRight
                font.bold: true
                font.pixelSize: 13
                horizontalAlignment: Text.AlignLeft
                text: styleData.value
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Item Delegate with improved selection and hover effects
        itemDelegate: Item {
            Rectangle {
                anchors.fill: parent
                color: {
                    if (styleData.selected)
                        return "#3498db";  // Bright blue for selection
                    return "white";
                }

                // Smooth color transition
                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                color: styleData.selected ? "white" : "black"
                elide: Text.ElideRight
                font.pixelSize: 13
                text: styleData.value
                wrapMode: Text.Wrap
            }
        }
        model: ListModel {
            id: warehouseModel

        }

        // Row selection highlighting
        rowDelegate: Item {
            height: 35  // Consistent row height

            Rectangle {
                anchors.fill: parent
                color: styleData.selected ? "#3498db" : "transparent"
                opacity: 0.1
            }
        }

        Component.onCompleted: {
            updateTable();
        }
        onActivated: {
            contextMenu.popup();
            activatedIdx = row;
        }

        Controls1.TableViewColumn {
            role: "id"
            title: "ID"
            width: 50
        }
        Controls1.TableViewColumn {
            role: "good_id"
            title: "Good ID"
            width: 80
        }
        Controls1.TableViewColumn {
            role: "good_count"
            title: "Good Count"
            width: 80
        }
    }
    Menu {
        id: contextMenu

        MenuItem {
            text: "Fill Fields"

            onTriggered: {
                var selectedIndex = warehouseTableView.activatedIdx;
                if (selectedIndex !== -1) {
                    var selectedItem = warehouseModel.get(selectedIndex);
                    warehouseItemId.text = selectedItem.id !== undefined && selectedItem.id !== null ? selectedItem.id : '';
                    goodId.text = selectedItem.good_id !== undefined && selectedItem.good_id !== null ? selectedItem.good_id : '';
                    goodCount.text = selectedItem.good_count !== undefined && selectedItem.good_count !== null ? selectedItem.good_count : '';
                }
            }
        }
    }
    Column {
        id: column

        anchors.bottom: root.bottom
        anchors.left: warehouseTableView.right
        anchors.leftMargin: 20
        anchors.right: root.right
        anchors.top: backBtn.bottom
        anchors.topMargin: 20
        spacing: 10
        visible: authManager.hasRoot

        TextField {
            id: warehouseItemId

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
            inputMask: "99.99.9999"
            placeholderText: "ID"

            // Selection highlighting
            selectByMouse: true
            selectedTextColor: "white"
            selectionColor: borderFocusColor
            text: Qt.formatDateTime(new Date(), "dd.MM.yyyy")

            // Text field styling
            width: 250

            // Placeholder text

            // Custom background
            background: Rectangle {
                border.color: warehouseItemId.activeFocus ? borderFocusColor : borderNormalColor

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
            id: goodId

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
            inputMask: "99.99.9999"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Good ID"

            // Selection highlighting
            selectByMouse: true
            selectedTextColor: "white"
            selectionColor: borderFocusColor
            text: Qt.formatDateTime(new Date(), "dd.MM.yyyy")

            // Text field styling
            width: 250

            // Placeholder text

            // Custom background
            background: Rectangle {
                border.color: goodId.activeFocus ? borderFocusColor : borderNormalColor

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
            id: goodCount

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
            inputMask: "99.99.9999"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Good Count"

            // Selection highlighting
            selectByMouse: true
            selectedTextColor: "white"
            selectionColor: borderFocusColor
            text: Qt.formatDateTime(new Date(), "dd.MM.yyyy")

            // Text field styling
            width: 250

            // Placeholder text

            // Custom background
            background: Rectangle {
                border.color: goodCount.activeFocus ? borderFocusColor : borderNormalColor

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
            id: add

            property int animationDuration: 150         // Smooth transition duration

            property color hoverColor: "#2980b9"        // Darker blue on hover
            // Customizable properties
            property color normalColor: "#3498db"       // Vibrant blue
            property color pressedColor: "#21618C"      // Even darker blue when pressed
            property color textColor: "white"

            height: 50

            // Subtle scale animation on press
            scale: pressed ? 0.95 : 1.0
            text: "Add Warehouse Item"

            // Button text and styling
            width: 250

            // Custom button background
            background: Rectangle {
                color: add.down ? pressedColor : (add.hovered ? hoverColor : normalColor)

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
                text: add.text
                verticalAlignment: Text.AlignVCenter
            }
            Behavior on scale {
                NumberAnimation {
                    duration: animationDuration
                }
            }

            onClicked: {
                var goodIdVal = parseInt(goodId.text);
                var goodCountVal = parseInt(goodCount.text);
                if (dbManager.addWarehouse2Item(goodIdVal, goodCountVal)) {
                    logger.log("Warehouse item added");
                } else {
                    logger.log("Failed to add warehouse item");
                }
                updateTable();
            }
        }
        Button {
            id: up

            property int animationDuration: 150         // Smooth transition duration

            property color hoverColor: "#2980b9"        // Darker blue on hover
            // Customizable properties
            property color normalColor: "#3498db"       // Vibrant blue
            property color pressedColor: "#21618C"      // Even darker blue when pressed
            property color textColor: "white"

            height: 50

            // Subtle scale animation on press
            scale: pressed ? 0.95 : 1.0
            text: "Update Warehouse Item"

            // Button text and styling
            width: 250

            // Custom button background
            background: Rectangle {
                color: up.down ? pressedColor : (up.hovered ? hoverColor : normalColor)

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
                text: up.text
                verticalAlignment: Text.AlignVCenter
            }
            Behavior on scale {
                NumberAnimation {
                    duration: animationDuration
                }
            }

            onClicked: {
                var newFields = {
                    "good_id": parseInt(goodId.text),
                    "good_count": parseInt(goodCount.text)
                };
                if (dbManager.updateWarehouse2Item(parseInt(warehouseItemId.text), newFields)) {
                    logger.log("Warehouse item updated: " + parseInt(warehouseItemId.text));
                } else {
                    logger.log("Failed to update warehouse item");
                }
                updateTable();
            }
        }
        Button {
            id: del

            property int animationDuration: 150         // Smooth transition duration

            property color hoverColor: "#2980b9"        // Darker blue on hover
            // Customizable properties
            property color normalColor: "#3498db"       // Vibrant blue
            property color pressedColor: "#21618C"      // Even darker blue when pressed
            property color textColor: "white"

            height: 50

            // Subtle scale animation on press
            scale: pressed ? 0.95 : 1.0
            text: "Delete Warehouse Item"

            // Button text and styling
            width: 250

            // Custom button background
            background: Rectangle {
                color: del.down ? pressedColor : (del.hovered ? hoverColor : normalColor)

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
                text: del.text
                verticalAlignment: Text.AlignVCenter
            }
            Behavior on scale {
                NumberAnimation {
                    duration: animationDuration
                }
            }

            onClicked: {
                if (dbManager.deleteWarehouse2Item(parseInt(warehouseItemId.text))) {
                    logger.log("Warehouse item deleted: " + parseInt(warehouseItemId.text));
                } else {
                    logger.log("Failed to delete warehouse item");
                }
                updateTable();
            }
        }
    }
    Button {
        id: backBtn

        property int animationDuration: 150         // Smooth transition duration

        property color hoverColor: "#2980b9"        // Darker blue on hover
        // Customizable properties
        property color normalColor: "#3498db"       // Vibrant blue
        property color pressedColor: "#21618C"      // Even darker blue when pressed
        property color textColor: "white"

        anchors.left: warehouseTableView.right
        anchors.leftMargin: 20
        anchors.top: root.top
        anchors.topMargin: 20
        height: 50

        // Subtle scale animation on press
        scale: pressed ? 0.95 : 1.0
        spacing: 10
        text: "Back"

        // Button text and styling
        width: 250

        // Custom button background
        background: Rectangle {
            color: backBtn.down ? pressedColor : (backBtn.hovered ? hoverColor : normalColor)

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
            text: backBtn.text
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
