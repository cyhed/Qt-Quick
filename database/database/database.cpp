#include "database.h"
#include <QSqlDatabase>

database::~database() {
    closeDataBase();
}
database::database(QObject *parent) : QObject(parent) {

}
//main
void database:: connectToDataBase(){

    if(!QFile(DATABASE_NAME).exists()){
        restoreDataBase();
    }else{
        openDataBase();
    }

}

bool database:: restoreDataBase(){

    if(openDataBase()){
        qDebug() << "RESTORED";
        return createTable();
    }else{
        qDebug() << "Can't restore database!";
        return false;
    }
    return false;
}

bool database:: openDataBase(){

    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setHostName(DATABASE_HOSTNAME);
    db.setDatabaseName(DATABASE_NAME);
    if(db.open()){
        qDebug() << "db connected";
        return true;
    }else{
        return false;
    }
}

void database:: closeDataBase(){
    db.close();
}

bool database::createTable() {
    QSqlQuery query;

    if (!query.exec("CREATE TABLE " TABLE " ("
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                    TABLE_FNAME " VARCHAR(255) NOT NULL, "
                    TABLE_SNAME " VARCHAR(255) NOT NULL, "
                    TABLE_MNAME " VARCHAR(255) NOT NULL, "
                    TABLE_HEIGHT " VARCHAR(255) NOT NULL, "
                    TABLE_WEIGHT " VARCHAR(255) NOT NULL"
                    " );"
                    )) {
        qDebug() << "Database: error creating table " << TABLE;
        qDebug() << query.lastError().text();
        return false;
    } else {
        qDebug() << "Database: table created successfully";
        return true;
    }
}


bool database:: insertIntoTable(const QVariantList &data){
    QSqlQuery query;
    query.prepare("INSERT INTO " TABLE "(" TABLE_FNAME ", " TABLE_SNAME ", " TABLE_MNAME", " TABLE_HEIGHT ", " TABLE_WEIGHT ") "
                  "VALUES (:FirstName, :SurName, :MidleName, :Height, :Weight);");

    query.bindValue(":FirstName", data[0].toString());
    query.bindValue(":SurName", data[1].toString());
    query.bindValue(":MidleName", data[2].toString());
    query.bindValue(":Height", data[3].toString());
    query.bindValue(":Weight", data[4].toString());

    if(!query.exec()){
        qDebug() << "error insert into" << TABLE;
        qDebug() << query.lastError().text();
        return false;
    }else{
        return true;
    }
    return false;
}

//main
bool database::insertIntoTable(const QString &fname, const QString &sname, const QString &mname, const QString &height, const QString &weight){
    QVariantList data;
    data.append(fname);
    data.append(sname);
    data.append(mname);
    data.append(height);
    data.append(weight);

    qDebug() << fname;
    qDebug() << sname;
    qDebug() << mname;
    qDebug() << height;
    qDebug() << weight;
    if(insertIntoTable(data)){
        return true;
    }else{
        return false;
    }
}

bool database::removeRecord(const int id){
    QSqlQuery query;
    query.prepare("DELETE FROM " TABLE " WHERE id= :ID ;");
    query.bindValue(":ID", id);

    if(!query.exec()){
        qDebug() << "error delete row" << TABLE;
        qDebug() << query.lastError().text();
        return false;
    }else{
        return true;
    }
    return false;
}
