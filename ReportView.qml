import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    Column {
        anchors.centerIn: parent
        spacing: 10

        Button {
            text: "Generate TXT Report"
            onClicked: console.log("TXT Report generated")
        }

        Button {
            text: "Generate PDF Report"
            onClicked: console.log("PDF Report generated")
        }
    }
}

