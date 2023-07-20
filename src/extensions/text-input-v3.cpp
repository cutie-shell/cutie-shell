#include "text-input-v3.h"

TextInputManagerV3::TextInputManagerV3()
{
}

TextInputManagerV3::TextInputManagerV3(QWaylandCompositor *compositor)
    :QWaylandCompositorExtensionTemplate(compositor)
{
    this->compositor = compositor;
    m_defaultSeat = compositor->defaultSeat();

    //connect (m_defaultSeat, &QWaylandSeat::keyboardFocusChanged, this, &TextInputManagerV3::onKeyboardFocusChanged);
}

void TextInputManagerV3::initialize()
{
	QWaylandCompositorExtensionTemplate::initialize();
    QWaylandCompositor *compositor = static_cast<QWaylandCompositor *>(extensionContainer());
    init(compositor->display(), 1);
}

void TextInputManagerV3::zwp_text_input_manager_v3_get_text_input(Resource *resource, uint32_t id, struct ::wl_resource *seat)
{
    QWaylandSurface *surf;

    TextInputV3 *textInput = new TextInputV3(resource->client(), id, resource->version());
    m_textInputMap.insert(resource->client(), textInput);

    connect (textInput, &TextInputV3::resourceDestroyed, this, &TextInputManagerV3::onResourceDestroyed);
    connect (textInput, &TextInputV3::textInputFocus, this, &TextInputManagerV3::textInputFocus);

    if(m_defaultSeat->keyboardFocus() != nullptr){
        surf = m_defaultSeat->keyboardFocus();
        if(surf->client()->client() == resource->client()){
            textInput->send_enter(surf->resource());
            m_activeInput = textInput;
        }
    }
}

void TextInputManagerV3::sendString(QString string)
{
    if(m_activeInput != nullptr){
        m_activeInput->send_commit_string(string);
        m_activeInput->send_done(0);
    }
}

bool TextInputManagerV3::removeFocus(QWaylandSurface *oldFocus)
{
    bool ret = false;

    if(oldFocus != nullptr && m_textInputMap.contains(oldFocus->client()->client())){
        m_textInputMap.value(oldFocus->client()->client())->send_leave(oldFocus->resource());
        ret = true;

        m_activeInput = nullptr;
    }

    return ret;
}

bool TextInputManagerV3::setFocus(QWaylandSurface *newFocus)
{
    bool ret = false;

    if(newFocus != nullptr && m_textInputMap.contains(newFocus->client()->client())){
        m_textInputMap.value(newFocus->client()->client())->send_enter(newFocus->resource());
        m_activeInput = m_textInputMap.value(newFocus->client()->client());
        ret = true;
    }

    return ret;
}

void TextInputManagerV3::onResourceDestroyed(TextInputV3 *textinput)
{
    QMapIterator<struct ::wl_client *, TextInputV3 *> i(m_textInputMap);
    while (i.hasNext()) {
        i.next();
        if(i.value() == textinput)
            m_textInputMap.remove(i.key());
    }
}

void TextInputManagerV3::zwp_text_input_manager_v3_destroy(Resource *resource)
{
}

TextInputV3::TextInputV3(wl_client *client, uint32_t id, int version)
    :QtWaylandServer::zwp_text_input_v3(client, id, version)
{
}

void TextInputV3::zwp_text_input_v3_enable(Resource *resource)
{
    emit textInputFocus(true);
}

void TextInputV3::zwp_text_input_v3_disable(Resource *resource)
{
    emit textInputFocus(false);
}

void TextInputV3::zwp_text_input_v3_set_surrounding_text(Resource *resource, const QString &text, int32_t cursor, int32_t anchor)
{
}

void TextInputV3::zwp_text_input_v3_set_text_change_cause(Resource *resource, uint32_t cause)
{
}

void TextInputV3::zwp_text_input_v3_set_content_type(Resource *resource, uint32_t hint, uint32_t purpose)
{
}

void TextInputV3::zwp_text_input_v3_set_cursor_rectangle(Resource *resource, int32_t x, int32_t y, int32_t width, int32_t height)
{
}

void TextInputV3::zwp_text_input_v3_commit(Resource *resource)
{
}

void TextInputV3::zwp_text_input_v3_bind_resource(Resource *resource)
{
}

void TextInputV3::zwp_text_input_v3_destroy_resource(Resource *resource)
{
    emit resourceDestroyed(this);
}