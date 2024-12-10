import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Layouts 1.3

Item {
    signal navigateBack

    // Fetch available goods when component is ready
    Component.onCompleted: {
        updateAvailableGoods();
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

    function updateAvailableGoods() {
        var availableGoods = dbManager.fetchAvailableGoods();
        availableGoodsModel.clear();
        for (var i = 0; i < availableGoods.length; i++) {
            availableGoodsModel.append(availableGoods[i]);
        }
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
            height: 25

            Rectangle {
                anchors.fill: parent
                border.color: "gray"
                border.width: 1
                color: "lightgray"
            }
            Text {
                anchors.fill: parent
                anchors.margins: 5
                color: "black"
                elide: Text.ElideRight
                font.pixelSize: 13
                text: styleData.value
            }
        }
        
        itemDelegate: Item {
            Rectangle {
                anchors.fill: parent
                color: styleData.selected ? "black" : "white"
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: styleData.selected ? "white" : "black"
                font.pixelSize: 13
                text: styleData.value
                wrapMode: Text.Wrap
            }
        }
        
        model: ListModel {
            id: warehouseModel
        }
        
        rowDelegate: Rectangle {
            color: styleData.selected ? "black" : "white"
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
                    warehouseItemId.text = selectedItem.id !== undefined && selectedItem.id !== null 
                        ? selectedItem.id 
                        : '';
                    goodSelector.currentIndex = goodSelector.indexOfValue(selectedItem.good_id);
                    warehouseItemCount.text = selectedItem.good_count !== undefined && selectedItem.good_count !== null 
                        ? selectedItem.good_count 
                        : '';
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
            placeholderText: "ID"
            width: parent.width
        }

        ComboBox {
            id: goodSelector
            width: parent.width
            textRole: "name"
            model: ListModel {
                id: availableGoodsModel
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
            placeholderText: "Good Count"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            width: parent.width
        }

        Button {
            text: "Add Warehouse Item"

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
                } else {
                }
            }
        }

        Button {
            text: "Update Warehouse Item"

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
                } else {
                }
            }
        }

        Button {
            text: "Delete Warehouse Item"

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
                } else {
                }
            }
        }
    }

    Button {
        id: backBtn

        anchors.left: warehouseTableView.right
        anchors.leftMargin: 20
        anchors.top: root.top
        anchors.topMargin: 20
        spacing: 10
        text: "Back"

        onClicked: navigateBack()
    }
}
