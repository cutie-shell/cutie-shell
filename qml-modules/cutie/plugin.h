#include <QDebug>
#include <QtQuick>
#include <QtQml/qqml.h>
#include <QtQml/QQmlExtensionPlugin>
#include "cutiepishellcommunityproject_interface.h"

class AtmosphereModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString path READ path NOTIFY pathChanged);
    Q_PROPERTY(QString variant READ variant NOTIFY variantChanged);
    com::github::CutiePiShellCommunityProject::SettingsDaemon::Atmosphere *atmosphere;
    QString p_path;
    QString p_variant;
public:
    AtmosphereModel(QObject *parent=0);

    ~AtmosphereModel();

    Q_INVOKABLE QString path();
    Q_INVOKABLE QString variant();

public Q_SLOTS:
    void onAtmospherePathChanged();
    void onAtmosphereVariantChanged();

Q_SIGNALS:
    void pathChanged();
    void variantChanged();
};

class CutiePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid FILE "cutie.json")
    void registerTypes(const char *uri);
};