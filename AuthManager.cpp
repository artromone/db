#include <QCryptographicHash>
#include <QDebug>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>

#include "AuthManager.h"

AuthManager::AuthManager(DatabaseManager& dbManager) : dbManager(dbManager)
{
}

bool AuthManager::login(const QString& username, const QString& password)
{
    QSqlQuery query;
    query.prepare("SELECT password FROM users WHERE username = :username");
    query.bindValue(":username", username);

    if (!query.exec())
    {
        qWarning() << "Login query failed:" << query.lastError().text();
        return false;
    }

    if (query.next())
    {
        QString storedHash = query.value(0).toString();
        QString inputHash =
            QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex();
        return storedHash == inputHash;
    }

    return false;
}
