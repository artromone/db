import QtQuick 2.1
import QtQuick.Controls 2.1

Item {
    signal navigateToDE
    signal navigateToDepartments
    signal navigateToEmployees
    signal navigateToProjects
    signal navigateToReports

    Column {
        anchors.centerIn: parent
        spacing: 20

        Button {
            text: "Manage Employees"
            width: 200

            onClicked: {
                logger.log("Navigate to EmployeeForm");
                navigateToEmployees();
            }
        }
        Button {
            text: "Manage Departments"
            width: 200

            onClicked: {
                logger.log("Navigate to DepartmentForm");
                navigateToDepartments();
            }
        }
        Button {
            text: "Manage Department/Employees"
            width: 200

            onClicked: {
                logger.log("Navigate to DEForm");
                navigateToDE();
            }
        }
        Button {
            text: "Manage Projects"
            width: 200

            onClicked: {
                logger.log("Navigate to ProjectForm");
                navigateToProjects();
            }
        }
        Button {
            text: "Generate Reports"
            width: 200

            onClicked: {
                logger.log("Navigate to ReportView");
                navigateToReports();
            }
        }
    }
}
