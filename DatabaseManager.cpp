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
QJsonArray DatabaseManager::fetchWarehouseItems()
{
    QJsonArray warehouseArray;
    QSqlQuery query(
        "SELECT w.id, w.good_id, g.name as good_name, w.good_count "
        "FROM warehouse1 w "
        "JOIN goods g ON w.good_id = g.id "
        "ORDER BY w.id");

    while (query.next())
    {
        QJsonObject warehouseItem;
        warehouseItem["id"] = query.value("id").toInt();
        warehouseItem["good_id"] = query.value("good_id").toInt();
        warehouseItem["good_name"] = query.value("good_name").toString();
        warehouseItem["good_count"] = query.value("good_count").toInt();
        warehouseArray.append(warehouseItem);
    }
    return warehouseArray;
}

QJsonArray DatabaseManager::fetchAvailableGoods()
{
    QJsonArray availableGoodsArray;
    QSqlQuery query(
        "SELECT id, name FROM goods "
        "WHERE id NOT IN (SELECT DISTINCT good_id FROM warehouse1) "
        "ORDER BY name");

    while (query.next())
    {
        QJsonObject good;
        good["id"] = query.value("id").toInt();
        good["name"] = query.value("name").toString();
        availableGoodsArray.append(good);
    }
    return availableGoodsArray;
}

bool DatabaseManager::addWarehouseItem(int goodId, int goodCount)
{
    // Validate input
    if (goodId <= 0 || goodCount < 0)
    {
        return false;
    }

    // Check if good exists
    QSqlQuery checkGood;
    checkGood.prepare("SELECT id FROM goods WHERE id = :goodId");
    checkGood.bindValue(":goodId", goodId);

    if (!checkGood.exec() || !checkGood.next())
    {
        return false; // Good does not exist
    }

    // Check if good is already in warehouse
    QSqlQuery checkWarehouse;
    checkWarehouse.prepare("SELECT id FROM warehouse1 WHERE good_id = :goodId");
    checkWarehouse.bindValue(":goodId", goodId);

    if (checkWarehouse.exec() && checkWarehouse.next())
    {
        return false; // Good already in warehouse
    }

    QString queryStr =
        QString("INSERT INTO public.warehouse1 (good_id, good_count) VALUES (%1, %2)")
            .arg(goodId)
            .arg(goodCount);

    if (executeQuery(queryStr))
    {
        return true;
    }
    return false;
}

bool DatabaseManager::updateWarehouseItem(int id, const QVariantMap& newFields)
{
    if (newFields.isEmpty())
    {
        return false;
    }

    QStringList updateClauses;
    for (const QString& key : newFields.keys())
    {
        updateClauses.append(QString("%1 = %2").arg(key).arg(newFields.value(key).toInt()));
    }

    QString queryStr =
        QString("UPDATE warehouse1 SET %1 WHERE id = %2").arg(updateClauses.join(", ")).arg(id);

    if (executeQuery(queryStr))
    {
        return true;
    }
    return false;
}

bool DatabaseManager::deleteWarehouseItem(int id)
{
    QString queryStr = QString("DELETE FROM warehouse1 WHERE id = %1").arg(id);
    if (executeQuery(queryStr))
    {
        return true;
    }
    return false;
}
QJsonArray DatabaseManager::fetchGoods()
{
    QJsonArray goodsArray;
    QSqlQuery query("SELECT id, name, priority FROM public.goods ORDER BY id");
    while (query.next())
    {
        QJsonObject good;
        good["id"] = query.value("id").toInt();
        good["name"] = query.value("name").toString();
        good["priority"] =
            query.value("priority").isNull() ? QJsonValue::Null : query.value("priority").toInt();
        goodsArray.append(good);
    }
    return goodsArray;
}

