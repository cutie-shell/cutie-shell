#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDBusPendingReply>
#include "settings.h"
#include "hwbuttons.h"
#include "notifications.h"
#include "NotificationsAdaptor.h"
#include <QLoggingCategory>
#include <QIcon>

int main(int argc, char *argv[])
{
    int shellScaleFactor = qEnvironmentVariable("QT_SCALE_FACTOR", "1").toDouble();

    QIcon::setThemeName("hicolor");
    QIcon::setThemeSearchPaths(QStringList("/usr/share/icons"));

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QCoreApplication::setOrganizationName("Cutie Community Project");
    QCoreApplication::setApplicationName("Cutie Shell");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Settings *settings = new Settings(&engine);
    settings->refreshBatteryInfo();

    engine.rootContext()->setContextProperty("shellScaleFactor", shellScaleFactor);
    engine.rootContext()->setContextProperty("settings", settings);
    const QUrl url(QStringLiteral("qrc:/compositor.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    Notifications *notifications = new Notifications(&engine);
    new NotificationsAdaptor(notifications);
    QDBusConnection::sessionBus().registerObject("/org/freedesktop/Notifications", notifications);
    QDBusConnection::sessionBus().registerService("org.freedesktop.Notifications");

    settings->loadAppList();
    settings->autostart();
    settings->execApp("loginctl activate");

    HWButtons *btns = new HWButtons(&engine);
    app.installEventFilter(btns);

    return app.exec();
}
