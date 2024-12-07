import QtQuick 2.1 import QtQuick.Controls 2.1

    Item{signal navigateBack

         Column{anchors.centerIn:root spacing: 10

                Button{text: "Generate TXT Report"

                       onClicked:logger.log("TXT Report generated") } Button{text: "Generate PDF Report"

                                                                             onClicked:logger.log("PDF Report generated") } Button{text: "Back"

                                                                                                                                   onClicked:navigateBack() } } }
