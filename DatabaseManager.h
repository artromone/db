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

    // Operations with warehouse
    Q_INVOKABLE QJsonArray fetchWarehouseItems();
    Q_INVOKABLE bool addWarehouseItem(int goodId, int goodCount);
    Q_INVOKABLE bool updateWarehouseItem(int id, const QVariantMap& newFields);
    Q_INVOKABLE bool deleteWarehouseItem(int id);
    Q_INVOKABLE QJsonArray fetchAvailableGoods();

    // Operations with warehouse2
    Q_INVOKABLE QJsonArray fetchWarehouse2Items();
    Q_INVOKABLE bool addWarehouse2Item(int goodId, int goodCount);
    Q_INVOKABLE bool updateWarehouse2Item(int id, const QVariantMap& newFields);
    Q_INVOKABLE bool deleteWarehouse2Item(int id);

    // Operations with goods
    Q_INVOKABLE QJsonArray fetchGoods();
    Q_INVOKABLE bool addGood(const QString& name, int priority);
    Q_INVOKABLE bool updateGood(int id, const QVariantMap& newFields);
    Q_INVOKABLE bool deleteGood(int id);

    // Operations with sales
    Q_INVOKABLE QJsonArray fetchSales();
    Q_INVOKABLE bool addSale(int goodId, int goodCount, const QString& createDate);
    Q_INVOKABLE bool updateSale(int id, const QVariantMap& newFields);
    Q_INVOKABLE bool deleteSale(int id);

    Q_INVOKABLE QJsonArray getTableMetadata(const QString& tableName);

    Q_INVOKABLE void generateReportPDF(const QString& tableName);
    Q_INVOKABLE void generateReportTXT(const QString& tableName);

private:
    QSqlDatabase db_;
};

#endif // DATABASEMANAGER_H
