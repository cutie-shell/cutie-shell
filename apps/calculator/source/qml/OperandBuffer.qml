import QtQuick 2.4
import "." as App

QtObject {
    id: operandBuffer
    
    property bool clearable: (text !== "" && text !== "0")
    property double number: (text !== "") ? Number(text) : 0.0
    property string text: ""

    function append(digit) {
        text += digit;
    }
    
    function clear() {
        reset();
    }
    
    function reset() {
        text = "";
    }
    
    function show() {
        return App.Util.withTrailingPoint(text);
    }

    function swap(target, replacement) {
        var signed = (text.charAt(0) === "-");
        text = (signed) ? text.slice(1) : text;
        text = (text === target) ? replacement : text;
        text = (signed) ? "-" + text : text;
    }
    
    function toggleSign() {
        text = (text.charAt(0) === "-") ? text.slice(1) : "-" + text;
    }

    function update(value) {
        text = App.Util.stringify(value);
    }
}
