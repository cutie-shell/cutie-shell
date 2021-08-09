import QtQuick 2.4
import "." as App

QtObject {
    id: expressionBuilder
    
    property bool errorMode: false
    
    property string text: ""
    
    property var __buffer: []

    signal error()
    
    onError: errorMode = true;
    
    function applyMathFunction(key) {
        if (key === "%") {
            push("(%1%2)".arg(pop()).arg(key));
        } else {
            push("%1(%2)".arg(key).arg(pop()));
        }
    }

    function clear() {
        if (!errorMode) {
            __buffer.length = 0;
            _updateText();
        }
    }
    
    function pop() {
        var value = __buffer.pop();
        _updateText();
        return value;
    }
    
    function push(value) {
        __buffer.push(App.Util.stringify(value));
        _updateText();
    }
    
    function reset() {
        errorMode = false;
        clear();
    }
    
    function update(value) {
        __buffer.pop();
        push(value.replace(App.Util.trailingPointRegExp, ""));
    }

    function _updateText() {
        text = __buffer.join(" ");
    }
}
