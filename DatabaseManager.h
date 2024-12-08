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

    struct ColumnMetadata
    {
        QString name;
        QString dataType;
        bool isPrimaryKey;
        bool isNullable;
        QString defaultValue;
    };

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

    // Operations with D/E
    Q_INVOKABLE bool addDepartmentEmployee(int departmentId, int employeeId);
    Q_INVOKABLE bool updateDepartmentEmployee(int id, const QVariantMap& newFields);
    Q_INVOKABLE bool deleteDepartmentEmployee(int departmentEmployeeId);
    Q_INVOKABLE QJsonArray fetchDepartmentEmployees();

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
    Q_INVOKABLE double calculateProjectProfit(int projectId);

    Q_INVOKABLE QJsonArray getTableMetadata(const QString& tableName);

    Q_INVOKABLE void generateReportPDF(const QString& tableName);
    Q_INVOKABLE void generateReportTXT(const QString& tableName);

signals:
    void departmentAdded();
    void departmentUpdated();
    void departmentDeleted();

    void employeeAdded();
    void employeeDeleted();
    void employeeUpdated();

    void departmentEmployeeAdded();
    void departmentEmployeeUpdated();
    void departmentEmployeeDeleted();

    void projectAdded();
    void projectUpdated();
    void projectDeleted();

private:
    QSqlDatabase db_;
};

#endif // DATABASEMANAGER_H
