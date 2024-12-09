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

    Q_PROPERTY(int hasRoot READ hasRootAccess NOTIFY hasRootChanged);
    bool hasRootAccess() { return rootAccess_; };

signals:
    void hasRootChanged();

private:
    QSqlDatabase db_;
    bool rootAccess_;
};

#endif // AUTHMANAGER_H
