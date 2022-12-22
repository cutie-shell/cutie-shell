QT += quick dbus core network qml quick  gui-private

CONFIG += c++11

INCLUDEPATH += src

SOURCES += \
        src/main.cpp \
        src/settings.cpp \
        src/hwbuttons.cpp \
        src/notifications.cpp

HEADERS += \
        src/settings.h \
        src/hwbuttons.h \
        src/notifications.h

RESOURCES += \
        src/qml/qml.qrc \
        icons/icons.qrc \
        sounds/sounds.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /usr/bin
!isEmpty(target.path): INSTALLS += target

notifications.files = src/org.freedesktop.Notifications.xml
notifications.source_flags = -l Notifications
notifications.header_flags = -l Notifications -i notifications.h

DBUS_ADAPTORS += notifications

DBUS_INTERFACES += \
        src/org.freedesktop.DBus.xml \
        src/org.freedesktop.Notifications.xml \
        src/org.cutie_shell.xml

systemdservice.files = cutie-ui-io.service
systemdservice.path = /usr/lib/systemd/system/

systemdandroidservice.files = android-service@hwcomposer.service.d
systemdandroidservice.path = /etc/systemd/system/

logindconfig.files = logind.conf.d/10-cutie.conf
logindconfig.path = /etc/systemd/logind.conf.d/

layouts.files = src/qml/layouts
layouts.path = /usr/share/cutie-keyboard

atmospheres.files = atmospheres/atmospheres
atmospheres.path = /usr/share/

INSTALLS += logindconfig systemdservice systemdandroidservice layouts atmospheres
