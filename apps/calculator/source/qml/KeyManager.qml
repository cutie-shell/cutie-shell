import QtQuick 2.4

QtObject {
    id: keyManager

    property bool clearEntryOperable: true
    property bool equalOperable: true
    property bool memoryClearOperable: true
    property bool memoryRecallOperable: true

    property var groupMap: ({})
    property string key
    property var keyMap: ({})
    
    property var masterList: [
        {group: "AddSub", signal: addSubPressed, keys: ["+", "-"]},
        {group: "Clear", signal: clearPressed, keys: ["c"]},
        {group: "ClearEntry", signal: clearEntryPressed, keys: ["ce"]},
        {group: "Digit", signal: digitPressed,
            keys: ["1", "2", "3", "4", "5", "6", "7", "8", "9"]},
        {group: "Equal", signal: equalPressed, keys: ["="]},
        {group: "Function", signal: functionPressed,
            keys: ["%", "acos", "asin", "atan", "cos",
                   "exp", "log", "sin", "sqr", "sqrt", "tan"]},
        {group: "MemoryClear", signal: memoryClearPressed,
            keys: ["mc", "cm"]},
        {group: "MemoryRecall", signal: memoryRecallPressed,
            keys: ["mr", "rm"]},
        {group: "MemoryUpdate", signal: memoryUpdatePressed,
            keys: ["m+", "m-", "ms", "sm"]},
        {group: "MulDiv", signal: mulDivPressed, keys: ["*", "/"]},
        {group: "Point", signal: pointPressed, keys: ["."]},
        {group: "Sign", signal: signPressed, keys: ["+/-", "±"]},
        {group: "Zero", signal: zeroPressed, keys: ["0"]},
    ]

    property var noopGroups: [
        // [state, equal-key-operable (or null for the default), noop-groups]
    ]
        
    property var noops

    property bool __setup: false
    
    signal addSubPressed()
    signal clearPressed()
    signal clearEntryPressed()
    signal digitPressed()
    signal equalPressed()
    signal functionPressed()
    signal memoryClearPressed()
    signal memoryRecallPressed()
    signal memoryUpdatePressed()
    signal mulDivPressed()
    signal pointPressed()
    signal signPressed()
    signal zeroPressed()

    onNoopsChanged: {
        var specialKeys = groupMap["ClearEntry"].concat(
                    groupMap["MemoryClear"]).concat(
                    groupMap["MemoryRecall"]);
        var noopKeys = [];
        for (var i = 0; i < noops.length; i++) {
            noopKeys = noopKeys.concat(groupMap[noops[i]]);
        }
        for (var key in keyMap) {
            if (specialKeys.indexOf(key) !== -1) {
                continue;
            }
            keyMap[key].noop = (noopKeys.indexOf(key) !== -1);
        }
    }
    
    function clear() {
        setup();
        key = 0;
        noops = currentNoops();
    }

    function currentNoops() {
        for (var i = 0; i < noopGroups.length; i++) {
            if (noopGroups[i][0].active) {
                var equalCheck = noopGroups[i][1];
                if (equalCheck === null) {
                    equalCheck = equalOperable; // Default.
                }
                var groups = noopGroups[i][2];
                return (equalCheck) ? groups : groups.concat(["Equal"]);
            }
        }
        return [];
    }
    
    function noop(uiKey) {
        return (supports(uiKey)) ? keyMap[uiKey.toLowerCase()].noop : true;
    }
    
    function process(uiKey) {
        var accepted = false;
        key = uiKey.toLowerCase();
        if (key in keyMap) {
            accepted = true;
            keyMap[key].signal();
            noops = currentNoops();
        }
        return accepted;
    }
    
    function setup() {
        if (__setup) {
            return;
        }
        var i;
        var key;
        var specialKeys;
        var qml = "import QtQuick 2.4;" +
                  "QtObject { property bool noop: false;" +
                  "property var signal }"
        for (i = 0; i < masterList.length; i++) {
            var obj = masterList[i];
            groupMap[obj.group] = obj.keys;
            for (var j = 0; j < obj.keys.length; j++) {
                key = obj.keys[j];
                keyMap[key] = Qt.createQmlObject(qml, sm, "KeyDetails");
                keyMap[key].signal = obj.signal;
            }
        }
        specialKeys = groupMap["ClearEntry"];
        for (i = 0; i < specialKeys.length; i++) {
            key = specialKeys[i];
            keyMap[key].noop = Qt.binding(
                        function() { return (!clearEntryOperable); });
        }
        specialKeys = groupMap["MemoryClear"];
        for (i = 0; i < specialKeys.length; i++) {
            key = specialKeys[i];
            keyMap[key].noop = Qt.binding(
                        function() { return (!memoryClearOperable); });
        }
        specialKeys = groupMap["MemoryRecall"];
        for (i = 0; i < specialKeys.length; i++) {
            key = specialKeys[i];
            keyMap[key].noop = Qt.binding(
                        function() { return (!memoryRecallOperable); });
        }
        __setup = true;
    }
    
    function supports(uiKey) {
        // We need to call setup() here because this function gets called
        // before Component.onCompleted() takes place, unfortunately.
        setup();
        return (uiKey.toLowerCase() in keyMap);
    }
}
