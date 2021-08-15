#ifndef ATMOSPHERE_H
#define ATMOSPHERE_H

#include <QDebug>
#include <iostream>

class Atmosphere: public QObject
{
    Q_OBJECT
private:
    QString path;
    QString variant;
public:
    Atmosphere();
public Q_SLOTS:
    QString GetPath();
    QString GetVariant();
    void SetPath(QString path);
    void SetVariant(QString variant);
Q_SIGNALS:
    void PathChanged();
    void VariantChanged();
};

#endif // ATMOSPHERE_H