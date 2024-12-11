import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Layouts 1.3

import QtGraphicalEffects 1.0

Item {
    signal navigateBack

    function updateAvailableGoods() {
        var availableGoods = dbManager.fetchAvailableGoods();
        availableGoodsModel.clear();
        for (var i = 0; i < availableGoods.length; i++) {
            availableGoodsModel.append(availableGoods[i]);
        }
    }
    function updateTable() {
        warehouseTableView.visible = false;
        var warehouseItems = dbManager.fetchWarehouseItems();
        warehouseModel.clear();
        for (var i = 0; i < warehouseItems.length; i++) {
            warehouseItems[i]['selectedGood'] = warehouseItems[i]['good_name'];
            warehouseModel.append(warehouseItems[i]);
        }
        warehouseTableView.visible = true;
    }

    // Fetch available goods when component is ready
    Component.onCompleted: {
        updateAvailableGoods();
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
            role: "selectedGood"
            title: "Good Name"
            width: 150
        }
        Controls1.TableViewColumn {
            role: "good_count"
            title: "Count"
            width: 100
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
                    goodSelector.currentIndex = goodSelector.indexOfValue(selectedItem.good_id);
                    warehouseItemCount.text = selectedItem.good_count !== undefined && selectedItem.good_count !== null ? selectedItem.good_count : '';
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
            placeholderText: "ID"

            // Selection highlighting
            selectByMouse: true
            selectedTextColor: "white"
            selectionColor: borderFocusColor
            width: parent.width

            // Text field styling

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
        ComboBox {
            id: goodSelector

            property int animationDuration: 200         // Transition duration

            property color borderFocusColor: "#2980b9"  // Darker blue when focused
            property color borderNormalColor: "#3498db" // Blue border
            property color dropdownColor: "#f7f7f7"     // Light gray dropdown background
            property color highlightColor: "#3498db"    // Highlight color for selected item
            // Customizable properties
            property color normalColor: "#ffffff"       // White background
            property color textColor: "#333333"         // Dark text

            // Placeholder text
            displayText: currentText || "Select an option"

            // Text properties
            font.pixelSize: 16
            font.weight: Font.Normal

            // ComboBox styling
            height: 50
            textRole: "name"
            width: parent.width

            // Custom background
            background: Rectangle {
                id: comboBoxBackground

                border.color: styledComboBox.activeFocus ? borderFocusColor : borderNormalColor

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

            // Delegate (dropdown item) styling
            delegate: ItemDelegate {
                width: parent.width

                background: Rectangle {
                    color: highlighted ? highlightColor : "transparent"
                }
                contentItem: Text {
                    property color textColor: "black"

                    color: textColor
                    font.pixelSize: 16
                    text: model.name
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // Dropdown indicator styling
            indicator: Canvas {
                id: dropdownIndicator

                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                height: 20
                width: 20

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.moveTo(0, 0);
                    ctx.lineTo(width / 2, height);
                    ctx.lineTo(width, 0);
                    ctx.closePath();
                    ctx.fillStyle = styledComboBox.activeFocus ? borderFocusColor : borderNormalColor;
                    ctx.fill();
                }
            }
            model: ListModel {
                id: availableGoodsModel

            }

            // Popup (dropdown) styling
            popup.background: Rectangle {
                color: dropdownColor
                layer.enabled: true
                radius: 8

                layer.effect: DropShadow {
                    color: "#40000000"
                    horizontalOffset: 0
                    radius: 6.0
                    samples: 13
                    verticalOffset: 2
                }
            }

            // Allow adding current warehouse item's good to the selector
            Component.onCompleted: {
                // Ensure current warehouse item's good is always in the list
                var currentText = currentText;
                updateAvailableGoods();
            }
        }
        TextField {
            id: warehouseItemCount

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
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Good Count"

            // Selection highlighting
            selectByMouse: true
            selectedTextColor: "white"
            selectionColor: borderFocusColor
            width: parent.width

            // Text field styling

            // Placeholder text

            // Custom background
            background: Rectangle {
                border.color: warehouseItemCount.activeFocus ? borderFocusColor : borderNormalColor

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
                property color borderFocusColor: "#2980b9"  // Darker blue when focused

                property color borderNormalColor: "#3498db" // Blue border

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
                var goodId = goodSelector.currentValue;
                var goodCount = parseInt(warehouseItemCount.text);
                if (!goodId) {
                    return;
                }
                if (isNaN(goodCount) || goodCount < 0) {
                    return;
                }
                if (dbManager.addWarehouseItem(goodId, goodCount)) {
                    logger.log("Warehouse item added");
                    updateTable();
                    updateAvailableGoods();
                    // Clear fields after successful addition
                    goodSelector.currentIndex = -1;
                    warehouseItemCount.text = "";
                } else {}
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
                var id = parseInt(warehouseItemId.text);
                var goodCount = parseInt(warehouseItemCount.text);
                if (isNaN(id)) {
                    return;
                }
                if (isNaN(goodCount) || goodCount < 0) {
                    return;
                }
                var newFields = {
                    "good_count": goodCount
                };
                if (dbManager.updateWarehouseItem(id, newFields)) {
                    logger.log("Warehouse item updated: " + id);
                    updateTable();
                } else {}
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
                var id = parseInt(warehouseItemId.text);
                if (isNaN(id)) {
                    return;
                }
                if (dbManager.deleteWarehouseItem(id)) {
                    logger.log("Warehouse item deleted: " + id);
                    updateTable();
                    updateAvailableGoods();
                    // Clear fields after deletion
                    warehouseItemId.text = "";
                    goodSelector.currentIndex = -1;
                    warehouseItemCount.text = "";
                } else {}
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
