QT += quick dbus core network  qml quick
#positioning problem depends in qtbase5-gles-dev
CONFIG += c++11


# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        #appmodel.cpp \
        main.cpp \
        settings.cpp \
        hwbuttons.cpp \
        notifications.cpp

HEADERS += \
        #appmodel.h \
        settings.h \
        hwbuttons.h \
        notifications.h

RESOURCES += \
        qml/qml.qrc \
        icons/icons.qrc \
        fonts/fonts.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /usr/bin
!isEmpty(target.path): INSTALLS += target

notifications.files = org.freedesktop.Notifications.xml
notifications.source_flags = -l Notifications
notifications.header_flags = -l Notifications -i notifications.h

DBUS_ADAPTORS += notifications

DBUS_INTERFACES += \
        org.freedesktop.DBus.xml \
        org.freedesktop.Notifications.xml \
        org.cutie_shell.xml

systemdservice.files = cutie-ui-io.service
systemdservice.path = /usr/lib/systemd/system/

autostart.files = maliit.desktop
autostart.path = /etc/xdg/autostart/

logindconfig.files = logind.conf.d/10-cutie.conf
logindconfig.path = /etc/systemd/logind.conf.d/

INSTALLS += autostart logindconfig
