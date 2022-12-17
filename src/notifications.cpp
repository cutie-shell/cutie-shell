#include "notifications.h"

#include <QQmlApplicationEngine>
#include <QQmlContext>

Notifications::Notifications(QObject *parent) : QObject(parent)
{
}

QStringList Notifications::GetCapabilities() {
    QStringList caps = QStringList();
    caps.append("body");
    caps.append("persistence");
    return caps;
}

uint Notifications::Notify(QString app_name, uint replaces_id, QString app_icon, QString summary, QString body, QStringList actions, QVariantMap hints, int expire_timeout) {
    ++currentId;
    if (replaces_id != 0) {
        QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "delNotification", Q_ARG(QVariant, replaces_id));
    }
    QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "addNotification", 
        Q_ARG(QVariant, summary), Q_ARG(QVariant, body), Q_ARG(QVariant, (replaces_id != 0) ? replaces_id : currentId));
    return (replaces_id != 0) ? replaces_id : currentId;
}

void Notifications::CloseNotification(uint id) {
    QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "delNotification", Q_ARG(QVariant, id));
}

QString Notifications::GetServerInformation(QString &vendor, QString &version, QString &spec_version) {
    vendor = "Cutie Community Project";
    version = "0.0.1";
    spec_version = "1.2";
    return "Cutie Shell";
}
