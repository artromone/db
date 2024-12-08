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
                dbManager.generateReportTXT("projects");
                dbManager.generateReportTXT("emplyees");
                dbManager.generateReportTXT("departments");
                dbManager.generateReportTXT("department_employees");
                logger.log("TXT Report generated");
            }
        }
        Button {
            text: "Generate PDF Report"

            onClicked: {
                dbManager.generateReportPDF("projects");
                dbManager.generateReportPDF("emplyees");
                dbManager.generateReportPDF("departments");
                dbManager.generateReportPDF("department_employees");
                logger.log("PDF Report generated");
            }
        }
        Button {
            text: "Back"

            onClicked: navigateBack()
        }
    }
}
