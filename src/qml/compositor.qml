/*
    Copyright (C) 2019-2020 Ping-Hsun "penk" Chen
    Copyright (C) 2020 Chouaib Hamrouche
    Contact: hello@cutiepi.io
    This file is part of CutiePi shell of the CutiePi project.
    CutiePi shell is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    CutiePi shell is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with CutiePi shell. If not, see <https://www.gnu.org/licenses/>.
*/

import QtQuick 2.14
import QtWayland.Compositor 1.14

WaylandCompositor {
    id: comp
    useHardwareIntegrationExtension:true
    Screen { id: screen }

    function addApp(name, exec, icon) {
        launcherApps.append({
                        appName: name,
                        appExec: exec,
                        appIcon: icon
                    })
    }

    function addNotification(title, body, id) {
        notifications.append({title: title, body: body, id: id});
    }

    function delNotification(id) {
        for (let c_i = 0; c_i < notifications.count; c_i++){
            if (notifications.get(c_i).id === id)
                notifications.remove(c_i);
        }
    }

    function lock() {
        screen.lock();
    }

    function addModem(n) {
        screen.addModem(n);
    }

    function setCellularName(n, name) {
        screen.setCellularName(n, name);
    }

    function setCellularStrength(n, strength) {
        screen.setCellularStrength(n, strength);
    }

    function setWifiName(name) {
        screen.setWifiName(name);
    }

    function setWifiStrength(strength) {
        screen.setWifiStrength(strength);
    }
    
    XdgShell {
        onToplevelCreated: {
            screen.handleShellSurface(xdgSurface, toplevel)
        }
    }
	XdgDecorationManagerV1 {
		preferredMode: XdgToplevel.ServerSideDecoration
	}
    ListModel { id: shellSurfaces }
    ListModel { id: notifications }
    ListModel { id: launcherApps }
    
    TextInputManager {}
}
