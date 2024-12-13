#include "listmodel.h"
#include "database.h"
#include <QSqlQueryModel>

listmodel::listmodel(QObject *parent): QSqlQueryModel(parent) {
    this->updateModel();
}

QVariant listmodel::data(const QModelIndex & index, int role) const {
    int columnId = role - Qt::UserRole - 1;
    QModelIndex modelIndex = this->index(index.row(), columnId);
    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

QHash<int, QByteArray> listmodel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[FNameRole] = "FirstName";
    roles[SNameRole] = "SurName";
    roles[MNameRole] = "MidleName";
    roles[HeightRole] = "Height";
    roles[WeightRole] = "Weight";
    return roles;
}

void listmodel::updateModel()
{
    this->setQuery("SELECT id, " TABLE_FNAME ", " TABLE_SNAME ", " TABLE_MNAME ", " TABLE_HEIGHT ", " TABLE_WEIGHT " FROM " TABLE);
}

int listmodel::getId(int row){
    return this->data(this->index(row, 0), IdRole).toInt();
}
