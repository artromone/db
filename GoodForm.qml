import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4 as Controls1

import QtGraphicalEffects 1.0

Item {
    signal navigateBack

    function updateTable() {
        goodsTableView.visible = false;
        var goods = dbManager.fetchGoods();
        goodsModel.clear();
        for (var i = 0; i < goods.length; i++) {
            goodsModel.append(goods[i]);
        }
        goodsTableView.visible = true;
    }

    Controls1.TableView {
        id: goodsTableView

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
            id: goodsModel

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
            role: "name"
            title: "Name"
            width: 200
        }
        Controls1.TableViewColumn {
            role: "priority"
            title: "Priority"
            width: 100
        }
    }
    Menu {
        id: contextMenu

        MenuItem {
            text: "Fill Fields"

            onTriggered: {
                var selectedIndex = goodsTableView.activatedIdx;
                if (selectedIndex !== -1) {
                    var selectedGood = goodsModel.get(selectedIndex);
                    goodId.text = selectedGood.id !== undefined && selectedGood.id !== null ? selectedGood.id : '';
                    goodName.text = selectedGood.name || '';
                    goodPriority.text = selectedGood.priority !== undefined && selectedGood.priority !== null ? selectedGood.priority : '';
                }
            }
        }
    }
    Column {
        id: column

        anchors.bottom: root.bottom
        anchors.left: goodsTableView.right
        anchors.leftMargin: 20
        anchors.right: root.right
        anchors.top: backBtn.bottom
        anchors.topMargin: 20
        spacing: 10
        visible: authManager.hasRoot

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
            id: goodName

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
            placeholderText: "Good Name"

            // Selection highlighting
            selectByMouse: true
            selectedTextColor: "white"
            selectionColor: borderFocusColor
            width: parent.width

            // Text field styling

            // Placeholder text

            // Custom background
            background: Rectangle {
                border.color: goodName.activeFocus ? borderFocusColor : borderNormalColor

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
            id: goodPriority

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
            placeholderText: "Priority (optional)"

            // Selection highlighting
            selectByMouse: true
            selectedTextColor: "white"
            selectionColor: borderFocusColor
            width: parent.width

            // Text field styling

            // Placeholder text

            // Custom background
            background: Rectangle {
                border.color: goodPriority.activeFocus ? borderFocusColor : borderNormalColor

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
            text: "Add Good"

            // Button text and styling
            width: 250

            // Custom button background
            background: Rectangle {
                id: buttonBackground

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
                var name = goodName.text.trim();
                var priority = goodPriority.text ? parseInt(goodPriority.text) : -1;
                if (name === "") {
                    return;
                }
                if (dbManager.addGood(name, priority)) {
                    logger.log("Good added: " + name);
                    updateTable();
                    // Clear fields after successful addition
                    goodName.text = "";
                    goodPriority.text = "";
                }
            }
        }
        Button {
            id: edit

            property int animationDuration: 150         // Smooth transition duration

            property color hoverColor: "#2980b9"        // Darker blue on hover
            // Customizable properties
            property color normalColor: "#3498db"       // Vibrant blue
            property color pressedColor: "#21618C"      // Even darker blue when pressed
            property color textColor: "white"

            height: 50

            // Subtle scale animation on press
            scale: pressed ? 0.95 : 1.0
            text: "Update Good"

            // Button text and styling
            width: 250

            // Custom button background
            background: Rectangle {
                color: edit.down ? pressedColor : (edit.hovered ? hoverColor : normalColor)

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
                text: edit.text
                verticalAlignment: Text.AlignVCenter
            }
            Behavior on scale {
                NumberAnimation {
                    duration: animationDuration
                }
            }

            onClicked: {
                var id = parseInt(goodId.text);
                if (isNaN(id)) {
                    return;
                }
                var newFields = {
                    "name": goodName.text,
                    "priority": goodPriority.text ? parseInt(goodPriority.text) : null
                };
                if (dbManager.updateGood(id, newFields)) {
                    logger.log("Good updated: " + id);
                    updateTable();
                }
            }
        }
        Button {
            id: delet

            property int animationDuration: 150         // Smooth transition duration

            property color hoverColor: "#2980b9"        // Darker blue on hover
            // Customizable properties
            property color normalColor: "#3498db"       // Vibrant blue
            property color pressedColor: "#21618C"      // Even darker blue when pressed
            property color textColor: "white"

            height: 50

            // Subtle scale animation on press
            scale: pressed ? 0.95 : 1.0
            text: "Delete Good"

            // Button text and styling
            width: 250

            // Custom button background
            background: Rectangle {
                color: delet.down ? pressedColor : (delet.hovered ? hoverColor : normalColor)

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
                text: delet.text
                verticalAlignment: Text.AlignVCenter
            }
            Behavior on scale {
                NumberAnimation {
                    duration: animationDuration
                }
            }

            onClicked: {
                var id = parseInt(goodId.text);
                if (isNaN(id)) {
                    return;
                }
                if (dbManager.deleteGood(id)) {
                    logger.log("Good deleted: " + id);
                    updateTable();
                    // Clear fields after deletion
                    goodId.text = "";
                    goodName.text = "";
                    goodPriority.text = "";
                }
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

        anchors.left: goodsTableView.right
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
