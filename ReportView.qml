import QtQuick 2.1
import QtQuick.Controls 2.1

Item {
    signal navigateBack

    Column {
        anchors.centerIn: root
        spacing: 10

        Button {
            text: "Generate TXT Report"

            onClicked: {
                dbManager.generateReportTXT("goods");
                dbManager.generateReportTXT("sales");
                dbManager.generateReportTXT("warehouse1");
                dbManager.generateReportTXT("warehouse2");
                logger.log("TXT Report generated");
            }
        }
        Button {
            text: "Generate PDF Report"

            onClicked: {
                 dbManager.generateReportPDF("goods");
                dbManager.generateReportPDF("sales");
                dbManager.generateReportPDF("warehouse1");
                dbManager.generateReportPDF("warehouse2");
                logger.log("PDF Report generated");
            }
        }
        Button {
            text: "Back"

            onClicked: navigateBack()
        }
    }
}
