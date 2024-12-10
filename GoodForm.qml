import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4 as Controls1

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
            id: goodsModel
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
                    goodId.text = selectedGood.id !== undefined && selectedGood.id !== null 
                        ? selectedGood.id 
                        : '';
                    goodName.text = selectedGood.name || '';
                    goodPriority.text = selectedGood.priority !== undefined && selectedGood.priority !== null 
                        ? selectedGood.priority 
                        : '';
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
            placeholderText: "ID"
        }

        TextField {
            id: goodName
            placeholderText: "Good Name"
            width: parent.width
        }

        TextField {
            id: goodPriority
            placeholderText: "Priority (optional)"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            width: parent.width
        }

        Button {
            text: "Add Good"

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
            text: "Update Good"

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
            text: "Delete Good"

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

        anchors.left: goodsTableView.right
        anchors.leftMargin: 20
        anchors.top: root.top
        anchors.topMargin: 20
        spacing: 10
        text: "Back"

        onClicked: navigateBack()
    }
}
