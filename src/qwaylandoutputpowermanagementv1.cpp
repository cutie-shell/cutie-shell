#include "qwaylandoutputpowermanagementv1.h"

WlrOutputPowerManager::WlrOutputPowerManager(QWaylandCompositor *compositor)
    :QWaylandCompositorExtensionTemplate(compositor)
{
}

void WlrOutputPowerManager::initialize()
{
	QWaylandCompositorExtensionTemplate::initialize();
    QWaylandCompositor *compositor = static_cast<QWaylandCompositor *>(extensionContainer());
    init(compositor->display(), 1);
}