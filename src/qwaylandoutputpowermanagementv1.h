#ifndef QWAYLANDOUTPUTPOWERMANAGEMENTV1
#define QWAYLANDOUTPUTPOWERMANAGEMENTV1

#include "wayland-util.h"

#include <QtWaylandCompositor/QWaylandCompositorExtensionTemplate>
#include <QtWaylandCompositor/QWaylandQuickExtension>
#include <QtWaylandCompositor/QWaylandCompositor>
#include "qwayland-server-wlr-output-power-management-unstable-v1.h"

//class WlrOutputPower;

class WlrOutputPowerManager : public QWaylandCompositorExtensionTemplate<WlrOutputPowerManager>
	, public QtWaylandServer::zwlr_output_power_manager_v1

{
	Q_OBJECT
public:
	WlrOutputPowerManager(QWaylandCompositor *compositor);
	void initialize() override;

signals:

public slots:

protected:

};

Q_COMPOSITOR_DECLARE_QUICK_EXTENSION_CLASS(WlrOutputPowerManager)

#endif //QWAYLANDOUTPUTPOWERMANAGEMENTV1