#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtSql/QSqlDatabase>

#include "AuthManager.h"
#include "DatabaseManager.h"
#include "DateTimeValidator.h"

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<DatabaseManager>("DatabaseManager", 1, 0, "DatabaseManager");
    qmlRegisterType<DateTimeValidator>("DateTimeValidator", 1, 0, "DateTimeValidator");

    const auto am = new AuthManager();
    engine.rootContext()->setContextProperty("authManager", am);

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
