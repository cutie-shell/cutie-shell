#include "plugin.h"

AtmosphereModel::AtmosphereModel(QObject *parent) : QObject(parent)
{
    this->atmosphere = new com::github::CutiePiShellCommunityProject::SettingsDaemon::Atmosphere(
        "com.github.CutiePiShellCommunityProject.SettingsDaemon", "/com/github/CutiePiShellCommunityProject/atmosphere",
        QDBusConnection::systemBus());
    connect(this->atmosphere, SIGNAL(PathChanged()), this, SLOT(onAtmospherePathChanged()));
    connect(this->atmosphere, SIGNAL(VariantChanged()), this, SLOT(onAtmosphereVariantChanged()));
    onAtmospherePathChanged();
    onAtmosphereVariantChanged();
}

AtmosphereModel::~AtmosphereModel()
{
}

QString AtmosphereModel::path() {
    return p_path;
}

QString AtmosphereModel::variant() {
    return p_variant;
}

void AtmosphereModel::onAtmospherePathChanged() {
    QString old_path = p_path;
    p_path = this->atmosphere->GetPath();
    if (old_path != p_path) pathChanged();
}

void AtmosphereModel::onAtmosphereVariantChanged() {
    QString old_variant = p_variant;
    p_variant = this->atmosphere->GetVariant();
    if (old_variant != p_variant) variantChanged();
}

void CutiePlugin::registerTypes(const char *uri)
{
    qmlRegisterType<AtmosphereModel>(uri, 1, 0, "Atmosphere");
}