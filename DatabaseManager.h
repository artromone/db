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
    Q_INVOKABLE QJsonArray fetchDepartments();

    // Operations with employees
    Q_INVOKABLE bool addEmployee(const QString& firstName,
                                 const QString& lastName,
                                 const QString& fatherName,
                                 const QString& position,
                                 int salary);
    Q_INVOKABLE bool updateEmployee(int id, const QVariantMap& newFields);
    Q_INVOKABLE bool deleteEmployee(int employeeId);
    Q_INVOKABLE QJsonArray fetchEmployees();

    Q_INVOKABLE QList<QVariantMap> fetchEmployeesWithDepartments();

    // Operations with projects
    Q_INVOKABLE bool addProject(const QString& name,
                                int cost,
                                int departmentId,
                                const QString& begDate,
                                const QString& endDate,
                                const QString& endRealDate);
    Q_INVOKABLE bool updateProject(int id, const QVariantMap& newFields);
    Q_INVOKABLE bool deleteProject(int id);
    Q_INVOKABLE QJsonArray fetchProjects();

    Q_INVOKABLE QVariantMap getTableMetadata(const QString& tableName);

signals:
    void departmentAdded();
    void departmentUpdated();
    void departmentDeleted();

    void employeeAdded();
    void employeeDeleted();
    void employeeUpdated();

    void projectAdded();
    void projectUpdated();
    void projectDeleted();

private:
    QSqlDatabase db_;
};

#endif // DATABASEMANAGER_H
