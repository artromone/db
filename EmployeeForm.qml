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
    // Fetch employees
    var employees = dbManager.fetchEmployees();
        console.error(employees, employees.length);
    if (employees) {
        gridView.model.clear();
        for (var i = 0; i < employees.length; i++) {
            var employee = employees[i];
            gridView.model.append({
                id: employee.id,
                first_name: employee.first_name,
                last_name: employee.last_name,
                position: employee.position,
                salary: employee.salary
            });
        }
    } else {
        console.error("Failed to fetch employees");
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
