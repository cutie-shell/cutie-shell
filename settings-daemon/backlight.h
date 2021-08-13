#ifndef BACKLIGHT_H
#define BACKLIGHT_H

#include <QDebug>
#include <libudev.h>
#include <iostream>

class Backlight : public QObject
{
    Q_OBJECT
private:
    struct udev *udevInstance;
    struct udev_enumerate *udevEnumerator;
    struct udev_list_entry *udevEntry;
    struct udev_device *udevDevice;
    int maxBrightness;
public:
    Backlight();
public Q_SLOTS:
    unsigned int GetMaxBrightness();
    unsigned int GetBrightness();
    void SetBrightness(unsigned int value);
};

#endif // BACKLIGHT_H