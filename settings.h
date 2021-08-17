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
    com::github::CutiePiShellCommunityProject::SettingsDaemon::Atmosphere *atmosphere;
    com::github::CutiePiShellCommunityProject::SettingsDaemon::Ofono *ofono;
    com::github::CutiePiShellCommunityProject::SettingsDaemon::Modem *modem;
    org::freedesktop::DBus::Properties *battery;
    QSettings *settingsStore;
    
public:
    Settings(QObject* parent = 0);
    Q_INVOKABLE unsigned int GetMaxBrightness();
    Q_INVOKABLE unsigned int GetBrightness();
    Q_INVOKABLE void SetBrightness(unsigned int value);
    Q_INVOKABLE void StoreBrightness(unsigned int value);
    Q_INVOKABLE void execApp(QString command);
    Q_INVOKABLE void setAtmospherePath(QString path);
    Q_INVOKABLE void setAtmosphereVariant(QString variant);
    void refreshBatteryInfo();
    void autostart();
    Q_INVOKABLE void loadAppList();
public Q_SLOTS:
    void onUPowerInfoChanged(QString interface, QVariantMap, QStringList);
    void onAtmospherePathChanged();
    Q_INVOKABLE void onAtmosphereVariantChanged();
    void onNetNameChanged(QString name);
};

#endif // BACKLIGHT_H