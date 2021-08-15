#ifndef ATMOSPHERES_HANDLER_H
#define ATMOSPHERES_HANDLER_H

#include <QDebug>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "cutiepishellcommunityproject_interface.h"

class AtmosphereHandler : public QObject
{
    Q_OBJECT
    com::github::CutiePiShellCommunityProject::SettingsDaemon::Atmosphere * atmosphere;
    QQmlApplicationEngine *engine;
public:
    AtmosphereHandler (com::github::CutiePiShellCommunityProject::SettingsDaemon::Atmosphere * atmosphere, QQmlApplicationEngine *engine);
public Q_SLOTS:
    void onAtmosphereVariantChanged();
};

#endif