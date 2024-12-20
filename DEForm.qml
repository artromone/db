import QtQuick 2.1
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Controls 2.1

Item {
    signal navigateBack

    function updateTable() {
        departmentEmployeesTableView.visible = false;
        var departmentEmployees = dbManager.fetchDepartmentEmployees();
        departmentEmployeesModel.clear();
        for (var i = 0; i < departmentEmployees.length; i++) {
            departmentEmployeesModel.append(departmentEmployees[i]);
        }
        departmentEmployeesTableView.visible = true;
    }

    Controls1.TableView {
        id: departmentEmployeesTableView

        property int activatedIdx: -1

        alternatingRowColors: false
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.top: root.top
        height: 500
        width: 400

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
            id: departmentEmployeesModel

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
            role: "department_id"
            title: "Department ID"
            width: 100
        }
        Controls1.TableViewColumn {
            role: "employee_id"
            title: "Employee ID"
            width: 100
        }
    }
    Menu {
        id: contextMenu

        MenuItem {
            text: "Fill Fields"

            onTriggered: {
                var selectedIndex = departmentEmployeesTableView.activatedIdx;
                if (selectedIndex !== -1) {
                    var selectedDepartmentEmployee = departmentEmployeesModel.get(selectedIndex);
                    departmentEmployeeId.text = selectedDepartmentEmployee.id || '';
                    departmentId.text = selectedDepartmentEmployee.department_id || '';
                    employeeId.text = selectedDepartmentEmployee.employee_id || '';
                }
            }
        }
    }
    Column {
        id: column

        anchors.bottom: root.bottom
        anchors.left: departmentEmployeesTableView.right
        anchors.leftMargin: 20
        anchors.right: root.right
        anchors.top: backBtn.bottom
        anchors.topMargin: 20
        spacing: 10
        visible: authManager.hasRoot

        TextField {
            id: departmentEmployeeId

            placeholderText: "ID"
        }
        TextField {
            id: departmentId

            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Department ID"
        }
        TextField {
            id: employeeId

            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Employee ID"
        }
        Button {
            text: "Add Department Employee"

            onClicked: {
                var depId = parseInt(departmentId.text);
                var empId = parseInt(employeeId.text);
                if (dbManager.addDepartmentEmployee(depId, empId)) {
                    logger.log("Department Employee added: Department " + depId + ", Employee " + empId);
                } else {
                    logger.log("Failed to add Department Employee");
                }
                updateTable();
            }
        }
        Button {
            text: "Update Department Employee"

            onClicked: {
                var newFields = {
                    "department_id": parseInt(departmentId.text),
                    "employee_id": parseInt(employeeId.text)
                };
                if (dbManager.updateDepartmentEmployee(parseInt(departmentEmployeeId.text), newFields)) {
                    logger.log("Department Employee updated: " + departmentEmployeeId.text);
                } else {
                    logger.log("Failed to update Department Employee");
                }
                updateTable();
            }
        }
        Button {
            text: "Delete Department Employee"

            onClicked: {
                if (dbManager.deleteDepartmentEmployee(parseInt(departmentEmployeeId.text))) {
                    logger.log("Department Employee deleted: " + departmentEmployeeId.text);
                } else {
                    logger.log("Failed to delete Department Employee");
                }
                updateTable();
            }
        }
    }
    Button {
        id: backBtn

        anchors.left: departmentEmployeesTableView.right
        anchors.leftMargin: 20
        anchors.top: root.top
        anchors.topMargin: 20
        spacing: 10
        text: "Back"

        onClicked: navigateBack()
    }
}
