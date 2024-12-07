import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    Column {
        anchors.centerIn: parent
        spacing: 20

        Button {
            text: "Manage Employees"
            onClicked: console.log("Navigate to EmployeeForm")
        }

        Button {
            text: "Manage Departments"
            onClicked: console.log("Navigate to DepartmentForm")
        }

        Button {
            text: "View Projects"
            onClicked: console.log("Navigate to ProjectForm")
        }

        Button {
            text: "Generate Reports"
            onClicked: console.log("Navigate to ReportView")
        }
    }
}
