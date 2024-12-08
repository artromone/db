import QtQuick 2.1
import QtQuick.Controls 2.1

Item {
    signal navigateBack

    Column {
        anchors.centerIn: root
        spacing: 10

        GridView {
            id: gridView

            cellHeight: 50
            cellWidth: 200
            height: root.height / 2
            width: root.width / 2

            delegate: Item {
                height: gridView.cellHeight
                width: gridView.cellWidth

                Rectangle {
                    border.color: "gray"
                    color: "lightgray"
                    height: parent.height
                    width: parent.width

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            font.bold: true
                            text: "ID: " + model.id
                        }
                        Text {
                            text: "Name: " + model.first_name + " " + model.last_name
                        }
                        Text {
                            text: "Position: " + model.position
                        }
                        Text {
                            text: "Department: " + model.department_name
                        }
                    }
                }
            }
            model: ListModel {
                id: employeeModel

            }

            Component.onCompleted: {
                var metadata = dbManager.getTableMetadata("employees");
                console.log("Columns:", metadata.columns);
                console.log("Foreign Keys:", metadata.foreign_keys);
                var employees = dbManager.fetchEmployees();
                gridView.model.clear();
                for (var i = 0; i < employees.length; i++) {
                    gridView.model.append(employees[i]);
                    console.log("@:", employees[i].first_name);
                }
            }
        }
        TextField {
            id: employeeName

            placeholderText: "Employee Name"
        }
        TextField {
            id: employeePosition

            placeholderText: "Position"
        }
        Button {
            text: "Add Employee"

            onClicked: logger.log("Employee added: " + employeeName.text + ", " + employeePosition.text)
        }
        Button {
            text: "Edit Employee"

            onClicked: logger.log("Employee edited")
        }
        Button {
            text: "Delete Employee"

            onClicked: logger.log("Employee deleted")
        }
        Button {
            text: "Back"

            onClicked: navigateBack()
        }
    }
}
