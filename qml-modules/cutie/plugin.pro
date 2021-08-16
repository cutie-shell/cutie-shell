TEMPLATE = lib
CONFIG += qt plugin
QT += qml quick dbus

DESTDIR = Cutie
TARGET  = qmlcutieplugin

SOURCES += plugin.cpp

HEADERS += plugin.h

lib.files = Cutie
lib.path = $$[QT_INSTALL_QML]
INSTALLS += lib
DBUS_INTERFACES += ../../com.github.CutiePiShellCommunityProject.xml