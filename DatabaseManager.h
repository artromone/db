#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QDateTime>
#include <QJsonArray>
#include <QList>
#include <QString>
#include <QVariantMap>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>

class DatabaseManager : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseManager();
    ~DatabaseManager();

    bool executeQuery(const QString& queryStr);

    // Operations with departments
    Q_INVOKABLE bool addDepartment();
    Q_INVOKABLE bool deleteDepartment(int departmentId);
    Q_INVOKABLE QList<QVariantMap> fetchDepartments();

    // Operations with employees
    Q_INVOKABLE bool addEmployee(const QString& firstName,
                                 const QString& lastName,
                                 const QString& position,
                                 int salary);
    Q_INVOKABLE bool assignEmployeeToDepartment(int employeeId, int departmentId);
    Q_INVOKABLE bool deleteEmployee(int employeeId);
    Q_INVOKABLE QJsonArray fetchEmployees();


    Q_INVOKABLE QList<QVariantMap> fetchEmployeesWithDepartments();

    // Operations with projects
    Q_INVOKABLE bool addProject(const QString& name,
                                int cost,
                                int departmentId,
                                const QString& begDate,
                                const QString& endDate);

    Q_INVOKABLE bool updateProject(const QString& name, const QVariantMap& newFields);
    Q_INVOKABLE bool deleteProject(const QString& name);
    Q_INVOKABLE QJsonArray fetchProjects();

    Q_INVOKABLE QVariantMap getTableMetadata(const QString& tableName);

signals:
    void departmentAdded();
    void departmentDeleted();
    void employeeAdded();
    void employeeDeleted();
    void projectAdded();
    void projectUpdated();
    void projectDeleted();

private:
    QSqlDatabase db_;
};

#endif // DATABASEMANAGER_H
