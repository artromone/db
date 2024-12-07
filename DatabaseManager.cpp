#include <QDebug>
#include <QtSql/QSqlError>

#include "DatabaseManager.h"

DatabaseManager::DatabaseManager(const QString& dbName)
{
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbName);
    if (!db.open())
    {
        qFatal("Failed to open database: %s", qPrintable(db.lastError().text()));
    }
}

DatabaseManager::~DatabaseManager()
{
    if (db.isOpen())
    {
        db.close();
    }
}

bool DatabaseManager::executeQuery(const QString& queryStr)
{
    QSqlQuery query;
    if (!query.exec(queryStr))
    {
        qWarning() << "Query failed:" << query.lastError().text();
        return false;
    }
    return true;
}
