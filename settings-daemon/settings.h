#ifndef SETTINGS_H
#define SETTINGS_H

#include "atmosphere.h"
#include "backlight.h"

class Settings : public Atmosphere, public Backlight
{
};

#endif // SETTINGS_H