bool DatabaseManager::addGood(const QString& name, int priority)
{
    // Validate input
    if (name.trimmed().isEmpty())
    {
        return false;
    }

    QString queryStr;
    if (priority != -1)
    {
        queryStr =
            QString("INSERT INTO public.goods (name, priority) VALUES ('%1', %2)").arg(name).arg(priority);
    }
    else
    {
        queryStr = QString("INSERT INTO public.goods (name) VALUES ('%1')").arg(name);
    }

    if (executeQuery(queryStr))
    {
        return true;
    }
    return false;
}

bool DatabaseManager::updateGood(int id, const QVariantMap& newFields)
{
    if (newFields.isEmpty())
    {
        return false;
    }

    QStringList updateClauses;
    for (const QString& key : newFields.keys())
    {
        QVariant value = newFields.value(key);
        if (value.isNull())
        {
            updateClauses.append(QString("%1 = NULL").arg(key));
        }
        else
        {
            updateClauses.append(QString("%1 = '%2'").arg(key).arg(value.toString()));
        }
    }

    QString queryStr =
        QString("UPDATE goods SET %1 WHERE id = '%2'").arg(updateClauses.join(", ")).arg(id);

    if (executeQuery(queryStr))
    {
        return true;
    }
    return false;
}

bool DatabaseManager::deleteGood(int id)
{
    // Check for references in sales and warehouse before deletion
    QSqlQuery checkSales, checkWarehouse;

    checkSales.prepare("SELECT COUNT(*) FROM sales WHERE good_id = :goodId");
    checkSales.bindValue(":goodId", id);

    checkWarehouse.prepare("SELECT COUNT(*) FROM warehouse1 WHERE good_id = :goodId");
    checkWarehouse.bindValue(":goodId", id);

    if (checkSales.exec() && checkSales.next() && checkSales.value(0).toInt() > 0)
    {
        return false; // Good is referenced in sales
    }

    if (checkWarehouse.exec() && checkWarehouse.next() && checkWarehouse.value(0).toInt() > 0)
    {
        return false; // Good is in warehouse
    }

    QString queryStr = QString("DELETE FROM goods WHERE id = '%1'").arg(id);
    if (executeQuery(queryStr))
    {
        return true;
    }
    return false;
}

QJsonArray DatabaseManager::fetchWarehouse2Items()
{
    QJsonArray warehouseArray;
    QSqlQuery query("SELECT id, good_id, good_count FROM public.warehouse2");

    while (query.next())
    {
        QJsonObject warehouseItem;
        warehouseItem["id"] = query.value("id").toInt();
        warehouseItem["good_id"] = query.value("good_id").toInt();
        warehouseItem["good_count"] = query.value("good_count").toInt();
        warehouseArray.append(warehouseItem);
    }
    return warehouseArray;
}

bool DatabaseManager::addWarehouse2Item(int goodId, int goodCount)
{
    QString queryStr = QString(
                           "INSERT INTO public.warehouse2 (good_id, good_count) "
                           "VALUES (%1, %2)")
                           .arg(goodId)
                           .arg(goodCount);

    if (executeQuery(queryStr))
    {
        return true;
    }
    return false;
}

bool DatabaseManager::updateWarehouse2Item(int id, const QVariantMap& newFields)
{
    if (newFields.isEmpty())
    {
        return false;
    }

    QStringList updateClauses;
    for (const QString& key : newFields.keys())
    {
        QString value = newFields.value(key).toString();
        updateClauses.append(QString("%1 = %2").arg(key).arg(value));
    }

    QString queryStr =
        QString("UPDATE warehouse2 SET %1 WHERE id = %2").arg(updateClauses.join(", ")).arg(id);

    if (executeQuery(queryStr))
    {
        return true;
    }
    return false;
}

bool DatabaseManager::deleteWarehouse2Item(int id)
{
    QString queryStr = QString("DELETE FROM warehouse2 WHERE id = %1").arg(id);

    if (executeQuery(queryStr))
    {
        return true;
    }
    return false;
}

