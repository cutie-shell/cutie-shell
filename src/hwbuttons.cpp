#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QStandardPaths>
#include <QDir>

#include "hwbuttons.h"

HWButtons::HWButtons(QObject *parent) : QObject(parent), volUpDown(false), volUpUsed(false)
{

}

bool HWButtons::eventFilter(QObject *, QEvent *ev)
{
    if (ev->type() == QEvent::KeyPress)
    {
        QKeyEvent* keyEvent = (QKeyEvent*)ev;

        if (!volUpDown && keyEvent->key() == Qt::Key_PowerOff)
        {
            QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "lock");
            return true;
        }

        if (keyEvent->key() == Qt::Key_VolumeUp)
        {
            volUpDown = true;
            volUpUsed = false;
        }
    } else if (ev->type() == QEvent::KeyRelease)
    {
        QKeyEvent* keyEvent = (QKeyEvent*)ev;

        if (volUpDown && keyEvent->key() == Qt::Key_PowerOff)
        {
            volUpUsed = true;
            ((QQmlApplicationEngine *)parent())->rootObjects()[0]->property("window").value<QQuickWindow *>()->grabWindow().save(
                QDir(QStandardPaths::writableLocation(QStandardPaths::PicturesLocation)).filePath("screenshot.jpg")
            );
            return true;
        }

        if (keyEvent->key() == Qt::Key_VolumeUp)
        {
            volUpDown = false;
            if (!volUpUsed) {
                QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "volUp");
            }
            return true;
        }

        if (keyEvent->key() == Qt::Key_VolumeDown)
        {
            QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "volDown");
            return true;
        }
    }
    return false;
}
