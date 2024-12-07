import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    signal loginSuccess

    Column {
        anchors.centerIn: parent
        spacing: 10

        TextField {
            id: username
            placeholderText: "Username"
        }

        TextField {
            id: password
            placeholderText: "Password"
            echoMode: TextInput.Password
        }

        Button {
            text: "Login"
            onClicked: {
                if (username.text === "admin" && password.text === "1234") {
                    loginSuccess()
                } else {
                    console.log("Invalid credentials")
                }
            }
        }
    }
}
