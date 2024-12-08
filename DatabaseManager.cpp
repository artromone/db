#include <QDebug>
#include <QFile>
#include <QJsonObject>
#include <QPainter>
#include <QPdfWriter>
#include <QPrinter>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QTextDocument>
#include <QTextStream>
#include <QTextTableCell>
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
    QSqlQuery query;
    query.prepare("INSERT INTO public.departments DEFAULT VALUES RETURNING id");

    if (query.exec() && query.next())
    {
        int newId = query.value(0).toInt();
        qDebug() << "New department added with ID:" << newId;
        emit departmentAdded();
        return true;
    }
    else
    {
        qWarning() << "Failed to add department:" << query.lastError().text();
        return false;
    }
}

Q_INVOKABLE bool DatabaseManager::addDepartmentEmployee(int departmentId, int employeeId)
{
    QString queryStr = QString(
                           "INSERT INTO public.department_employees (department_id, employee_id) "
                           "VALUES (%1, %2)")
                           .arg(departmentId)
                           .arg(employeeId);

    if (executeQuery(queryStr))
    {
        emit departmentEmployeeAdded();
        return true;
    }
    return false;
}

Q_INVOKABLE bool DatabaseManager::updateDepartmentEmployee(int id, const QVariantMap& newFields)
{
    if (newFields.isEmpty())
        return false;

    QStringList updateClauses;
    for (const QString& key : newFields.keys())
    {
        updateClauses.append(QString("%1 = %2").arg(key).arg(newFields.value(key).toInt()));
    }

    QString queryStr = QString("UPDATE public.department_employees SET %1 WHERE id = %2")
                           .arg(updateClauses.join(", "))
                           .arg(id);

    if (executeQuery(queryStr))
    {
        emit departmentEmployeeUpdated();
        return true;
    }
    return false;
}

Q_INVOKABLE bool DatabaseManager::deleteDepartmentEmployee(int departmentEmployeeId)
{
    QString queryStr =
        QString("DELETE FROM public.department_employees WHERE id = %1").arg(departmentEmployeeId);

    if (executeQuery(queryStr))
    {
        emit departmentEmployeeDeleted();
        return true;
    }
    return false;
}

Q_INVOKABLE QJsonArray DatabaseManager::fetchDepartmentEmployees()
{
    QJsonArray departmentEmployees;
    QSqlQuery query("SELECT id, department_id, employee_id FROM public.department_employees");

    while (query.next())
    {
        QJsonObject departmentEmployee;
        departmentEmployee["id"] = query.value(0).toInt();
        departmentEmployee["department_id"] = query.value(1).toInt();
        departmentEmployee["employee_id"] = query.value(2).toInt();
        departmentEmployees.append(departmentEmployee);
    }
    return departmentEmployees;
}

bool DatabaseManager::deleteDepartment(int departmentId)
{
    qDebug() << departmentId;
    QString queryStr = QString("DELETE FROM public.departments WHERE id = %1").arg(departmentId);
    if (executeQuery(queryStr))
    {
        emit departmentDeleted();
        return true;
    }
    return false;
}

QJsonArray DatabaseManager::fetchDepartments()
{
    QJsonArray departments;
    QSqlQuery query("SELECT id FROM public.departments");
    while (query.next())
    {
        QJsonObject department;
        department["id"] = query.value(0).toInt();
        departments.append(department);
    }
    return departments;
}

bool DatabaseManager::addEmployee(const QString& firstName,
                                  const QString& lastName,
                                  const QString& fatherName,
                                  const QString& position,
                                  int salary)
{
    QString queryStr =
        QString(
            "INSERT INTO public.emplyees (first_name, last_name, fther_name, position, salary) "
            "VALUES ('%1', '%2', '%3', '%4', %5)")
            .arg(firstName)
            .arg(lastName)
            .arg(fatherName)
            .arg(position)
            .arg(salary);
    if (executeQuery(queryStr))
    {
        emit employeeAdded();
        return true;
    }
    return false;
}

// bool DatabaseManager::assignEmployeeToDepartment(int employeeId, int departmentId)
// {
//     QSqlQuery query;
//     query.prepare(
//         "INSERT INTO public.department_employees (employee_id, department_id) "
//         "VALUES (:employee_id, :department_id)");
//     query.bindValue(":employee_id", employeeId);
//     query.bindValue(":department_id", departmentId);
//
//     if (!query.exec())
//     {
//         qWarning() << "Failed to assign employee to department:" << query.lastError().text();
//         return false;
//     }
//     return true;
// }

