#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>

#include "DatabaseInstance.h"
#include "DatabaseManager.h"

DatabaseManager::DatabaseManager()
{
    db_ = DatabaseInstance::getInstance();
}

DatabaseManager::~DatabaseManager()
{
    if (db_.isOpen())
    {
        db_.close();
    }
}

bool DatabaseManager::executeQuery(const QString& queryStr)
{
    QSqlQuery query;
    if (!query.exec(queryStr))
    {
        qWarning() << "Query failed:" << query.lastError().text();
        return false;
    }
    return true;
}

bool DatabaseManager::addDepartment()
{
    QString queryStr = "INSERT INTO public.departments DEFAULT VALUES";
    if (executeQuery(queryStr))
    {
        emit departmentAdded();
        return true;
    }
    return false;
}

bool DatabaseManager::deleteDepartment(int departmentId)
{
    QString queryStr = QString("DELETE FROM public.departments WHERE id = %1").arg(departmentId);
    if (executeQuery(queryStr))
    {
        emit departmentDeleted();
        return true;
    }
    return false;
}

QList<QVariantMap> DatabaseManager::fetchDepartments()
{
    QList<QVariantMap> departments;
    QSqlQuery query("SELECT id FROM public.departments");
    while (query.next())
    {
        QVariantMap department;
        department["id"] = query.value(0);
        departments.append(department);
    }
    return departments;
}

bool DatabaseManager::addEmployee(const QString& firstName,
                                  const QString& lastName,
                                  const QString& position,
                                  int salary)
{
    QString queryStr = QString(
                           "INSERT INTO public.emplyees (first_name, last_name, position, salary) "
                           "VALUES ('%1', '%2', '%3', %4)")
                           .arg(firstName)
                           .arg(lastName)
                           .arg(position)
                           .arg(salary);
    if (executeQuery(queryStr))
    {
        emit employeeAdded();
        return true;
    }
    return false;
}

bool DatabaseManager::assignEmployeeToDepartment(int employeeId, int departmentId)
{
    QSqlQuery query;
    query.prepare(
        "INSERT INTO public.department_employees (employee_id, department_id) "
        "VALUES (:employee_id, :department_id)");
    query.bindValue(":employee_id", employeeId);
    query.bindValue(":department_id", departmentId);

    if (!query.exec())
    {
        qWarning() << "Failed to assign employee to department:" << query.lastError().text();
        return false;
    }
    return true;
}

bool DatabaseManager::deleteEmployee(int employeeId)
{
    QString queryStr = QString("DELETE FROM public.emplyees WHERE id = %1").arg(employeeId);
    if (executeQuery(queryStr))
    {
        emit employeeDeleted();
        return true;
    }
    return false;
}


QList<QVariantMap> DatabaseManager::fetchEmployeesWithDepartments()
{
    QList<QVariantMap> employees;
    QSqlQuery query(
        "SELECT e.id, e.first_name, e.last_name, e.position, e.salary, d.name AS department_name "
        "FROM public.emplyees e "
        "LEFT JOIN public.departments d ON e.department_id = d.id");

    while (query.next())
    {
        QVariantMap employee;
        employee["id"] = query.value(0);
        employee["first_name"] = query.value(1);
        employee["last_name"] = query.value(2);
        employee["position"] = query.value(3);
        employee["salary"] = query.value(4);
        employee["department_name"] = query.value(5);
        employees.append(employee);
    }
    return employees;
}

QList<QVariantMap> DatabaseManager::fetchEmployees()
{
    QList<QVariantMap> employees;
    QSqlQuery query("SELECT id, first_name, last_name, position, salary FROM public.emplyees");
    while (query.next())
    {
        QVariantMap employee;
        employee["id"] = query.value(0);
        employee["first_name"] = query.value(1);
        employee["last_name"] = query.value(2);
        employee["position"] = query.value(3);
        employee["salary"] = query.value(4);
        employees.append(employee);
    }
    return employees;
}

bool DatabaseManager::addProject(const QString& name,
                                 int cost,
                                 int departmentId,
                                 const QDateTime& begDate,
                                 const QDateTime& endDate)
{
    QString queryStr = QString(
                           "INSERT INTO public.projects (name, cost, department_id, beg_date, "
                           "end_date) VALUES ('%1', %2, %3, '%4', '%5')")
                           .arg(name)
                           .arg(cost)
                           .arg(departmentId)
                           .arg(begDate.toString(Qt::ISODate))
                           .arg(endDate.toString(Qt::ISODate));
    if (executeQuery(queryStr))
    {
        emit projectAdded();
        return true;
    }
    return false;
}

bool DatabaseManager::deleteProject(int projectId)
{
    QString queryStr = QString("DELETE FROM public.projects WHERE id = %1").arg(projectId);
    if (executeQuery(queryStr))
    {
        emit projectDeleted();
        return true;
    }
    return false;
}


QVariantMap DatabaseManager::getTableMetadata(const QString& tableName)
{
    QVariantMap metadata;

    QSqlQuery query;
    query.prepare("PRAGMA table_info(" + tableName + ")");
    if (query.exec())
    {
        QVariantList columns;
        while (query.next())
        {
            QVariantMap column;
            column["name"] = query.value(1);
            column["type"] = query.value(2);
            column["notnull"] = query.value(3);
            column["default_value"] = query.value(4);
            column["primary_key"] = query.value(5);
            columns.append(column);
        }
        metadata["columns"] = columns;
    }

    query.prepare("PRAGMA foreign_key_list(" + tableName + ")");
    if (query.exec())
    {
        QVariantList foreignKeys;
        while (query.next())
        {
            QVariantMap foreignKey;
            foreignKey["from"] = query.value(3);
            foreignKey["to"] = query.value(4);
            foreignKeys.append(foreignKey);
        }
        metadata["foreign_keys"] = foreignKeys;
    }

    return metadata;
}
