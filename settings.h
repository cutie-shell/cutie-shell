#ifndef BACKLIGHT_H
#define BACKLIGHT_H

#include <QDebug>

#include "cutiepishellcommunityproject_interface.h"
#include "dbus_interface.h"

class Settings : public QObject
{
    Q_OBJECT
private:
    com::github::CutiePiShellCommunityProject::SettingsDaemon::Backlight *backlight;
    org::freedesktop::DBus::Properties *battery;
    
public:
    Settings(QObject* parent = 0);
    Q_INVOKABLE unsigned int GetMaxBrightness();
    Q_INVOKABLE unsigned int GetBrightness();
    Q_INVOKABLE void SetBrightness(unsigned int value);
    void refreshBatteryInfo();
public Q_SLOTS:
    void onUPowerInfoChanged(QString interface, QVariantMap, QStringList);
};

#endif // BACKLIGHT_H