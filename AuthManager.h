#ifndef AUTHMANAGER_H
#define AUTHMANAGER_H

#include <QObject>
#include <QSqlQuery>

class AuthManager : public QObject
{
    Q_OBJECT

public:
    explicit AuthManager(QObject* parent = nullptr);
    Q_INVOKABLE bool login(const QString& username, const QString& password);
    void provideAccessToDatabase(const QString& role);
    void setUserPasswords(const QString& adminPassword, const QString& operatorPassword);

private:
    QSqlDatabase db_;
};

#endif // AUTHMANAGER_H
