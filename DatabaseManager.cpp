#include <QDebug>
#include <QtSql/QSqlError>

#include "DatabaseManager.h"

DatabaseManager::DatabaseManager(const QString& dbName)
{
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbName);
    if (!db.open())
    {
        qFatal("Failed to open database: %s", qPrintable(db.lastError().text()));
    }
}

DatabaseManager::~DatabaseManager()
{
    if (db.isOpen())
    {
        db.close();
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
