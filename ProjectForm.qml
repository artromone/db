import QtQuick 2.1
import QtQuick.Controls 2.1
import DateTimeValidator 1.0

import QtQuick.Controls 1.4 as Controls1

Item {
    signal navigateBack

    function updateTable() {
        projectsTableView.visible = false;
        var metadata = dbManager.getTableMetadata("projects");
        console.log("Columns:", metadata.columns);
        console.log("Foreign Keys:", metadata.foreign_keys);
        var projects = dbManager.fetchProjects();
        projectModel.clear();
        for (var i = 0; i < projects.length; i++) {
            projectModel.append(projects[i]);
        }
        projectsTableView.visible = true;
    }

    Controls1.TableView {
        id: projectsTableView

        property int activatedIdx: -1

        alternatingRowColors: false
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.top: root.top
        height: 500
        width: 700

        headerDelegate: Item {
            height: 25

            Rectangle {
                anchors.fill: parent
                border.color: "gray"
                border.width: 1
                color: "lightgray"
            }
            Text {
                anchors.fill: ponClickedarent
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
                font.pixelSize: 13
                text: styleData.value
                wrapMode: Text.Wrap
            }
        }
        model: ListModel {
            id: projectModel

        }
        rowDelegate: Rectangle {
            color: styleData.selected ? "black" : "white"
        }

        Component.onCompleted: {
            updateTable();
        }
        onActivated: {
            contextMenu.popup();
            activatedIdx = row;
        }

        Controls1.TableViewColumn {
            role: "id"
            title: "ID"
            width: 30
        }
        Controls1.TableViewColumn {
            role: "name"
            title: "Name"
            width: 80
        }
        Controls1.TableViewColumn {
            role: "cost"
            title: "Cost"
            width: 80
        }
        Controls1.TableViewColumn {
            role: "department_id"
            title: "Department ID"
            width: 100
        }
        Controls1.TableViewColumn {
            role: "beg_date"
            title: "Begin Date"
            width: 160
        }
        Controls1.TableViewColumn {
            role: "end_date"
            title: "End Date"
            width: 150
        }
        Controls1.TableViewColumn {
            role: "end_real_date"
            title: "End Real Date"
            width: 150
        }
    }
    Menu {
        id: contextMenu

        MenuItem {
            text: "Fill Fields"

            onTriggered: {
                var selectedIndex = projectsTableView.activatedIdx;
                if (selectedIndex !== -1) {
                    var selectedProject = projectModel.get(selectedIndex);
                    projectId.text = selectedProject.id !== undefined && selectedProject.id !== null ? selectedProject.id : '';
                    projectName.text = selectedProject.name || '';
                    projectCost.text = selectedProject.cost !== undefined && selectedProject.cost !== null ? selectedProject.cost.toString() : '';
                    projectDepartment.text = selectedProject.department_id !== undefined && selectedProject.department_id !== null ? selectedProject.department_id.toString() : '';
                    projectBegDate.text = selectedProject.beg_date || '';
                    projectEndDate.text = selectedProject.end_date || '';
                    projectEndRealDate.text = selectedProject.end_real_date || '';
                }
            }
        }
    }
    Column {
        anchors.bottom: root.bottom
        anchors.left: projectsTableView.right
        anchors.leftMargin: 20
        anchors.right: root.right
        anchors.top: parent.top
        anchors.topMargin: 20
        spacing: 10

        TextField {
            id: projectId

            placeholderText: "ID"
        }
        TextField {
            id: projectName

            placeholderText: "Project Name"
        }
        TextField {
            id: projectCost

            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Project Cost"
        }
        TextField {
            id: projectDepartment

            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: "Department ID"
        }
        TextField {
            id: projectBegDate

            inputMask: "99.99.9999 99:99:99"
            text: Qt.formatDateTime(new Date(), "dd.MM.yyyy HH:mm:ss")

            validator: DateTimeValidator {
            }
        }
        TextField {
            id: projectEndDate

            inputMask: "99.99.9999 99:99:99"
            text: Qt.formatDateTime(new Date(), "dd.MM.yyyy HH:mm:ss")

            validator: DateTimeValidator {
            }
        }
        TextField {
            id: projectEndRealDate

            inputMask: "99.99.9999 99:99:99"
            text: Qt.formatDateTime(new Date(), "dd.MM.yyyy HH:mm:ss")

            validator: DateTimeValidator {
            }
        }
        Button {
            text: "Add Project"

            onClicked: {
                var cost = parseInt(projectCost.text);
                var departmentId = parseInt(projectDepartment.text);
                var begDate = projectBegDate.text;
                var endDate = projectEndDate.text;
                if (dbManager.addProject(projectName.text, cost, departmentId, begDate, endDate)) {
                    logger.log("Project added: " + projectName.text);
                } else {
                    logger.log("Failed to add project");
                }
                updateTable();
            }
        }
        Button {
            text: "Update Project"

            onClicked: {
                var newFields = {
                    "name": projectName.text,
                    "cost": parseInt(projectCost.text),
                    "department_id": parseInt(projectDepartment.text),
                    "beg_date": projectBegDate.text,
                    "end_date": projectEndDate.text,
                    "end_real_date": projectEndRealDate.text
                };
                if (dbManager.updateProject(parseInt(projectId.text), newFields)) {
                    logger.log("Project updated: " + parseInt(projectId.text));
                } else {
                    logger.log("Failed to update project");
                }
                updateTable();
            }
        }
        Button {
            text: "Delete Project"

            onClicked: {
                if (dbManager.deleteProject(parseInt(projectId.text))) {
                    logger.log("Project deleted: " + parseInt(projectId.text));
                } else {
                    logger.log("Failed to delete project");
                }
                updateTable();
            }
        }
        Button {
            text: "Back"

            onClicked: navigateBack()
        }
    }
}
