#ifndef TEXTINPUTV3
#define TEXTINPUTV3

#include "wayland-util.h"

#include <QtWaylandCompositor/QWaylandCompositorExtensionTemplate>
#include <QtWaylandCompositor/QWaylandCompositor>
#include <QWaylandSeat>
#include <QMap>
#include "qwayland-server-text-input-unstable-v3.h"

class TextInputV3;

class TextInputManagerV3 : public QWaylandCompositorExtensionTemplate<TextInputManagerV3>
	, public QtWaylandServer::zwp_text_input_manager_v3

{
	Q_OBJECT
public:
	TextInputManagerV3();
	TextInputManagerV3(QWaylandCompositor *compositor);
	void initialize() override;

	bool setFocus(QWaylandSurface *newFocus);
	bool removeFocus(QWaylandSurface *oldFocus);

	void sendString(QString string);

signals:
	void textInputFocus(bool focus);

public Q_SLOTS:
	void onResourceDestroyed(TextInputV3 *textinput);

protected:
	virtual void zwp_text_input_manager_v3_get_text_input(Resource *resource, uint32_t id, struct ::wl_resource *seat) override;
	virtual void zwp_text_input_manager_v3_destroy(Resource *resource) override;

private:
    QWaylandCompositor *compositor;
    QWaylandSeat *m_defaultSeat;
    TextInputV3 *m_activeInput;
    QMap<struct ::wl_client *, TextInputV3 *> m_textInputMap;
};

class  TextInputV3 : public QWaylandCompositorExtensionTemplate< TextInputV3>
	, public QtWaylandServer::zwp_text_input_v3
{
	Q_OBJECT
public:
	 TextInputV3(struct ::wl_client *client, uint32_t id, int version);

signals:
	void resourceDestroyed(TextInputV3 *textinput);
	void textInputFocus(bool focus);

protected:
	virtual void zwp_text_input_v3_enable(Resource *resource) override;
    virtual void zwp_text_input_v3_disable(Resource *resource) override;
    virtual void zwp_text_input_v3_set_surrounding_text(Resource *resource, const QString &text, int32_t cursor, int32_t anchor) override;
	virtual void zwp_text_input_v3_set_text_change_cause(Resource *resource, uint32_t cause) override;
	virtual void zwp_text_input_v3_set_content_type(Resource *resource, uint32_t hint, uint32_t purpose) override;
	virtual void zwp_text_input_v3_set_cursor_rectangle(Resource *resource, int32_t x, int32_t y, int32_t width, int32_t height) override;
	virtual void zwp_text_input_v3_commit(Resource *resource) override;
	virtual void zwp_text_input_v3_bind_resource(Resource *resource) override;
	virtual void zwp_text_input_v3_destroy_resource(Resource *resource) override;
};

#endif //TEXTINPUTV3