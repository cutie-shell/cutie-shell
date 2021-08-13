#ifndef BACKLIGHT_H
#define BACKLIGHT_H

#include <QDebug>

#include "cutiepishellcommunityproject_interface.h"

class Settings : public QObject
{
    Q_OBJECT
private:
    com::github::CutiePiShellCommunityProject::SettingsDaemon::Backlight *backlight;
    
public:
    Settings();
    Q_INVOKABLE unsigned int GetMaxBrightness();
    Q_INVOKABLE unsigned int GetBrightness();
    Q_INVOKABLE void SetBrightness(unsigned int value);
};

#endif // BACKLIGHT_H