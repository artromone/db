#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtSql/QSqlDatabase>
#include "DatabaseManager.h"
#include "DateTimeValidator.h"

void setupDatabase()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("database.db");
    if (!db.open())
    {
        qFatal("Failed to connect to the database.");
    }
}

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<DatabaseManager>("DatabaseManager", 1, 0, "DatabaseManager");
 qmlRegisterType<DateTimeValidator>("DateTimeValidator", 1, 0, "DateTimeValidator");

    setupDatabase();

    QQmlApplicationEngine engine;
    const QUrl url("qrc:/main.qml");
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &app,
        [url](QObject* obj, const QUrl& objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
