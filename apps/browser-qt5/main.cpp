#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "cutiepishellcommunityproject_interface.h"
#include "atmospheres_handler.h"

com::github::CutiePiShellCommunityProject::SettingsDaemon::Atmosphere * atmosphere;

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    atmosphere = new com::github::CutiePiShellCommunityProject::SettingsDaemon::Atmosphere(
        "com.github.CutiePiShellCommunityProject.SettingsDaemon", "/com/github/CutiePiShellCommunityProject/atmosphere",
        QDBusConnection::systemBus());

    AtmosphereHandler atmosphereHandler(atmosphere, &engine);

    atmosphereHandler.onAtmosphereVariantChanged();

    const QUrl url(QStringLiteral("qrc:/browser.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
