import QtQuick 2.1
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Controls 2.1

Item {
    signal navigateBack

    Controls1.TableView {
        id: employeeTableView

        alternatingRowColors: false
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.top: root.top
        height: 500
        width: 500

        headerDelegate: Item {
            height: 25

            Rectangle {
                anchors.fill: parent
                border.color: "gray"
                border.width: 1
                color: "lightgray"
            }
            Text {
                anchors.fill: parent
                anchors.margins: 5
                color: "black"
                elide: Text.ElideRight
                font.pixelSize: 13
                text: styleData.value
            }
        }
        itemDelegate: Item {
            Rectangle {
                anchors.fill: parent
                color: styleData.selected ? "black" : "white"
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: styleData.selected ? "white" : "black"
                // font.family: "Monospace"
                font.pixelSize: 13
                text: styleData.value
                wrapMode: Text.Wrap
            }
        }
        model: ListModel {
            id: employeeModel

        }
        rowDelegate: Rectangle {
            color: styleData.selected ? "black" : "white"
        }

        Component.onCompleted: {
            var metadata = dbManager.getTableMetadata("employees");
            console.log("Columns:", metadata.columns);
            console.log("Foreign Keys:", metadata.foreign_keys);
            var employees = dbManager.fetchEmployees();
            employeeModel.clear();
            for (var i = 0; i < employees.length; i++) {
                employeeModel.append(employees[i]);
            }
        }

        Controls1.TableViewColumn {
            role: "id"
            title: "ID"
            width: 30
        }
        Controls1.TableViewColumn {
            role: "first_name"
            title: "First Name"
            width: 80
        }
        Controls1.TableViewColumn {
            role: "last_name"
            title: "Last Name"
            width: 80
        }
        Controls1.TableViewColumn {
            role: "position"
            title: "Position"
            width: 100
        }
        Controls1.TableViewColumn {
            role: "salary"
            title: "Salary"
            width: 50
        }
    }
    Column {
        anchors.bottom: root.bottom
        anchors.left: employeeTableView.right
        anchors.leftMargin: 20
        anchors.right: root.right
        anchors.top: parent.top
        anchors.topMargin: 20
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
