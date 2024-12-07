import QtQuick 2.1
import QtQuick.Controls 2.1

Item {
    signal navigateBack

    Column {
        anchors.centerIn: root
        spacing: 10

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
