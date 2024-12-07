import QtQuick 2.15
import QtQuick.Controls 2.15
import DatabaseClient 1.0

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Database Client Application"

    Login {
        id: loginPage
        anchors.fill: parent
        visible: true
        onLoginSuccess: {
            menuPage.visible = true
            loginPage.visible = false
        }
    }

    Menu {
        id: menuPage
        anchors.fill: parent
        visible: false
    }
}
