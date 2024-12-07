import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    Column {
        anchors.centerIn: parent
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
            onClicked: console.log("Employee added: " + employeeName.text + ", " + employeePosition.text)
        }

        Button {
            text: "Edit Employee"
            onClicked: console.log("Employee edited")
        }

        Button {
            text: "Delete Employee"
            onClicked: console.log("Employee deleted")
        }
    }
}
