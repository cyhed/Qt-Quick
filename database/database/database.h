#ifndef DATABASE_H
#define DATABASE_H

#define DATABASE_HOSTNAME "Contacts3"
#define DATABASE_NAME "Contacts3.db"
#define TABLE "Man3"
#define TABLE_FNAME "FirstName"
#define TABLE_SNAME "SurName"
#define TABLE_MNAME "MidleName"
#define TABLE_POSTINDEX "PostIndex"



#include <QObject>
#include <QSql>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlDatabase>
#include <QFile>
#include <QDate>
#include <QDebug>


class database : public QObject
{
    Q_OBJECT
public:
    explicit database(QObject *parent = 0);
    ~database();
    void connectToDataBase();

private:
    QSqlDatabase db;

private:
    bool openDataBase();
    bool restoreDataBase();
    void closeDataBase();
    bool createTable();

public slots:
    bool insertIntoTable(const QVariantList &data);
    bool insertIntoTable(const QString &fname, const QString &sname, const QString &mname, const QString &postIndex);
    bool removeRecord(const int id);
};

#endif // DATABASE_H
