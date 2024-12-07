import QtQuick 2.1
import QtQuick.Controls 2.1

Item {
    signal navigateToDepartments
    signal navigateToEmployees
    signal navigateToProjects
    signal navigateToReports

    Column {
        anchors.centerIn: parent
        spacing: 20

        Button {
            text: "Manage Employees"

            onClicked: {
                console.log("Navigate to EmployeeForm");
                navigateToEmployees();
            }
        }
        Button {
            text: "Manage Departments"

            onClicked: {
                console.log("Navigate to DepartmentForm");
                navigateToDepartments();
            }
        }
        Button {
            text: "View Projects"

            onClicked: {
                console.log("Navigate to ProjectForm");
                navigateToProjects();
            }
        }
        Button {
            text: "Generate Reports"

            onClicked: {
                console.log("Navigate to ReportView");
                navigateToReports();
            }
        }
    }
}
