#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtGui/QGuiApplication>
#include <QScreen>
#include <qpa/qplatformscreen.h>

#include "settings.h"

Settings::Settings(QObject *parent) : QObject(parent) {
    this->settingsStore = new QSettings("Cutie Community Project", "Cutie Shell");
    this->backlight = new org::cutie_shell::SettingsDaemon::Backlight(
        "org.cutie_shell.SettingsDaemon", "/backlight",
        QDBusConnection::systemBus());
    this->atmosphere = new org::cutie_shell::SettingsDaemon::Atmosphere(
        "org.cutie_shell.SettingsDaemon", "/atmosphere",
        QDBusConnection::systemBus());
    this->battery = new org::freedesktop::DBus::Properties(
        "org.freedesktop.UPower", "/org/freedesktop/UPower/devices/DisplayDevice",
        QDBusConnection::systemBus());    
    connect(this->battery, SIGNAL(PropertiesChanged(QString, QVariantMap, QStringList)), this, SLOT(onUPowerInfoChanged(QString, QVariantMap, QStringList)));
    connect(this->atmosphere, SIGNAL(PathChanged()), this, SLOT(onAtmospherePathChanged()));
    connect(this->atmosphere, SIGNAL(VariantChanged()), this, SLOT(onAtmosphereVariantChanged()));
    setAtmospherePath(this->settingsStore->value("atmospherePath", "file://usr/share/atmospheres/city/").toString());
    setAtmosphereVariant(this->settingsStore->value("atmosphereVariant", "dark").toString());
    onAtmospherePathChanged();
    onAtmosphereVariantChanged();
    ((QQmlApplicationEngine *)parent)->rootContext()->setContextProperty("screenBrightness", this->settingsStore->value("screenBrightness", 100));
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
	QPlatformScreen *pscreen = ((QGuiApplication *)QCoreApplication::instance())
			->screens().first()->handle();
	if (value == 0) {
		pscreen->setPowerState(QPlatformScreen::PowerStateOff);
	}
	if (value > 0 && pscreen->powerState() != QPlatformScreen::PowerStateOn) {
		pscreen->setPowerState(QPlatformScreen::PowerStateOn);
	}
	emit brightnessChanged(value);
}

void Settings::StoreBrightness(unsigned int value) {
    settingsStore->setValue("screenBrightness", value);
    settingsStore->sync();
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

void Settings::execApp(QString command)
{
    qputenv("CUTIE_SHELL", QByteArray("true"));
    qputenv("QT_QPA_PLATFORM", QByteArray("wayland"));
    qputenv("EGL_PLATFORM", QByteArray("wayland"));
    qunsetenv("QT_IM_MODULE");
    qunsetenv("QT_SCALE_FACTOR");
    qputenv("WAYLAND_DISPLAY", ((QQmlApplicationEngine *)parent())->rootObjects()[0]->property("socketName").toString().toUtf8());
    QStringList args = QStringList();
    args.append("-c");
    args.append(command);
    if (!QProcess::startDetached("bash", args))
        qDebug() << "Failed to run";
}

void Settings::loadAppList() {
    QString xdgDataDirs = QString(qgetenv("XDG_DATA_DIRS"));
    QStringList dataDirList = xdgDataDirs.split(':');
    for (int dirI = 0; dirI < dataDirList.count(); dirI++) {
        QDir *curAppDir = new QDir(dataDirList.at(dirI) + "/applications");
        if (curAppDir->exists()) {
            QStringList entryFiles = curAppDir->entryList(QDir::Files);
            for (int fileI = 0; fileI < entryFiles.count(); fileI++) {
                QString curEntryFileName = entryFiles.at(fileI);
                QSettings *curEntryFile = new QSettings(dataDirList.at(dirI) + "/applications/" + curEntryFileName, QSettings::IniFormat);
                QString desktopType = curEntryFile->value("Desktop Entry/Type").toString();
                if (desktopType == "Application") {
                    QString appName = curEntryFile->value("Desktop Entry/Name").toString();
		    if(appName.length() > 14) {
			appName = appName.mid(0,14).append("...");
		    }
                    QString appHidden = curEntryFile->value("Desktop Entry/Hidden").toString();
                    QString appNoDisplay = curEntryFile->value("Desktop Entry/NoDisplay").toString();
                    QString appExec = curEntryFile->value("Desktop Entry/Exec").toString();
                    QString appIcon = curEntryFile->value("Desktop Entry/Icon").toString();
                    if (appName != "" && appExec != "" && appHidden != "true" && appNoDisplay != "true")
                        QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "addApp", Q_ARG(QVariant, appName), Q_ARG(QVariant, appExec), Q_ARG(QVariant, appIcon));
                }
                delete curEntryFile;
            }
        }
        delete curAppDir;
    }
}

void Settings::autostart() {
    QStringList dataDirList;
    dataDirList.append("/etc/xdg");
    dataDirList.append("~/.config");
    for (int dirI = 0; dirI < dataDirList.count(); dirI++) {
        QDir *curAppDir = new QDir(dataDirList.at(dirI) + "/autostart");
        if (curAppDir->exists()) {
            QStringList entryFiles = curAppDir->entryList(QDir::Files);
            for (int fileI = 0; fileI < entryFiles.count(); fileI++) {
                QString curEntryFileName = entryFiles.at(fileI);
                QSettings *curEntryFile = new QSettings(dataDirList.at(dirI) + "/autostart/" + curEntryFileName, QSettings::IniFormat);
                QString desktopType = curEntryFile->value("Desktop Entry/Type").toString();
                if (desktopType == "Application") {
                    QString appName = curEntryFile->value("Desktop Entry/Name").toString();
                    QString appHidden = curEntryFile->value("Desktop Entry/Hidden").toString();
                    QString appExec = curEntryFile->value("Desktop Entry/Exec").toString();
                    if (appName != "" && appExec != "" && appHidden != "true")
                        execApp(appExec);
                }
                delete curEntryFile;
            }
        }
        delete curAppDir;
    }
}

void Settings::onAtmospherePathChanged() {
    QString apath = this->atmosphere->GetPath();
    ((QQmlApplicationEngine *)parent())->rootContext()->setContextProperty("atmospherePath", apath);
    settingsStore->setValue("atmospherePath", apath);
    settingsStore->sync();
}

void Settings::onAtmosphereVariantChanged() {
    QString avar = this->atmosphere->GetVariant();
    ((QQmlApplicationEngine *)parent())->rootContext()->setContextProperty("atmosphereVariant", avar);
    settingsStore->setValue("atmosphereVariant", avar);
    settingsStore->sync();
}

void Settings::setAtmospherePath(QString path) {
    this->atmosphere->SetPath(path);
    settingsStore->setValue("atmospherePath", path);
    settingsStore->sync();
}

void Settings::setAtmosphereVariant(QString variant) {
    this->atmosphere->SetVariant(variant);
    settingsStore->setValue("atmosphereVariant", variant);
    settingsStore->sync();
}
