#include <QCryptographicHash>
#include <QDebug>
#include <QFile>
#include <QSettings>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>

#include "AuthManager.h"
#include "DatabaseInstance.h"

bool AuthManager::login(const QString& username, const QString& password)
{
    QByteArray hashedPassword =
        QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256);

    QSqlQuery query;
    query.prepare("SELECT role FROM users WHERE username = :username AND password = :password");
    query.bindValue(":username", username);
    query.bindValue(":password", hashedPassword.toHex());

    if (!query.exec())
    {
        qCritical() << "Database query failed: " << query.lastError().text();
        return false;
    }

    if (query.next())
    {
        QString role = query.value(0).toString();
        qDebug() << "Login successful for user:" << username;
        provideAccessToDatabase(role);
        return true;
    }
    else
    {
        qDebug() << "Login failed for user:" << username;
        return false;
    }
}

void AuthManager::provideAccessToDatabase(const QString& role)
{
    if (role == "admin")
    {
        qDebug() << "Providing admin access to the main database.";
    }
    else if (role == "user")
    {
        qDebug() << "Providing limited user access to the main database.";
    }
    else
    {
        qDebug() << "Unknown role. Access denied.";
    }
}

AuthManager::AuthManager(QObject* parent)
{
    db_ = DatabaseInstance::getInstance();

    QFile scriptFile("users.sql");
    if (!scriptFile.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qWarning() << "Failed to open the script file:" << scriptFile.errorString();
        return;
    }

    QTextStream in(&scriptFile);
    QString script = in.readAll();
    scriptFile.close();

    QStringList statements = script.split(";", QString::SkipEmptyParts);
    QSqlQuery query(db_);

    for (const QString& statement : statements)
    {
        qDebug() << "- Executing:" << statement;
        if (!query.exec(statement.trimmed()))
        {
            qWarning() << "| Failed to execute the statement:" << query.lastError().text();
        }
    }

    setUserPasswords("admin", "user");
}

void AuthManager::createUserTableIfNotExists(const QString& scriptFileName)
{
}

void AuthManager::setUserPasswords(const QString& adminPassword, const QString& operatorPassword)
{
    QByteArray adminHashedPassword =
        QCryptographicHash::hash(adminPassword.toUtf8(), QCryptographicHash::Sha256);
    QByteArray operatorHashedPassword =
        QCryptographicHash::hash(operatorPassword.toUtf8(), QCryptographicHash::Sha256);

    QSqlQuery query;
    query.prepare("UPDATE users SET password = :password WHERE username = :username");

    query.bindValue(":username", "admin");
    query.bindValue(":password", adminHashedPassword.toHex());
    if (!query.exec())
    {
        qCritical() << "Failed to update password for admin: " << query.lastError().text();
    }

    query.bindValue(":username", "user");
    query.bindValue(":password", operatorHashedPassword.toHex());
    if (!query.exec())
    {
        qCritical() << "Failed to update password for user: " << query.lastError().text();
    }
}
