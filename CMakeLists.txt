cmake_minimum_required(VERSION 3.16)
project(cutie-shell VERSION 1.0 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)

include( GNUInstallDirs )

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick Network Qml DBus)

set(cutie-shell_SOURCES 
        src/settings.cpp 
        src/hwbuttons.cpp 
        src/notifications.cpp 
        src/settings.h 
        src/hwbuttons.h 
        src/notifications.h 
	src/main.cpp 
)

qt6_add_resources(APP_RESOURCES 
	${CMAKE_SOURCE_DIR}/src/qml/qml.qrc 
	${CMAKE_SOURCE_DIR}/icons/icons.qrc 
        ${CMAKE_SOURCE_DIR}/sounds/sounds.qrc)

qt_add_dbus_interface(cutie-shell_SOURCES src/org.cutie_shell.xml cutie_shell_interface)
qt_add_dbus_interface(cutie-shell_SOURCES src/org.freedesktop.DBus.xml dbus_interface)
qt_add_dbus_interface(cutie-shell_SOURCES src/org.freedesktop.Notifications.xml notifications_interface)
qt_add_dbus_adaptor(cutie-shell_SOURCES src/org.freedesktop.Notifications.xml notifications.h Notifications NotificationsAdaptor)

qt_add_executable(cutie-ui-io ${cutie-shell_SOURCES} ${APP_RESOURCES})

target_include_directories(cutie-ui-io PUBLIC src)

target_link_libraries(cutie-ui-io PUBLIC Qt::Core Qt::Gui Qt::GuiPrivate Qt::DBus Qt::Quick Qt::Network Qt::Qml)

install(TARGETS cutie-ui-io RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}")
install(DIRECTORY atmospheres/atmospheres DESTINATION "${CMAKE_INSTALL_DATADIR}")
install(DIRECTORY src/qml/layouts DESTINATION "${CMAKE_INSTALL_DATADIR}/cutie-keyboard")
install(DIRECTORY src/qml/kbdstyle/QtQuick/VirtualKeyboard/Styles/cutie DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt6/qml/QtQuick/VirtualKeyboard/Styles/")
install(FILES logind.conf.d/10-cutie.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/systemd/logind.conf.d")
install(FILES android-service@hwcomposer.service.d/20-cutie.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/systemd/system/android-service@hwcomposer.service.d")
