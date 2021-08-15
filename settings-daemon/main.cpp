#include <QCoreApplication>
#include "backlight.h"
#include "atmosphere.h"
#include "cutiepishellcommunityproject_adaptor.h"

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    Backlight *backlight = new Backlight();
    Atmosphere *atmosphere = new Atmosphere();

    new BacklightAdaptor(backlight);
    new AtmosphereAdaptor(atmosphere);

    QDBusConnection connection = QDBusConnection::systemBus();

    connection.registerObject("/com/github/CutiePiShellCommunityProject/backlight", backlight);
    connection.registerObject("/com/github/CutiePiShellCommunityProject/atmosphere", atmosphere);

    connection.registerService("com.github.CutiePiShellCommunityProject.SettingsDaemon");

    return app.exec();
}
