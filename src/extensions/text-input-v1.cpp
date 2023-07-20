#include "text-input-v1.h"

TextInputManagerV1::TextInputManagerV1()
{
}

TextInputManagerV1::TextInputManagerV1(QWaylandCompositor *compositor)
    :QWaylandCompositorExtensionTemplate(compositor)
{
    this->compositor = compositor;
    m_defaultSeat = compositor->defaultSeat();
}

void TextInputManagerV1::initialize()
{
	QWaylandCompositorExtensionTemplate::initialize();
    QWaylandCompositor *compositor = static_cast<QWaylandCompositor *>(extensionContainer());
    init(compositor->display(), 1);
}

void TextInputManagerV1::zwp_text_input_manager_v1_create_text_input(Resource *resource, uint32_t id)
{
    QWaylandSurface *surf;

    TextInputV1 *textInput = new TextInputV1(resource->client(), id, resource->version());
    m_textInputMap.insert(resource->client(), textInput);

    connect (textInput, &TextInputV1::resourceDestroyed, this, &TextInputManagerV1::onResourceDestroyed);
    connect (textInput, &TextInputV1::textInputFocus, this, &TextInputManagerV1::textInputFocus);

    if(m_defaultSeat->keyboardFocus() != nullptr){
        surf = m_defaultSeat->keyboardFocus();
        if(surf->client()->client() == resource->client()){
            textInput->send_enter(surf->resource());
        }
    }
}

void TextInputManagerV1::sendString(QString string)
{
    if(m_activeInput != nullptr)
        m_activeInput->send_commit_string(0, string);
}

bool TextInputManagerV1::removeFocus(QWaylandSurface *oldFocus)
{
    bool ret = false;

    if(oldFocus != nullptr && m_textInputMap.contains(oldFocus->client()->client())){
        m_textInputMap.value(oldFocus->client()->client())->send_leave(oldFocus->resource());
        ret = true;

        m_activeInput = nullptr;
    }

    return ret;
}

bool TextInputManagerV1::setFocus(QWaylandSurface *newFocus)
{
    bool ret = false;

    if(newFocus != nullptr && m_textInputMap.contains(newFocus->client()->client())){
        m_textInputMap.value(newFocus->client()->client())->send_enter(newFocus->resource());
        m_activeInput = m_textInputMap.value(newFocus->client()->client());
        ret = true;
    }

    return ret;
}

void TextInputManagerV1::onResourceDestroyed(TextInputV1 *textinput)
{
    QMapIterator<struct ::wl_client *, TextInputV1 *> i(m_textInputMap);
    while (i.hasNext()) {
        i.next();
        if(i.value() == textinput)
            m_textInputMap.remove(i.key());
    }
}

TextInputV1::TextInputV1(wl_client *client, uint32_t id, int version)
    :QtWaylandServer::zwp_text_input_v1(client, id, version)
{
}

void TextInputV1::zwp_text_input_v1_bind_resource(Resource *resource)
{
}

void TextInputV1::zwp_text_input_v1_destroy_resource(Resource *resource)
{
    emit resourceDestroyed(this);
}

void TextInputV1::zwp_text_input_v1_activate(Resource *resource, struct ::wl_resource *seat, struct ::wl_resource *surface)
{
}

void TextInputV1::zwp_text_input_v1_deactivate(Resource *resource, struct ::wl_resource *seat)
{
}

void TextInputV1::zwp_text_input_v1_show_input_panel(Resource *resource)
{
    emit textInputFocus(true);
}

void TextInputV1::zwp_text_input_v1_hide_input_panel(Resource *resource)
{
    emit textInputFocus(false);
}

void TextInputV1::zwp_text_input_v1_reset(Resource *resource)
{
}

void TextInputV1::zwp_text_input_v1_set_surrounding_text(Resource *resource, const QString &text, uint32_t cursor, uint32_t anchor)
{
}

void TextInputV1::zwp_text_input_v1_set_content_type(Resource *resource, uint32_t hint, uint32_t purpose)
{
}

void TextInputV1::zwp_text_input_v1_set_cursor_rectangle(Resource *resource, int32_t x, int32_t y, int32_t width, int32_t height)
{
}

void TextInputV1::zwp_text_input_v1_set_preferred_language(Resource *resource, const QString &language)
{
}

void TextInputV1::zwp_text_input_v1_commit_state(Resource *resource, uint32_t serial)
{
}

void TextInputV1::zwp_text_input_v1_invoke_action(Resource *resource, uint32_t button, uint32_t index)
{
}