import QtQuick 2.1
import QtQuick.Controls 2.1

Dialog {
    id: dialog
    title: "Добавить/Редактировать запись"

    Column {
        spacing: 10

        TextField {
            id: field1
            placeholderText: "Поле 1"
        }

        TextField {
            id: field2
            placeholderText: "Поле 2"
        }

        Row {
            Button {
                text: "Сохранить"
                onClicked: dialog.close()
            }
            Button {
                text: "Отмена"
                onClicked: dialog.close()
            }
        }
    }
}
