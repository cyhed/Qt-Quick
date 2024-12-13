#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QObject>
#include <QSqlQueryModel>

class listmodel : public QSqlQueryModel
{
    Q_OBJECT
public:
    explicit listmodel(QObject *parent = 0);

    enum Roles {
        IdRole = Qt::UserRole + 1,
        FNameRole,
        SNameRole,
        MNameRole,
        HeightRole,
        WeightRole
    };

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

protected:
    QHash<int, QByteArray> roleNames() const;

public slots:
    void updateModel();
    int getId(int row);
};

#endif // LISTMODEL_H
