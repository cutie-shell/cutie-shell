#include "text-input-v2.h"

TextInputManagerV2::TextInputManagerV2()
{
}

TextInputManagerV2::TextInputManagerV2(QWaylandCompositor *compositor)
    :QWaylandCompositorExtensionTemplate(compositor)
{
    this->compositor = compositor;
    m_defaultSeat = compositor->defaultSeat();
}

void TextInputManagerV2::initialize()
{
	QWaylandCompositorExtensionTemplate::initialize();
    QWaylandCompositor *compositor = static_cast<QWaylandCompositor *>(extensionContainer());
    init(compositor->display(), 1);
}

void TextInputManagerV2::zwp_text_input_manager_v2_get_text_input(Resource *resource, uint32_t id, struct ::wl_resource *seat)
{
    QWaylandSurface *surf;

    TextInputV2 *textInput = new TextInputV2(resource->client(), id, resource->version());
    m_textInputMap.insert(resource->client(), textInput);

    connect (textInput, &TextInputV2::resourceDestroyed, this, &TextInputManagerV2::onResourceDestroyed);
    connect (textInput, &TextInputV2::textInputFocus, this, &TextInputManagerV2::textInputFocus);

    if(m_defaultSeat->keyboardFocus() != nullptr){
        surf = m_defaultSeat->keyboardFocus();
        if(surf->client()->client() == resource->client()){
            textInput->send_enter(0, surf->resource());
        }
    }
}

void TextInputManagerV2::sendString(QString string)
{
    if(m_activeInput != nullptr)
        m_activeInput->send_commit_string(string);
}

bool TextInputManagerV2::removeFocus(QWaylandSurface *oldFocus)
{
    bool ret = false;

    if(oldFocus != nullptr && m_textInputMap.contains(oldFocus->client()->client())){
        m_textInputMap.value(oldFocus->client()->client())->send_leave(0, oldFocus->resource());
        ret = true;

        m_activeInput = nullptr;
    }

    return ret;
}

bool TextInputManagerV2::setFocus(QWaylandSurface *newFocus)
{
    bool ret = false;

    if(newFocus != nullptr && m_textInputMap.contains(newFocus->client()->client())){
        m_textInputMap.value(newFocus->client()->client())->send_enter(0, newFocus->resource());
        m_activeInput = m_textInputMap.value(newFocus->client()->client());
        ret = true;
    }

    return ret;
}

void TextInputManagerV2::onResourceDestroyed(TextInputV2 *textinput)
{
    QMapIterator<struct ::wl_client *, TextInputV2 *> i(m_textInputMap);
    while (i.hasNext()) {
        i.next();
        if(i.value() == textinput)
            m_textInputMap.remove(i.key());
    }
}

TextInputV2::TextInputV2(wl_client *client, uint32_t id, int version)
    :QtWaylandServer::zwp_text_input_v2(client, id, version)
{
}

void TextInputV2::zwp_text_input_v2_show_input_panel(Resource *resource)
{
    emit textInputFocus(true);
}

void TextInputV2::zwp_text_input_v2_hide_input_panel(Resource *resource)
{
    emit textInputFocus(false);
}

void TextInputV2::zwp_text_input_v2_destroy_resource(Resource *resource)
{
    emit resourceDestroyed(this);
}