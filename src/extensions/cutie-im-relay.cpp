#include "cutie-im-relay.h"
#include <QKeyEvent>

CutieImRelay::CutieImRelay(QWaylandCompositor *compositor)
    : QWaylandCompositorExtensionTemplate(compositor)
{
}

void CutieImRelay::initialize()
{
    QWaylandCompositorExtensionTemplate::initialize();
    QWaylandCompositor *compositor = static_cast<QWaylandCompositor *>(extensionContainer());
    init(compositor->display(), 1);

    m_compositor = compositor;
    m_defaultSeat = compositor->defaultSeat();

    m_textinputV1 = new TextInputManagerV1(m_compositor);
    m_textinputV2 = new TextInputManagerV2(m_compositor);
    m_textinputV3 = new TextInputManagerV3(m_compositor);

    connect (m_defaultSeat, &QWaylandSeat::keyboardFocusChanged, this, &CutieImRelay::onKeyboardFocusChanged);
    connect (m_textinputV3, &TextInputManagerV3::textInputFocus, this, &CutieImRelay::setShowKeyboard);
    connect (m_textinputV2, &TextInputManagerV2::textInputFocus, this, &CutieImRelay::setShowKeyboard);
    connect (m_textinputV1, &TextInputManagerV1::textInputFocus, this, &CutieImRelay::setShowKeyboard);
}

bool CutieImRelay::showKeyboard()
{
    return m_showKeyboard;
}

void CutieImRelay::setShowKeyboard(bool showKeyboard)
{
    if(!showKeyboard)
        m_currentFocus = 0;
    else if(TextInputManagerV1* v1 = qobject_cast<TextInputManagerV1*>(sender()))
        m_currentFocus = 1;
    else if(TextInputManagerV2* v2 = qobject_cast<TextInputManagerV2*>(sender()))
        m_currentFocus = 2;
    else if(TextInputManagerV3* v3 = qobject_cast<TextInputManagerV3*>(sender()))
        m_currentFocus = 3;
    else
        m_currentFocus = 0;

    if(m_showKeyboard != showKeyboard){
        m_showKeyboard = showKeyboard;
        emit showKeyboardChanged(m_showKeyboard);
    }
}

void CutieImRelay::sendString(QString string)
{
    if(m_currentFocus == 1){
        m_textinputV1->sendString(string);
    } else if(m_currentFocus == 2){
        m_textinputV2->sendString(string);
    } else if(m_currentFocus == 3){
        m_textinputV3->sendString(string);
    } else if(m_currentFocus == 0){

    }
}

void CutieImRelay::sendFunctionKey(uint32_t key, int state)
{
    m_defaultSeat->sendKeyEvent(key, state);
}

void CutieImRelay::sendEvent(QString string, uint32_t key)
{
    QKeySequence qtkey = QKeySequence(string);

    QKeyEvent *key_press = new QKeyEvent(QEvent::KeyPress, qtkey[0].key(), Qt::KeyboardModifiers{key});
    QKeyEvent *key_release = new QKeyEvent(QEvent::KeyRelease, qtkey[0].key(), Qt::KeyboardModifiers{});

    m_defaultSeat->sendFullKeyEvent(key_press);
    m_defaultSeat->sendFullKeyEvent(key_release);

/*
    The rest of this function is a workaround, so we don't need to use private headers.
    Debian does not package them and we don't need to maintain another package. As we use sendFullKeyEvent
    only if modifier keys are used, the modifier state gets never reset. And it only works for one client.

    Better solution would be to call QWaylandKeyboardPrivate::checkAndRepairModifierState(key_release)
*/
    key_press = new QKeyEvent(QEvent::KeyPress, Qt::Key_AltGr, Qt::KeyboardModifiers{});
    key_release = new QKeyEvent(QEvent::KeyRelease, Qt::Key_AltGr, Qt::KeyboardModifiers{});
    m_defaultSeat->sendFullKeyEvent(key_press);
    m_defaultSeat->sendFullKeyEvent(key_release);
}

void CutieImRelay::onKeyboardFocusChanged(QWaylandSurface *newFocus, QWaylandSurface *oldFocus)
{
    if (m_textinputV3->removeFocus(oldFocus)){
        goto setfocus;
    } else if(m_textinputV2->removeFocus(oldFocus)){
        goto setfocus;
    } else if(m_textinputV1->removeFocus(oldFocus)){
        goto setfocus;
    }

setfocus:
    if (m_textinputV3->setFocus(newFocus)){
        return;
    } else if(m_textinputV2->setFocus(newFocus)){
        return;
    } else if(m_textinputV1->setFocus(newFocus)){
        return;
    }
}