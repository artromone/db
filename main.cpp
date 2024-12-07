#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtSql/QSqlDatabase>

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
