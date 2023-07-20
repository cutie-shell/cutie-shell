#ifndef TEXTINPUTV2
#define TEXTINPUTV2

#include "wayland-util.h"

#include <QtWaylandCompositor/QWaylandCompositorExtensionTemplate>
#include <QtWaylandCompositor/QWaylandCompositor>
#include <QWaylandSeat>
#include <QMap>
#include "qwayland-server-text-input-unstable-v2.h"

class TextInputV2;

class TextInputManagerV2 : public QWaylandCompositorExtensionTemplate<TextInputManagerV2>
	, public QtWaylandServer::zwp_text_input_manager_v2

{
	Q_OBJECT
public:
	TextInputManagerV2();
	TextInputManagerV2(QWaylandCompositor *compositor);
	void initialize() override;

	bool setFocus(QWaylandSurface *newFocus);
	bool removeFocus(QWaylandSurface *oldFocus);

	void sendString(QString string);

signals:
	void textInputFocus(bool focus);

public Q_SLOTS:
	void onResourceDestroyed(TextInputV2 *textinput);
	
protected:
	virtual void zwp_text_input_manager_v2_get_text_input(Resource *resource, uint32_t id, struct ::wl_resource *seat) override;

private:
    QWaylandCompositor *compositor;
    QWaylandSeat *m_defaultSeat;
    TextInputV2 *m_activeInput;
    QMap<struct ::wl_client *, TextInputV2 *> m_textInputMap;
};

class  TextInputV2 : public QWaylandCompositorExtensionTemplate< TextInputV2>
	, public QtWaylandServer::zwp_text_input_v2
{
	Q_OBJECT
public:
	TextInputV2(struct ::wl_client *client, uint32_t id, int version);

signals:
	void resourceDestroyed(TextInputV2 *textinput);
	void textInputFocus(bool focus);

protected:
	virtual void zwp_text_input_v2_show_input_panel(Resource *resource) override;
	virtual void zwp_text_input_v2_hide_input_panel(Resource *resource) override;
	virtual void zwp_text_input_v2_destroy_resource(Resource *resource) override;
};

#endif //TEXTINPUTV2