QJsonArray DatabaseManager::getTableMetadata(const QString& tableName)
{
    QJsonArray metadataArray;

    // Ensure database connection is open
    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen())
    {
        qDebug() << "Database is not open!";
        return metadataArray;
    }

    // Query to retrieve column metadata
    QSqlQuery query;
    query.prepare(R"(
        SELECT 
            column_name,
            data_type,
            is_nullable,
            column_default,
            (SELECT COUNT(*) FROM 
                information_schema.table_constraints tc
                JOIN information_schema.constraint_column_usage AS ccu 
                ON tc.constraint_name = ccu.constraint_name
            WHERE 
                tc.table_name = :tableName
                AND tc.constraint_type = 'PRIMARY KEY' 
                AND ccu.column_name = column_name
            ) > 0 AS is_primary_key
        FROM 
            information_schema.columns
        WHERE 
            table_name = :tableName
        ORDER BY 
            ordinal_position
    )");

    query.bindValue(":tableName", tableName);

    if (!query.exec())
    {
        qDebug() << "Error retrieving table metadata:" << query.lastError().text();
        return metadataArray;
    }

    // Process results
    while (query.next())
    {
        QJsonObject columnMetadata;
        columnMetadata["name"] = query.value(0).toString();
        columnMetadata["dataType"] = query.value(1).toString();
        columnMetadata["isNullable"] = (query.value(2).toString() == "YES");

        // Handle default value
        QVariant defaultVal = query.value(3);
        columnMetadata["defaultValue"] = defaultVal.isNull() ? "" : defaultVal.toString();

        columnMetadata["isPrimaryKey"] = query.value(4).toBool();

        metadataArray.append(columnMetadata);
    }

    return metadataArray;
}

QJsonArray DatabaseManager::fetchSales()
{
    QJsonArray salesArray;
    QSqlQuery query("SELECT id, good_id, good_count, create_date FROM public.sales");
    while (query.next())
    {
        QJsonObject sale;
        sale["id"] = query.value("id").toInt();
        sale["good_id"] = query.value("good_id").toInt();
        sale["good_count"] = query.value("good_count").toInt();
        sale["create_date"] = query.value("create_date").toString().split("T")[0];
        salesArray.append(sale);
    }
    return salesArray;
}

bool DatabaseManager::addSale(int goodId, int goodCount, const QString& createDate)
{
    QString queryStr =
        QString("INSERT INTO public.sales (good_id, good_count, create_date) VALUES (%1, %2, '%3')")
            .arg(goodId)
            .arg(goodCount)
            .arg(QDateTime::fromString(createDate, "dd.MM.yyyy").toString(Qt::ISODate));

    if (executeQuery(queryStr))
    {
        return true;
    }
    return false;
}

bool DatabaseManager::updateSale(int id, const QVariantMap& newFields)
{
    if (newFields.isEmpty())
    {
        return false;
    }

    QStringList updateClauses;
    for (const QString& key : newFields.keys())
    {
        QString value = newFields.value(key).toString();
        if (key == "create_date")
        {
            value = QDateTime::fromString(value, "dd.MM.yyyy").toString(Qt::ISODate);
        }
        updateClauses.append(QString("%1 = '%2'").arg(key).arg(value));
    }

    QString queryStr =
        QString("UPDATE sales SET %1 WHERE id = '%2'").arg(updateClauses.join(", ")).arg(id);

    if (executeQuery(queryStr))
    {
        return true;
    }
    return false;
}

bool DatabaseManager::deleteSale(int id)
{
    QString queryStr = QString("DELETE FROM sales WHERE id = '%1'").arg(id);
    if (executeQuery(queryStr))
    {
        return true;
    }
    return false;
}
void DatabaseManager::generateReportPDF(const QString& tableName)
{
    QSqlQuery query(db_);
    if (!query.exec(QString("SELECT * FROM %1").arg(tableName)))
    {
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
