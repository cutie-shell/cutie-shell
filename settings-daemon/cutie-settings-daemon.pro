QT += core dbus

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        backlight.cpp \
        main.cpp

HEADERS += \
        backlight.h

LIBS += -ludev

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

backlight.files = ../com.github.CutiePiShellCommunityProject.xml
backlight.source_flags = -l Backlight
backlight.header_flags = -l Backlight -i backlight.h

DBUS_ADAPTORS += backlight
DBUS_INTERFACES += \
        backlight