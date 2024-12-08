import QtQuick 2.1
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Controls 2.1

Item {
    signal navigateBack

    function updateTable() {
        departmentTableView.visible = false;
        var metadata = dbManager.getTableMetadata("departments");
        console.log("Columns:", metadata.columns);
        console.log("Foreign Keys:", metadata.foreign_keys);
        var departments = dbManager.fetchDepartments();
        departmentModel.clear();
        for (var i = 0; i < departments.length; i++) {
            departmentModel.append(departments[i]);
        }
        departmentTableView.visible = true;
    }

    Controls1.TableView {
        id: departmentTableView

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
            id: departmentModel

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
    }
    Menu {
        id: contextMenu

        MenuItem {
            text: "Fill Fields"

            onTriggered: {
                var selectedIndex = departmentTableView.activatedIdx;
                if (selectedIndex !== -1) {
                    var selectedDepartment = departmentModel.get(selectedIndex);
                    departmentId.text = selectedDepartment.id !== undefined && selectedDepartment.id !== null ? selectedDepartment.id.toString() : '';
                }
            }
        }
    }
    Column {
        anchors.bottom: root.bottom
        anchors.left: departmentTableView.right
        anchors.leftMargin: 20
        anchors.right: root.right
        anchors.top: parent.top
        anchors.topMargin: 20
        spacing: 10

        TextField {
            id: departmentId

            placeholderText: "Department ID"
        }
        Button {
            text: "Delete Department"

            onClicked: {
                if (dbManager.deleteDepartment(parseInt(departmentId.text))) {
                    logger.log("Department deleted: " + departmentId.text);
                } else {
                    logger.log("Failed to delete department");
                }
                updateTable();
            }
        }
        Button {
            text: "Add Department"

            onClicked: {
                if (dbManager.addDepartment()) {
                    logger.log("Department added: " + departmentId.text);
                } else {
                    logger.log("Failed to add department");
                }
                updateTable();
            }
        }
        Button {
            text: "Back"

            onClicked: navigateBack()
        }
    }
}
