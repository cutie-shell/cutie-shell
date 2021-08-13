#include "backlight.h"

Backlight::Backlight()
{
    udevInstance = udev_new();
    udevEnumerator = udev_enumerate_new(udevInstance);
    udev_enumerate_add_match_subsystem(udevEnumerator, "backlight");
    udev_enumerate_scan_devices(udevEnumerator);
    udevEntry = udev_enumerate_get_list_entry(udevEnumerator);
    const char *udevPath = udev_list_entry_get_name(udevEntry);
    udevDevice = udev_device_new_from_syspath(udevInstance, udevPath);
    if (! udevDevice)
        udevDevice = udev_device_new_from_syspath(udevInstance, "/sys/class/leds/lcd-backlight");
    maxBrightness = QString(udev_device_get_sysattr_value(udevDevice, "max_brightness")).toInt();
}

unsigned int Backlight::GetMaxBrightness() {
    return maxBrightness;
}

unsigned int Backlight::GetBrightness() {
    return QString(udev_device_get_sysattr_value(udevDevice, "brightness")).toInt();
}

void Backlight::SetBrightness(unsigned int value) {
    udev_device_set_sysattr_value(udevDevice, "brightness", std::to_string(value).c_str());
}