import QtQuick 2.1
import QtQuick.Controls 2.1

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

    Menuu {
        id: menuPage
        anchors.fill: parent
        visible: false
    }
}
