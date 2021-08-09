pragma Singleton

import QtQuick 2.4

QtObject {
    id: unitsSingleton

    property real pixelDensity
    property real scaleFactor: 1.0

    function dp(number) {
        return Math.round(number * ((pixelDensity * 25.4) / 160) * scaleFactor);
    }
}
