#include "settings.h"

Settings::Settings () {
    this->backlight = new com::github::CutiePiShellCommunityProject::SettingsDaemon::Backlight(
        "com.github.CutiePiShellCommunityProject.SettingsDaemon", "/com/github/CutiePiShellCommunityProject",
        QDBusConnection::systemBus());
}

unsigned int Settings::GetMaxBrightness() {
    QDBusPendingReply<unsigned int> maxBrightnessReply = backlight->GetMaxBrightness();
    maxBrightnessReply.waitForFinished();
    if (maxBrightnessReply.isValid()) {
        return maxBrightnessReply.value();
    } else {
        return 0;
    }
}

unsigned int Settings::GetBrightness() {
    QDBusPendingReply<unsigned int> brightnessReply = backlight->GetBrightness();
    brightnessReply.waitForFinished();
    if (brightnessReply.isValid()) {
        return brightnessReply.value();
    } else {
        return 0;
    }

}

void Settings::SetBrightness(unsigned int value) {
    backlight->SetBrightness(value);
}