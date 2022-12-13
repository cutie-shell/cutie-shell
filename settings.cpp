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
    this->modemm = new org::cutie_shell::SettingsDaemon::Modems(
        "org.cutie_shell.SettingsDaemon", "/modem",
        QDBusConnection::systemBus());
    this->networks = new org::cutie_shell::SettingsDaemon::Networks(
        "org.cutie_shell.SettingsDaemon", "/connection",
        QDBusConnection::systemBus());
    this->modems = new QList<org::cutie_shell::SettingsDaemon::Modem *>();
    QDBusPendingReply<unsigned int> countReply = modemm->ModemCount();
    countReply.waitForFinished();
    if (countReply.isValid()) {
        for (unsigned int i = 0; i < countReply.value(); i++) {
            org::cutie_shell::SettingsDaemon::Modem *modem = 
                new org::cutie_shell::SettingsDaemon::Modem(
                "org.cutie_shell.SettingsDaemon", QString("/modem/").append(QString::number(i)),
                QDBusConnection::systemBus());
            modem->PowerModem(true);
            modem->OnlineModem(true);
            modems->append(modem);
        }
    }
    this->battery = new org::freedesktop::DBus::Properties(
        "org.freedesktop.UPower", "/org/freedesktop/UPower/devices/DisplayDevice",
        QDBusConnection::systemBus());    
    connect(this->battery, SIGNAL(PropertiesChanged(QString, QVariantMap, QStringList)), this, SLOT(onUPowerInfoChanged(QString, QVariantMap, QStringList)));
    connect(this->atmosphere, SIGNAL(PathChanged()), this, SLOT(onAtmospherePathChanged()));
    connect(this->atmosphere, SIGNAL(VariantChanged()), this, SLOT(onAtmosphereVariantChanged()));
    connect(this->modemm, SIGNAL(ModemAdded(QDBusObjectPath)), this, SLOT(onModemAdded(QDBusObjectPath)));
    setAtmospherePath(this->settingsStore->value("atmospherePath", "file://usr/share/atmospheres/city/").toString());
    setAtmosphereVariant(this->settingsStore->value("atmosphereVariant", "dark").toString());
    onAtmospherePathChanged();
    onAtmosphereVariantChanged();
    ((QQmlApplicationEngine *)parent)->rootContext()->setContextProperty("screenBrightness", this->settingsStore->value("screenBrightness", 100));
}

void Settings::initCellular(int i) {
    org::cutie_shell::SettingsDaemon::Modem *modem = 0;
    if (modems->count() >= i) {
        modem = modems->at(i - 1);
    } else {
        return;
    }

    QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "addModem", Q_ARG(QVariant, i));   

    QDBusPendingReply<QString> netReply = modem->GetNetName();
    netReply.waitForFinished();
    if (netReply.isValid()) {
        QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "setCellularName", Q_ARG(QVariant, i), Q_ARG(QVariant, netReply.value()));
    }

    QDBusPendingReply<uchar> netReply2 = modem->GetNetStrength();
    netReply2.waitForFinished();
    if (netReply2.isValid()) {
        QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "setCellularStrength", Q_ARG(QVariant, i), Q_ARG(QVariant, netReply2.value()));
    }

    connect(modem, SIGNAL(NetNameChanged(QString)), this, SLOT(onNetNameChanged(QString)));
    connect(modem, SIGNAL(NetStrengthChanged(uchar)), this, SLOT(onNetStrengthChanged(uchar)));   
}

void Settings::initWifi() {
    QDBusPendingReply<QString> netReply = networks->GetWifiName();
    netReply.waitForFinished();
    if (netReply.isValid()) {
        QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "setWifiName", Q_ARG(QVariant, netReply.value()));
    }

    QDBusPendingReply<uchar> netReply2 = networks->GetWifiStrength();
    netReply2.waitForFinished();
    if (netReply2.isValid()) {
        QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "setWifiStrength", Q_ARG(QVariant, netReply2.value()));
    }

    connect(this->networks, SIGNAL(WifiStrengthChanged(uchar)), this, SLOT(onWifiStrengthChanged(uchar)));
    connect(this->networks, SIGNAL(WifiNameChanged(QString)), this, SLOT(onWifiNameChanged(QString)));  
}

void Settings::initCellularFull() {
    for(int i = 0; i < modems->count(); i++) {
        initCellular(i + 1);
    }
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
    qputenv("QT_SCALE_FACTOR", QString::number(((QQmlApplicationEngine *)parent())->rootContext()->contextProperty("shellScaleFactor").toDouble()).toUtf8());
    qputenv("GDK_SCALE", QString::number(((QQmlApplicationEngine *)parent())->rootContext()->contextProperty("shellScaleFactor").toDouble()).toUtf8());
    qputenv("GDK_DPI_SCALE", QString::number(((QQmlApplicationEngine *)parent())->rootContext()->contextProperty("shellScaleFactor").toDouble()).toUtf8());
	qunsetenv("QT_IM_MODULE");
    qputenv("WAYLAND_DISPLAY", ((QQmlApplicationEngine *)parent())->rootObjects()[0]->property("socketName").toString().toUtf8());
    QStringList args = QStringList();
    args.append("-c");
    args.append(command);
    if (!QProcess::startDetached("bash", args))
        qDebug() << "Failed to run";
}

void Settings::loadAppList() {
    QString xdgDataDirs = QTextCodec::codecForMib(106)->toUnicode(qgetenv("XDG_DATA_DIRS"));
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

void Settings::onNetNameChanged(QString name) {
    org::cutie_shell::SettingsDaemon::Modem *modem = (org::cutie_shell::SettingsDaemon::Modem *)sender();
    int i = modems->lastIndexOf(modem);
    QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "setCellularName", Q_ARG(QVariant, i + 1), Q_ARG(QVariant, name));      
}

void Settings::onNetStrengthChanged(uchar strength) {
    org::cutie_shell::SettingsDaemon::Modem *modem = (org::cutie_shell::SettingsDaemon::Modem *)sender();
    int i = modems->lastIndexOf(modem);
    QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "setCellularStrength", Q_ARG(QVariant, i + 1), Q_ARG(QVariant, strength));      
}

void Settings::onWifiNameChanged(QString name) {
    QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "setWifiName", Q_ARG(QVariant, name));      
}

void Settings::onWifiStrengthChanged(uchar strength) {
    QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "setWifiStrength",Q_ARG(QVariant, strength));      
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

void Settings::onModemAdded(QDBusObjectPath path) {
    org::cutie_shell::SettingsDaemon::Modem *modem = 
        new org::cutie_shell::SettingsDaemon::Modem(
        "org.cutie_shell.SettingsDaemon", path.path(),
        QDBusConnection::systemBus());
    modem->PowerModem(true);
    modem->OnlineModem(true);
    modems->append(modem);
    this->initCellular(modems->count());
}