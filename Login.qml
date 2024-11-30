import QtQuick 2.1
import QtQuick.Controls 2.1

Item {
    width: parent.width
    height: parent.height

    Column {
        anchors.centerIn: parent

        TextField {
            id: usernameField
            placeholderText: "Логин"
        }

        TextField {
            id: passwordField
            placeholderText: "Пароль"
            echoMode: TextInput.Password
        }

        Button {
            text: "Войти"
            onClicked: {
                var role = "";
                if (dbhandler.authenticate(usernameField.text, passwordField.text, role)) {
                    loader.source = "main.qml";
                } else {
                    console.log("Ошибка авторизации");
                }
            }
        }
    }
}
