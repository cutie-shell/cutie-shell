#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "settings.h"

Settings::Settings(QObject *parent) : QObject(parent) {

    this->backlight = new com::github::CutiePiShellCommunityProject::SettingsDaemon::Backlight(
        "com.github.CutiePiShellCommunityProject.SettingsDaemon", "/com/github/CutiePiShellCommunityProject",
        QDBusConnection::systemBus());
    this->battery = new org::freedesktop::DBus::Properties(
        "org.freedesktop.UPower", "/org/freedesktop/UPower/devices/DisplayDevice",
        QDBusConnection::systemBus());    
    connect(this->battery, SIGNAL(PropertiesChanged(QString, QVariantMap, QStringList)), this, SLOT(onUPowerInfoChanged(QString, QVariantMap, QStringList)));
}

unsigned int Settings::GetMaxBrightness() {
    QDBusPendingReply<unsigned int> maxBrightnessReply = backlight->GetMaxBrightness();
    maxBrightnessReply.waitForFinished();
    if (maxBrightnessReply.isValid()) {
        return maxBrightnessReply.value();
    } else {
        return 0;
    }
}

unsigned int Settings::GetBrightness() {
    QDBusPendingReply<unsigned int> brightnessReply = backlight->GetBrightness();
    brightnessReply.waitForFinished();
    if (brightnessReply.isValid()) {
        return brightnessReply.value();
    } else {
        return 0;
    }

}

void Settings::SetBrightness(unsigned int value) {
    backlight->SetBrightness(value);
}

void Settings::onUPowerInfoChanged(QString interface, QVariantMap, QStringList) {
    if (interface == "org.freedesktop.UPower.Device") {
        refreshBatteryInfo();
    }
}

void Settings::refreshBatteryInfo() {
    QVariantMap upower_display = this->battery->GetAll("org.freedesktop.UPower.Device");
    ((QQmlApplicationEngine *)parent())->rootContext()->setContextProperty("batteryStatus", upower_display);
}