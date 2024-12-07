import QtQuick 2.1

QtObject {
    id: logger

    signal logMessage(string message)

    function log(message, r) {
        root.statusMessage = message;
        console.log(message);
        logger.logMessage(message);
    }
}
