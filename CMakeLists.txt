cmake_minimum_required(VERSION 3.5)

# Имя проекта
project(MyApp LANGUAGES CXX)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

# Указываем минимально необходимую версию Qt
find_package(Qt5 5.11 REQUIRED COMPONENTS Core Gui Quick Sql QuickControls2)

# Указываем путь к исходным файлам
set(SOURCES
    main.cpp
    DatabaseHandler.cpp
)

# Заголовочные файлы
set(HEADERS
    DatabaseHandler.h
)

# QML файлы
set(QML_FILES
    qml/main.qml
    qml/Login.qml
    qml/AddEditDialog.qml
    qml/Reports.qml
)

# Указываем путь к файлу конфигурации
configure_file(config.ini ${CMAKE_CURRENT_BINARY_DIR}/config.ini COPYONLY)

# Генерация ресурсов (если есть файлы qrc)
qt5_add_resources(RESOURCES qml.qrc)

# Добавление исполняемого файла
add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS} ${RESOURCES})

# Подключение Qt-библиотек
target_link_libraries(${PROJECT_NAME}
    Qt5::Core
    Qt5::Gui
    Qt5::Quick
    Qt5::Sql
    Qt5::QuickControls2
)

# Установка пути к ресурсам для QML
set_target_properties(${PROJECT_NAME} PROPERTIES
    QML_IMPORT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/qml
    QML2_IMPORT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/qml
)

# Копирование QML файлов в директорию сборки
install(DIRECTORY qml DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
