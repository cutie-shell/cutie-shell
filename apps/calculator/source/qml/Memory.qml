import QtQuick 2.4
import "." as App

QtObject {
    id: memory
    
    property bool active: false
    property string text: (!active) ? "" : App.Util.stringify(value)
    property double value: 0.0
    
    function clear() {
        active = false;
        value = 0.0;
    }
    
    function recall() {
        return value;
    }
    
    function update(key, num) {
        active = true;
        switch (key) {
            case "ms":
            case "sm":
                value = num;
                break;
            case "m+":
                value += num;
                break;
            case "m-":
                value -= num;
                break;
        }
    }
}
