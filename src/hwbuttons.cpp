#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QStandardPaths>
#include <QDir>

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

           if (keyEvent->key() == Qt::Key_VolumeUp)
           {
               ((QQmlApplicationEngine *)parent())->rootObjects()[0]->property("window").value<QQuickWindow *>()->grabWindow().save(
                    QDir(QStandardPaths::writableLocation(QStandardPaths::PicturesLocation)).filePath("screenshot.jpg")
               );
               return true;
           }
    }
    return false;
}
