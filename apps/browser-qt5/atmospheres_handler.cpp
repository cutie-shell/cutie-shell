#include "atmospheres_handler.h"

AtmosphereHandler::AtmosphereHandler (com::github::CutiePiShellCommunityProject::SettingsDaemon::Atmosphere * atmosphere, QQmlApplicationEngine *engine) {
    this->atmosphere = atmosphere;
    this->engine = engine;
    connect(atmosphere, SIGNAL(VariantChanged()), this, SLOT(onAtmosphereVariantChanged()));
}

void AtmosphereHandler::onAtmosphereVariantChanged() {
    QString avar = atmosphere->GetVariant();
    engine->rootContext()->setContextProperty("atmosphereVariant", avar);
}