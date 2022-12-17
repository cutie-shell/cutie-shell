#include <QQmlApplicationEngine>

#include "hwbuttons.h"

HWButtons::HWButtons(QObject *parent) : QObject(parent)
{

}

bool HWButtons::eventFilter(QObject *, QEvent *ev)
{
      if (ev->type() == QEvent::KeyPress)
      {
           QKeyEvent* keyEvent = (QKeyEvent*)ev;

           if (keyEvent->key() == Qt::Key_PowerOff)
           {
               QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "lock");
               return true;
           }
    }
    return false;
}
