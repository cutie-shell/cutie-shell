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
    void sleepDisplay(bool sleep);
    bool volUpDown;
    bool volUpUsed;
    bool m_displayOff = false;
};

#endif // HWBUTTONS_H
