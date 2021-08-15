#include "atmosphere.h"

Atmosphere::Atmosphere()
{
    path = "file://usr/share/atmospheres/city/";
    variant = "dark";
}

QString Atmosphere::GetPath() {
    return path;
}

QString Atmosphere::GetVariant() {
    return variant;
}

void Atmosphere::SetPath(QString path) {
    QString oldPath = this->path;
    this->path = path;
    if (path != oldPath) PathChanged();
}

void Atmosphere::SetVariant(QString variant) {
    QString oldVariant = this->variant;
    this->variant = variant;
    if (variant != oldVariant) VariantChanged();
}