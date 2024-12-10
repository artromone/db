import QtQuick 2.1
import QtQuick.Controls 2.1
import DateTimeValidator 1.0

import QtQuick.Controls 1.4 as Controls1

Item {
    signal navigateBack

    function formatDate(isoDateString) {
        if (!isoDateString) return '';
        
        try {
            var date = new Date(isoDateString);
            
            function pad(number) {
                return (number < 10 ? '0' : '') + number;
            }
            
            var day = pad(date.getDate());
            var month = pad(date.getMonth() + 1);
            var year = date.getFullYear();
            
            return day + '.' + month + '.' + year;
        } catch (error) {
            console.error("Date conversion error:", error);
            return '';
        }
    }

    function updateTable() {
        salesTableView.visible = false;
        var sales = dbManager.fetchSales();
        salesModel.clear();
        for (var i = 0; i < sales.length; i++) {
            salesModel.append(sales[i]);
        }
        salesTableView.visible = true;
    }

    Controls1.TableView {
        id: salesTableView

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
            id: salesModel
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
            width: 30
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
        Controls1.TableViewColumn {
            role: "create_date"
            title: "Create Date"
            width: 80
        }
    }

    Menu {
        id: contextMenu

        MenuItem {
            text: "Fill Fields"

            onTriggered: {
                var selectedIndex = salesTableView.activatedIdx;
                if (selectedIndex !== -1) {
                    var selectedSale = salesModel.get(selectedIndex);
                    saleId.text = selectedSale.id !== undefined && selectedSale.id !== null ? selectedSale.id : '';
                    saleGoodId.text = selectedSale.good_id !== undefined && selectedSale.good_id !== null ? selectedSale.good_id.toString() : '';
                    saleGoodCount.text = selectedSale.good_count !== undefined && selectedSale.good_count !== null ? selectedSale.good_count.toString() : '';
                    saleCreateDate.text = formatDate(selectedSale.create_date) || '';
                }
            }
        }
    }

    Column {
        id: column

        anchors.bottom: root.bottom
        anchors.left: salesTableView.right
        anchors.leftMargin: 20
        anchors.right: root.right
        anchors.top: backBtn.bottom
        anchors.topMargin: 20
        spacing: 10
        visible: authManager.hasRoot

        TextField {
            id: saleId
            placeholderText: "ID"
        }

        TextField {
            id: saleGoodId
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Good ID"
        }

        TextField {
            id: saleGoodCount
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Good Count"
        }

        TextField {
            id: saleCreateDate
            inputMask: "99.99.9999"
            text: Qt.formatDateTime(new Date(), "dd.MM.yyyy")

            validator: DateTimeValidator {
            }
        }

        Button {
            text: "Add Sale"

            onClicked: {
                var goodId = parseInt(saleGoodId.text);
                var goodCount = parseInt(saleGoodCount.text);
                var createDate = saleCreateDate.text;
                
                if (dbManager.addSale(goodId, goodCount, createDate)) {
                    logger.log("Sale added");
                } else {
                    logger.log("Failed to add sale");
                }
                updateTable();
            }
        }

        Button {
            text: "Update Sale"

            onClicked: {
                var newFields = {
                    "good_id": parseInt(saleGoodId.text),
                    "good_count": parseInt(saleGoodCount.text),
                    "create_date": saleCreateDate.text
                };
                
                if (dbManager.updateSale(parseInt(saleId.text), newFields)) {
                    logger.log("Sale updated: " + parseInt(saleId.text));
                } else {
                    logger.log("Failed to update sale");
                }
                updateTable();
            }
        }

        Button {
            text: "Delete Sale"

            onClicked: {
                if (dbManager.deleteSale(parseInt(saleId.text))) {
                    logger.log("Sale deleted: " + parseInt(saleId.text));
                } else {
                    logger.log("Failed to delete sale");
                }
                updateTable();
            }
        }
    }

    Button {
        id: backBtn

        anchors.left: salesTableView.right
        anchors.leftMargin: 20
        anchors.top: root.top
        anchors.topMargin: 20
        spacing: 10
        text: "Back"

        onClicked: navigateBack()
    }
}
