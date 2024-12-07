import QtQuick 2.1 import QtQuick.Controls 2.1 import DateTimeValidator 1.0

    Item{signal navigateBack

         Column{anchors.centerIn:root spacing: 10

                TextField{id:projectName

                          placeholderText: "Project Name" } TextField{id:projectCost

                                                                      inputMethodHints:Qt.ImhFormattedNumbersOnly placeholderText: "Project Cost" } TextField{id:projectDepartment

                                                                                                                                                              inputMethodHints:Qt.ImhFormattedNumbersOnly placeholderText: "Department ID" } TextField{id:projectBegDate

                                                                                                                                                                                                                                                       inputMask: "99.99.9999 99:99:99"
                                                                                                                                                                                                                                                       // text: "01.01.1970 00:00:00"
                                                                                                                                                                                                                                                       text:Qt.formatDateTime(new Date(), "dd.MM.yyyy HH:mm:ss")

                                                                                                                                                                                                                                                                                  validator:DateTimeValidator{} } TextField{id:projectEndDate

                                                                                                                                                                                                                                                                                                                            inputMask: "99.99.9999 99:99:99"
                                                                                                                                                                                                                                                                                                                            // text: "01.01.1970 00:00:00"
                                                                                                                                                                                                                                                                                                                            text:Qt.formatDateTime(new Date(), "dd.MM.yyyy HH:mm:ss")

                                                                                                                                                                                                                                                                                                                                                       validator:DateTimeValidator{} } Button{text: "Add Project"

                                                                                                                                                                                                                                                                                                                                                                                              onClicked: {var cost = parseInt(projectCost.text);
var departmentId = parseInt(projectDepartment.text);
var begDate = projectBegDate.text;
var endDate = projectEndDate.text;
if (dbManager.addProject(projectName.text, cost, departmentId, begDate, endDate))
{
    logger.log("Project added: " + projectName.text + ", Cost: " + projectCost.text);
}
else
{
    logger.log("Failed to add project");
}
}
}
Button
{
text:
    "Edit Project"

        onClicked:
    {
        var projectId = 1;
        var cost = parseInt(projectCost.text);
        var departmentId = parseInt(projectDepartment.text);
        var begDate = projectBegDate.date;
        var endDate = projectEndDate.date;

        // if (dbManager.editProject(projectId, projectName.text, cost, departmentId, begDate, endDate)) {
        //     logger.log("Project edited: " + projectId);
        // } else {
        logger.log("Failed to edit project");
        // }
    }
}
Button
{
text:
    "Delete Project"

        onClicked:
    {
        // Указываем ID проекта для удаления
        var projectId = 1; // Пример ID проекта
        if (dbManager.deleteProject(projectId))
        {
            logger.log("Project deleted: " + projectId);
        }
        else
        {
            logger.log("Failed to delete project");
        }
    }
}
Button
{
text:
    "Back"

        onClicked : navigateBack()
}
}
}
