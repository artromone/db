#ifndef DATABASEINSTANCE_H
#define DATABASEINSTANCE_H

#include <QDebug>
#include <QSettings>
#include <QSqlDatabase>
#include <QSqlError>

class DatabaseInstance
{
public:
    static QSqlDatabase& getInstance(const QString& configFilePath = "config.ini")
    {
        static QSqlDatabase instance = setupDatabase(configFilePath);
        return instance;
    }

    DatabaseInstance(const DatabaseInstance&) = delete;
    DatabaseInstance& operator=(const DatabaseInstance&) = delete;

private:
    static QSqlDatabase setupDatabase(const QString& configFilePath)
    {
        QSettings settings(configFilePath, QSettings::IniFormat);

        QString host = settings.value("Database/host", "localhost").toString();
        int port = settings.value("Database/port", 5432).toInt();
        QString dbName = settings.value("Database/databaseName", "").toString();
        QString username = settings.value("Database/username", "").toString();
        QString password = settings.value("Database/password", "").toString();

        QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
        db.setHostName(host);
        db.setPort(port);
        db.setDatabaseName(dbName);
        db.setUserName(username);
        db.setPassword(password);

        if (!db.open())
        {
            qFatal("Failed to open database: %s", qPrintable(db.lastError().text()));
        }

        return db;
    }

    DatabaseInstance() = default;
};


#endif /* DATABASEINSTANCE_H */
