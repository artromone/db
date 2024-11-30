#include <QDebug>
#include <QSettings>

#include "DatabaseHandler.h"

DatabaseHandler::DatabaseHandler(QObject* parent): QObject(parent)
{
}

bool DatabaseHandler::connectDatabase(const QString& configPath)
{
    QSettings settings(configPath, QSettings::IniFormat);
    QString host = settings.value("Database/Host").toString();
    QString dbName = settings.value("Database/Name").toString();
    QString user = settings.value("Database/User").toString();
    QString password = settings.value("Database/Password").toString();
    int port = settings.value("Database/Port").toInt();

    db = QSqlDatabase::addDatabase("QPSQL");
    db.setHostName(host);
    db.setDatabaseName(dbName);
    db.setUserName(user);
    db.setPassword(password);
    db.setPort(port);

    if (!db.open())
    {
        qWarning() << "Failed to connect to the database:" << db.lastError().text();
        return false;
    }
    return true;
}

QString DatabaseHandler::hashPassword(const QString& password)
{
    return QString(QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex());
}

bool DatabaseHandler::authenticate(const QString& username, const QString& password, QString& role)
{
    QSqlQuery query;
    query.prepare("SELECT password_hash, role FROM users WHERE username = :username");
    query.bindValue(":username", username);

    if (query.exec() && query.next())
    {
        QString storedHash = query.value(0).toString();
        role = query.value(1).toString();
        return hashPassword(password) == storedHash;
    }
    return false;
}
