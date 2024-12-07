import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    Column {
        anchors.centerIn: parent
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
            onClicked: console.log("Project added: " + projectName.text + ", Cost: " + projectCost.text)
        }

        Button {
            text: "Edit Project"
            onClicked: console.log("Project edited")
        }

        Button {
            text: "Delete Project"
            onClicked: console.log("Project deleted")
        }
    }
}
