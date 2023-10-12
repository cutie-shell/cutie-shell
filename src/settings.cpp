#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtGui/QGuiApplication>
#include <QScreen>
#include <qpa/qplatformscreen.h>

#include "settings.h"

Settings::Settings(QObject *parent) : QObject(parent) {
    this->desktopFormat = QSettings::registerFormat("desktop", readDesktopFile, nullptr);
    this->settingsStore = new QSettings("Cutie Community Project", "Cutie Shell");
    this->battery = new org::freedesktop::DBus::Properties(
        "org.freedesktop.UPower", "/org/freedesktop/UPower/devices/DisplayDevice",
        QDBusConnection::systemBus());    
    connect(this->battery, SIGNAL(PropertiesChanged(QString, QVariantMap, QStringList)), this, SLOT(onUPowerInfoChanged(QString, QVariantMap, QStringList)));

    udevInstance = udev_new();
    udevEnumerator = udev_enumerate_new(udevInstance);
    udev_enumerate_add_match_subsystem(udevEnumerator, "backlight");
    udev_enumerate_scan_devices(udevEnumerator);
    udevEntry = udev_enumerate_get_list_entry(udevEnumerator);
    const char *udevPath = udev_list_entry_get_name(udevEntry);
    udevDevice = udev_device_new_from_syspath(udevInstance, udevPath);
    if (!udevDevice)
        udevDevice = udev_device_new_from_syspath(udevInstance, "/sys/class/leds/lcd-backlight");
    p_maxBrightness = QString(udev_device_get_sysattr_value(udevDevice, "max_brightness")).toInt();

    ((QQmlApplicationEngine *)parent)->rootContext()->setContextProperty("screenBrightness", this->settingsStore->value("screenBrightness", 100));
}

bool Settings::readDesktopFile(QIODevice &device, QSettings::SettingsMap &map) {
    QTextStream in(&device);
    QString header;
    while (!in.atEnd()) {
        QString line = in.readLine();
        if (line.startsWith("[") && line.endsWith("]")) {
            header = line.sliced(1).chopped(1);
        } else if (line.contains("=")) {
            map.insert(header + "/" + line.split("=").at(0), 
                line.sliced(line.indexOf('=') + 1));
        } else if (!line.isEmpty() && !line.startsWith("#")) {
            return false;
        }
    }

    return true;
}

unsigned int Settings::GetMaxBrightness() {
    return p_maxBrightness;
}

unsigned int Settings::GetBrightness() {
    return udevDevice ? QString(udev_device_get_sysattr_value(udevDevice, "brightness")).toInt() : 0;
}

void Settings::SetBrightness(unsigned int value) {
    if (udevDevice)
        udev_device_set_sysattr_value(udevDevice, "brightness", std::to_string(value).c_str());
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
    qunsetenv("QT_QPA_GENERIC_PLUGINS");
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
                QSettings *curEntryFile = new QSettings(dataDirList.at(dirI) + "/applications/" + curEntryFileName, desktopFormat);
                QString desktopType = curEntryFile->value("Desktop Entry/Type").toString();
                if (desktopType == "Application") {
                    QVariantMap appData;
                    QStringList keys = curEntryFile->allKeys();
                    foreach (QString key, keys) {
                        appData.insert(key, curEntryFile->value(key));
                    }
                    
                    QString appHidden = curEntryFile->value("Desktop Entry/Hidden").toString();
                    QString appNoDisplay = curEntryFile->value("Desktop Entry/NoDisplay").toString();
                    if (appHidden != "true" && appNoDisplay != "true")
                        QMetaObject::invokeMethod(((QQmlApplicationEngine *)parent())->rootObjects()[0], "addApp", Q_ARG(QVariant, appData));
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
                QSettings *curEntryFile = new QSettings(dataDirList.at(dirI) + "/autostart/" + curEntryFileName, desktopFormat);
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
