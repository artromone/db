import QtQuick 2.1
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1

Item {
    signal navigateBack

    function updateTable() {
        employeeTableView.visible = false;
        var employees = dbManager.fetchEmployees();
        employeeModel.clear();
        for (var i = 0; i < employees.length; i++) {
            employeeModel.append(employees[i]);
        }
        employeeTableView.visible = true;
    }

    Controls1.TableView {
        id: employeeTableView

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
            id: employeeModel

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
            role: "first_name"
            title: "First Name"
            width: 80
        }
        Controls1.TableViewColumn {
            role: "last_name"
            title: "Last Name"
            width: 80
        }
        Controls1.TableViewColumn {
            role: "fther_name"
            title: "Father Name"
            width: 90
        }
        Controls1.TableViewColumn {
            role: "position"
            title: "Position"
            width: 100
        }
        Controls1.TableViewColumn {
            role: "salary"
            title: "Salary"
            width: 50
        }
    }
    Menu {
        id: contextMenu

        MenuItem {
            text: "Fill Fields"

            onTriggered: {
                var selectedIndex = employeeTableView.activatedIdx;
                if (selectedIndex !== -1) {
                    var selectedEmployee = employeeModel.get(selectedIndex);
                    employeeId.text = selectedEmployee.id !== undefined && selectedEmployee.id !== null ? selectedEmployee.id : '';
                    employeeFirstName.text = selectedEmployee.first_name || '';
                    employeeLastName.text = selectedEmployee.last_name || '';
                    employeeFatherName.text = selectedEmployee.fther_name || '';
                    employeePosition.text = selectedEmployee.position || '';
                    employeeSalary.text = selectedEmployee.salary !== undefined && selectedEmployee.salary !== null ? selectedEmployee.salary.toString() : '';
                }
            }
        }
    }
    Column {
        id: column

        anchors.bottom: root.bottom
        anchors.left: employeeTableView.right
        anchors.leftMargin: 20
        anchors.right: root.right

        anchors.top: backBtn.bottom

        anchors.topMargin: 20
        spacing: 10
        visible: authManager.hasRoot

        TextField {
            id: employeeId

            placeholderText: "ID"
        }
        TextField {
            id: employeeFirstName

            placeholderText: "First Name"
        }
        TextField {
            id: employeeLastName

            placeholderText: "Last Name"
        }
        TextField {
            id: employeeFatherName

            placeholderText: "Father Name"
        }
        TextField {
            id: employeePosition

            placeholderText: "Position"
        }
        TextField {
            id: employeeSalary

            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Salary"
        }
        Button {
            text: "Add Employee"

            onClicked: {
                var salary = parseInt(employeeSalary.text);
                if (dbManager.addEmployee(employeeFirstName.text, employeeLastName.text, employeeFatherName.text, employeePosition.text, salary)) {
                    logger.log("Employee added: " + employeeFirstName.text + " " + employeeLastName.text);
                } else {
                    logger.log("Failed to add employee");
                }
                updateTable();
            }
        }
        Button {
            text: "Update Employee"

            onClicked: {
                var newFields = {
                    "first_name": employeeFirstName.text,
                    "last_name": employeeLastName.text,
                    "fther_name": employeeFatherName.text,
                    "position": employeePosition.text,
                    "salary": parseInt(employeeSalary.text)
                };
                if (dbManager.updateEmployee(parseInt(employeeId.text), newFields)) {
                    logger.log("Employee updated: " + employeeId.text);
                } else {
                    logger.log("Failed to updated employee");
                }
                updateTable();
            }
        }
        Button {
            text: "Delete Employee"

            onClicked: {
                if (dbManager.deleteEmployee(parseInt(employeeId.text))) {
                    logger.log("Employee deleted: " + employeeId.text);
                } else {
                    logger.log("Failed to delete employee");
                }
                updateTable();
            }
        }
    }
    Button {
        anchors.left: employeeTableView.right
        anchors.leftMargin: 20
        anchors.topMargin: 20
          id: backBtn
        anchors.top: root.top 
        spacing: 10
        text: "Back"

        onClicked: navigateBack()
    }
}
