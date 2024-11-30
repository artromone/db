#ifndef DATABASEHANDLER_H
#define DATABASEHANDLER_H

#include <QCryptographicHash>
#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>

class DatabaseHandler : public QObject
{
    Q_OBJECT

public:
    DatabaseHandler(QObject* parent = nullptr);
    Q_INVOKABLE bool connectDatabase(const QString& configPath);
    Q_INVOKABLE bool authenticate(const QString& username, const QString& password, QString& role);

private:
    QSqlDatabase db;
    QString hashPassword(const QString& password);
};

#endif // DATABASEHANDLER_H
