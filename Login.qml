import QtQuick 2.1 import QtQuick.Controls 2.1

    Item{signal loginFailed signal loginSuccess

         Column{anchors.centerIn:parent spacing: 10

                TextField{id:username

                          placeholderText: "Username" } TextField{id:password

                                                                  echoMode:TextInput.Password placeholderText: "Password" } Button{text: "Login"

                                                                                                                                   onClicked: {if (authManager.login(username.text, password.text)){loginSuccess();
}
else
{
    loginFailed();
}
}
}
}
}
