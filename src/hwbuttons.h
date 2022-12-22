#ifndef HWBUTTONS_H
#define HWBUTTONS_H

#include <QObject>
#include <QKeyEvent>
#include <QDebug>

class HWButtons : public QObject
{
    Q_OBJECT
public:
    explicit HWButtons(QObject *parent = nullptr);
    bool eventFilter(QObject *, QEvent *ev);
private:
    bool volUpDown;
    bool volUpUsed;
};

#endif // HWBUTTONS_H
