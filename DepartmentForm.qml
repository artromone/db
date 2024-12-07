import QtQuick 2.1
import QtQuick.Controls 2.1

Item {
    signal navigateBack

    Column {
        anchors.centerIn: root
        spacing: 10

        TextField {
            id: departmentName

            placeholderText: "Department Name"
        }
        Button {
            text: "Add Department"

            onClicked: logger.log("Department added: " + departmentName.text)
        }
        Button {
            text: "Edit Department"

            onClicked: logger.log("Department edited")
        }
        Button {
            text: "Delete Department"

            onClicked: logger.log("Department deleted")
        }
        Button {
            text: "Back"

            onClicked: navigateBack()
        }
    }
}
