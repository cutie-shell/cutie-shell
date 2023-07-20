#ifndef CUTIEIMRELAY_H
#define CUTIEIMRELAY_H

#include "wayland-util.h"

#include <QtWaylandCompositor/QWaylandCompositorExtensionTemplate>
#include <QtWaylandCompositor/QWaylandQuickExtension>
#include <QtWaylandCompositor/QWaylandCompositor>
#include <QWaylandSeat>
#include <QWaylandKeyboard>
#include "qwayland-server-cutie-im-relay-v1.h"

#include "extensions/text-input-v1.h"
#include "extensions/text-input-v2.h"
#include "extensions/text-input-v3.h"

class CutieImRelay : public QWaylandCompositorExtensionTemplate<CutieImRelay>
    , public QtWaylandServer::cutie_im_relay
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool showKeyboard READ showKeyboard WRITE setShowKeyboard NOTIFY showKeyboardChanged)

public:
    CutieImRelay(QWaylandCompositor *compositor = nullptr);
    void initialize() override;

    bool showKeyboard();

    void setShowKeyboard(bool showKeyboard);
    Q_INVOKABLE void sendString(QString string);
    Q_INVOKABLE void sendFunctionKey(uint32_t key, int state);
    Q_INVOKABLE void sendEvent(QString string, uint32_t key);

Q_SIGNALS:
    void showKeyboardChanged(bool);

public Q_SLOTS:
    void onKeyboardFocusChanged(QWaylandSurface *newFocus, QWaylandSurface *oldFocus);

private:
    bool m_showKeyboard;
    int m_currentFocus;

    QWaylandCompositor *m_compositor;
    TextInputManagerV1 *m_textinputV1;
    TextInputManagerV2 *m_textinputV2;
    TextInputManagerV3 *m_textinputV3;

    QWaylandSeat *m_defaultSeat;
};

Q_COMPOSITOR_DECLARE_QUICK_EXTENSION_CLASS(CutieImRelay)

#endif // CUTIEIMRELAY_H