import QtQuick 2.1
import QtQuick.Controls 2.1

Item {
    signal navigateBack

    Column {
        anchors.centerIn: root
        spacing: 10

        TextField {
            id: projectName

            placeholderText: "Project Name"
        }
        TextField {
            id: projectCost

            placeholderText: "Project Cost"
        }
        TextField {
            id: projectDeadline

            placeholderText: "Project Deadline"
        }
        Button {
            text: "Add Project"

            onClicked: logger.log("Project added: " + projectName.text + ", Cost: " + projectCost.text)
        }
        Button {
            text: "Edit Project"

            onClicked: logger.log("Project edited")
        }
        Button {
            text: "Delete Project"

            onClicked: logger.log("Project deleted")
        }
        Button {
            text: "Back"

            onClicked: navigateBack()
        }
    }
}
