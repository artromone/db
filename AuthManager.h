#ifndef AUTHMANAGER_H
#define AUTHMANAGER_H

#include <QString>

#include "DatabaseManager.h"

class AuthManager
{
public:
    explicit AuthManager(DatabaseManager& dbManager);

    bool login(const QString& username, const QString& password);

private:
    DatabaseManager& dbManager;
};

#endif // AUTHMANAGER_H
