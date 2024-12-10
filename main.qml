import QtQuick 2.1
import QtQuick.Controls 2.1
import DatabaseManager 1.0

ApplicationWindow {
    id: root

    property string statusMessage: ""

    height: 700
    title: "Database Client Application"
    visible: true
    width: 1000

    DatabaseManager {
        id: dbManager

    }
    Login {
        id: loginPage

        anchors.fill: parent

        onLoginFailed: {
            logger.log("Login failed.");
        }
        onLoginSuccess: {
            menuPage.visible = true;
            visible = false;
            logger.log("Successfully logged in.");
        }
    }
    Menuu {
        id: menuPage

        anchors.fill: parent
        visible: false

        onNavigateToGoods: {
            goodPage.visible = true;
            menuPage.visible = false;
        }
         onNavigateToWarehouse2: {
            warehouse2Page.visible = true;
            menuPage.visible = false;
        }       onNavigateToWarehouse: {
            warehousePage.visible = true;
            menuPage.visible = false;
        }
        onNavigateToSales: {
            salesPage.visible = true;
            menuPage.visible = false;
        }
        onNavigateToReports: {
            reportPage.visible = true;
            menuPage.visible = false;
        }
    }

    Item {
        id: warehouse2Page
        anchors.fill: parent
        visible: false

        Warehouse2Form {
            onNavigateBack: {
                warehouse2Page.visible = false;
                menuPage.visible = true;
            }
        }
    }
    Item {
        id: warehousePage
        anchors.fill: parent
        visible: false

        WarehouseForm {
            onNavigateBack: {
                warehousePage.visible = false;
                menuPage.visible = true;
            }
        }
    }
    Item {
        id: goodPage

        anchors.fill: parent
        visible: false

        GoodForm {
            onNavigateBack: {
                goodPage.visible = false;
                menuPage.visible = true;
            }
        }
    }
    Item {
        id: salesPage

        anchors.fill: parent
        visible: false

        SalesForm {
            onNavigateBack: {
                salesPage.visible = false;
                menuPage.visible = true;
            }
        }
    }
    Item {
        id: reportPage

        anchors.fill: parent
        visible: false

        ReportView {
            onNavigateBack: {
                reportPage.visible = false;
                menuPage.visible = true;
            }
        }
    }
    Rectangle {
        id: messageBar

        anchors.bottom: parent.bottom
        color: "#e0e0e0"
        height: 40
        width: parent.width

        Text {
            anchors.centerIn: parent
            text: statusMessage
        }
    }
    Logger {
        id: logger

    }
}
