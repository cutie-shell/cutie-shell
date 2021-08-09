pragma Singleton

import QtQuick 2.4

QtObject {
    id: util
    
    readonly property int significantDigits: 13

    readonly property var trailingPointRegExp: /\.$/
    readonly property var trailingZerosRegExp: /0+$/
    
    function stringify(value) {
        var newValue = value;
        if (value === undefined || value === null) {
            newValue = "";
        } else if (typeof value === "number") {
            newValue = value.toFixed(significantDigits);
            if (newValue.indexOf(".") !== -1) {
                newValue = newValue.replace(trailingZerosRegExp, "");
                newValue = newValue.replace(trailingPointRegExp, "");
            }
        }
        return newValue;
    }
    
    function withTrailingPoint(value) {
        var newValue = stringify(value);
        return (newValue.indexOf(".") === -1) ? newValue + "." : newValue;
    }
}
