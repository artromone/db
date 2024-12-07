import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    Column {
        anchors.centerIn: parent
        spacing: 10

        TextField {
            id: departmentName
            placeholderText: "Department Name"
        }

        Button {
            text: "Add Department"
            onClicked: console.log("Department added: " + departmentName.text)
        }

        Button {
            text: "Edit Department"
            onClicked: console.log("Department edited")
        }

        Button {
            text: "Delete Department"
            onClicked: console.log("Department deleted")
        }
    }
}
