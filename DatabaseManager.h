#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QString>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>

class DatabaseManager
{
public:
    explicit DatabaseManager(const QString& dbName);
    ~DatabaseManager();

    bool executeQuery(const QString& queryStr);

private:
    QSqlDatabase db;
};

#endif // DATABASEMANAGER_H
