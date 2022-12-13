#ifndef BACKLIGHT_H
#define BACKLIGHT_H

#include <QDebug>

#include "cutie_shell_interface.h"
#include "dbus_interface.h"

class Settings : public QObject
{
    Q_OBJECT
    Q_PROPERTY (unsigned int brightness READ GetBrightness WRITE SetBrightness NOTIFY brightnessChanged)
    Q_PROPERTY (unsigned int maxBrightness READ GetMaxBrightness)
private:
    org::cutie_shell::SettingsDaemon::Backlight *backlight;
    org::cutie_shell::SettingsDaemon::Atmosphere *atmosphere;
    org::cutie_shell::SettingsDaemon::Modems *modemm;
    QList<org::cutie_shell::SettingsDaemon::Modem *> *modems;
    org::cutie_shell::SettingsDaemon::Networks *networks;
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
    void initCellular(int i);
    void initCellularFull();
    void initWifi();
    Q_INVOKABLE void loadAppList();
public Q_SLOTS:
    void onUPowerInfoChanged(QString interface, QVariantMap, QStringList);
    void onAtmospherePathChanged();
    Q_INVOKABLE void onAtmosphereVariantChanged();
    void onNetNameChanged(QString name);
    void onNetStrengthChanged(uchar strength);
    void onModemAdded(QDBusObjectPath path);
    void onWifiNameChanged(QString name);
    void onWifiStrengthChanged(uchar strength);
signals:
    void brightnessChanged(unsigned int brightness);
};

#endif // BACKLIGHT_H