import QtQuick 2.1 import QtQuick.Controls 2.1 import DatabaseManager 1.0

    ApplicationWindow{id:root

                      property string statusMessage: ""

                      height: 600 title: "Database Client Application" visible: true width: 800

                      DatabaseManager{id:dbManager

} Login{id:loginPage

                      anchors.fill:parent

                      onLoginFailed: {logger.log("Login failed.");
}
onLoginSuccess:
{
    menuPage.visible = true;
    visible = false;
    logger.log("Successfully logged in.");
}
}
Menuu
{
id:
    menuPage

        anchors.fill : parent visible : false

                                        onNavigateToDepartments:
    {
        departmentPage.visible = true;
        menuPage.visible = false;
    }
onNavigateToEmployees: {
    employeePage.visible = true;
    menuPage.visible = false;
}
onNavigateToProjects: {
    projectPage.visible = true;
    menuPage.visible = false;
}
onNavigateToReports: {
    reportPage.visible = true;
    menuPage.visible = false;
}
}
Item
{
id:
    employeePage

        anchors.fill : parent visible : false

                                        EmployeeForm
    {
    onNavigateBack: {
        employeePage.visible = false;
        menuPage.visible = true;
    }
    }
}
Item
{
id:
    departmentPage

        anchors.fill : parent visible : false

                                        DepartmentForm
    {
    onNavigateBack: {
        departmentPage.visible = false;
        menuPage.visible = true;
    }
    }
}
Item
{
id:
    projectPage

        anchors.fill : parent visible : false

                                        ProjectForm
    {
    onNavigateBack: {
        projectPage.visible = false;
        menuPage.visible = true;
    }
    }
}
Item
{
id:
    reportPage

        anchors.fill : parent visible : false

                                        ReportView
    {
    onNavigateBack: {
        reportPage.visible = false;
        menuPage.visible = true;
    }
    }
}
Rectangle
{
id:
    messageBar

        anchors.bottom : parent.bottom color : "#e0e0e0" height : 40 width : parent.width

                                                                             Text
    {
        anchors.centerIn : parent text : statusMessage
    }
}
Logger
{
id:
    logger
}
}
