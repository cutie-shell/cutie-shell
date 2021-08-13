#include <QCoreApplication>
#include "backlight.h"
#include "cutiepishellcommunityproject_adaptor.h"

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    Backlight *backlight = new Backlight();

    new BacklightAdaptor(backlight);

    QDBusConnection connection = QDBusConnection::systemBus();
    connection.registerObject("/com/github/CutiePiShellCommunityProject", backlight);
    connection.registerService("com.github.CutiePiShellCommunityProject.SettingsDaemon");

    return app.exec();
}
