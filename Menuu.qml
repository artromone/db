import QtQuick 2.1
import QtQuick.Controls 2.1

Item {
    signal navigateToGoods
    signal navigateToWarehouse
    signal navigateToWarehouse2
    signal navigateToSales 
    signal navigateToReports

    Column {
        anchors.centerIn: parent
        spacing: 20

         Button {
            text: "Manage Warehouse2"
            width: 200

            onClicked: {
                logger.log("Navigate to WarehouseForm2");
                navigateToWarehouse2();
            }
        }       Button {
            text: "Manage Warehouse"
            width: 200

            onClicked: {
                logger.log("Navigate to WarehouseForm");
                navigateToWarehouse();
            }
        }
        Button {
            text: "Manage Goods"
            width: 200

            onClicked: {
                logger.log("Navigate to GoodForm");
                navigateToGoods();
            }
        }
        Button {
            text: "Manage Sales"
            width: 200

            onClicked: {
                logger.log("Navigate to Sales");
                navigateToSales();
            }
        }
        Button {
            text: "Generate Reports"
            width: 200

            onClicked: {
                logger.log("Navigate to ReportView");
                navigateToReports();
            }
        }
    }
}