bool DatabaseManager::updateEmployee(int id, const QVariantMap& newFields)
{
    if (newFields.isEmpty())
        return false;

    QStringList updateClauses;
    for (const QString& key : newFields.keys())
    {
        updateClauses.append(QString("%1 = '%2'").arg(key).arg(newFields.value(key).toString()));
    }

    QString queryStr =
        QString("UPDATE public.emplyees SET %1 WHERE id = '%2'").arg(updateClauses.join(", ")).arg(id);

    if (executeQuery(queryStr))
    {
        emit employeeUpdated();
        return true;
    }
    return false;
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

QJsonArray DatabaseManager::fetchProjects()
{
    QJsonArray projectsArray;

    QSqlQuery query(
        "SELECT id, name, cost, department_id, beg_date, end_date, end_real_date FROM "
        "public.projects");
    while (query.next())
    {
        QJsonObject project;
        project["id"] = query.value("id").toInt();
        project["name"] = query.value("name").toString();
        project["cost"] = query.value("cost").toDouble();
        project["department_id"] = query.value("department_id").toInt();
        project["beg_date"] = query.value("beg_date").toString();
        project["end_date"] = query.value("end_date").toString();
        project["end_real_date"] = query.value("end_real_date").toString();
        projectsArray.append(project);
    }

    return projectsArray;
}

QJsonArray DatabaseManager::fetchEmployees()
{
    QJsonArray employees;
    QSqlQuery query(
        "SELECT id, first_name, last_name, fther_name, position, salary FROM public.emplyees");
    while (query.next())
    {
        QJsonObject employee;
        employee["id"] = query.value(0).toInt();
        employee["first_name"] = query.value(1).toString();
        employee["last_name"] = query.value(2).toString();
        employee["fther_name"] = query.value(3).toString();
        employee["position"] = query.value(4).toString();
        employee["salary"] = query.value(5).toDouble();
        employees.append(employee);
    }
    return employees;
}

bool DatabaseManager::addProject(const QString& name,
                                 int cost,
                                 int departmentId,
                                 const QString& begDate,
                                 const QString& endDate,
                                 const QString& endRealDate)
{
    QString queryStr =
        QString(
            "INSERT INTO public.projects (name, cost, department_id, beg_date, "
            "end_date, end_real_date) VALUES ('%1', %2, %3, '%4', '%5', '%6')")
            .arg(name)
            .arg(cost)
            .arg(departmentId)
            .arg(QDateTime::fromString(begDate, "dd.MM.yyyy HH:mm:ss").toString(Qt::ISODate))
            .arg(QDateTime::fromString(endDate, "dd.MM.yyyy HH:mm:ss").toString(Qt::ISODate))
            .arg(QDateTime::fromString(endRealDate, "dd.MM.yyyy HH:mm:ss").toString(Qt::ISODate));
    if (executeQuery(queryStr))
    {
        emit projectAdded();
        return true;
    }
    return false;
}

bool DatabaseManager::deleteProject(int id)
{
    QString queryStr = QString("DELETE FROM projects WHERE id = '%1'").arg(id);

    if (executeQuery(queryStr))
    {
        emit projectDeleted();
        return true;
    }
    return false;
}

bool DatabaseManager::updateProject(int id, const QVariantMap& newFields)
{
    if (newFields.isEmpty())
        return false;

    QStringList updateClauses;
    for (const QString& key : newFields.keys())
    {
        updateClauses.append(QString("%1 = '%2'").arg(key).arg(newFields.value(key).toString()));
    }

    QString queryStr =
        QString("UPDATE projects SET %1 WHERE id = '%2'").arg(updateClauses.join(", ")).arg(id);

    if (executeQuery(queryStr))
    {
        emit projectUpdated();
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

void DatabaseManager::generateReportPDF(const QString& tableName)
{
    QSqlQuery query(db_);
    if (!query.exec(QString("SELECT * FROM %1").arg(tableName))) {
        qWarning() << "Failed to execute query:" << query.lastError().text();
        return;
    }

    // Создание HTML-контента для PDF
    QString htmlContent = "<html><body>";
    htmlContent += "<h1>Отчет по таблице: " + tableName + "</h1>";
    htmlContent += "<table border='1' cellspacing='0' cellpadding='5'>";

    // Добавление заголовков
    htmlContent += "<tr>";
    QSqlRecord record = query.record();
    for (int i = 0; i < record.count(); ++i)
    {
        htmlContent += "<th>" + record.fieldName(i) + "</th>";
    }
    htmlContent += "</tr>";

    // Добавление данных
    while (query.next())
    {
        htmlContent += "<tr>";
        for (int i = 0; i < record.count(); ++i)
        {
            htmlContent += "<td>" + query.value(i).toString() + "</td>";
        }
        htmlContent += "</tr>";
    }

    htmlContent += "</table></body></html>";

    // Создание PDF
    QPrinter printer(QPrinter::PrinterResolution);
    printer.setOutputFormat(QPrinter::PdfFormat);
    printer.setPaperSize(QPrinter::A4);
    printer.setOutputFileName(tableName + ".pdf");

    QTextDocument textDocument;
    textDocument.setHtml(htmlContent);
    textDocument.print(&printer);
}

void DatabaseManager::generateReportTXT(const QString& tableName)
{
    QFile file(tableName + ".txt");
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        qWarning() << "Failed to open file for writing:" << file.errorString();
        return;
    }

    QTextStream out(&file);

    out << tableName + " Report\n\n";

    QSqlQuery query("SELECT * FROM " + tableName);
    int colCount = query.record().count();

    for (int i = 0; i < colCount; ++i)
    {
        out << query.record().fieldName(i) << "\t";
    }
    out << "\n";

    while (query.next())
    {
        for (int i = 0; i < colCount; ++i)
        {
            out << query.value(i).toString() << "\t";
        }
        out << "\n";
    }

    file.close();
}
