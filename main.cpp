#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDBusPendingReply>
#include "settings.h"
#include "hwbuttons.h"

int main(int argc, char *argv[])
{
    int shellScaleFactor = qEnvironmentVariable("QT_SCALE_FACTOR", "1").toDouble();
    qunsetenv("QT_SCALE_FACTOR");
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    Settings *settings = new Settings();

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("shellScaleFactor", shellScaleFactor);
    engine.rootContext()->setContextProperty("settings", settings);
    const QUrl url(QStringLiteral("qrc:/compositor.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    HWButtons *btns = new HWButtons(&engine);
    app.installEventFilter(btns);

    return app.exec();
}
