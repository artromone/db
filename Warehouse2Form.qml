import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4 as Controls1

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
            placeholderText: "ID"
        }

        TextField {
            id: goodId
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Good ID"
        }

        TextField {
            id: goodCount
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Good Count"
        }

        Button {
            text: "Add Warehouse Item"
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
            text: "Update Warehouse Item"
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
            text: "Delete Warehouse Item"
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
        anchors.left: warehouseTableView.right
        anchors.leftMargin: 20
        anchors.top: root.top
        anchors.topMargin: 20
        spacing: 10
        text: "Back"

        onClicked: navigateBack()
    }
}
