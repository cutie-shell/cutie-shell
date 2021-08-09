import QtQuick 2.4
import QtQml.StateMachine 1.0 as DSM
import "." as App

DSM.StateMachine {
    id: sm

    property alias config: config

    readonly property string display: processor.displayText
    readonly property string expression: processor.expressionText
    readonly property string memory: processor.memoryText
    readonly property string result: processor.resultText

    readonly property var noop: keyManager.noop
    readonly property var process: keyManager.process
    readonly property var supports: keyManager.supports

    function accumulate() {
        processor.accumulate(keyManager.key);
    }

    function clear() {
        keyManager.clear();
        processor.clear();
    }

    function clearEntry() {
        keyManager.clear();
        processor.clearEntry();
    }

    function clearError() {
        var temp = keyManager.key;
        clear();
        keyManager.key = temp;
    }

    onStarted: keyManager.clear();

    onStopped: clear();

    Component.onCompleted: clear();

    QtObject {
        id: config

        property bool allowEqualKeyShortcut: false
        property bool equalKeyRepeatsLastOperation: false
    }

    App.KeyManager {
        id: keyManager

        clearEntryOperable: processor.clearable
        equalOperable: processor.equalable
        memoryClearOperable: processor.memorable
        memoryRecallOperable: processor.memorable && !memoryRecallState.active

        noopGroups: [
            // [state, equal-key-operable (or null for default), noop-groups]
            [digitState, null, []],
            [errorState, false,
                ["AddSub", "Function", "MemoryUpdate", "MulDiv", "Sign"]],
            [functionState, null, []],
            [memoryRecallState, null, ["MemoryRecall"]],
            [memoryUpdateState, null, []],
            [operatorState, config.allowEqualKeyShortcut,
                ["Function", "MemoryUpdate", "Sign"]],
            [pointState, null, ["Point"]],
            [resultState, config.equalKeyRepeatsLastOperation, []],
            [signState, null, []],
            [zeroState, null, ["Zero"]],
        ]
    }

    App.Processor {
        id: processor

        equalKeyRepeatsLastOperation: config.equalKeyRepeatsLastOperation
    }

    initialState: clearState

    DSM.State {
        id: clearState

        initialState: operandState

        DSM.SignalTransition {
            signal: keyManager.clearPressed
            targetState: clearState
            onTriggered: clear();
        }
        DSM.SignalTransition {
            signal: keyManager.clearEntryPressed
            guard: (keyManager.clearEntryOperable)
            targetState: zeroState
            onTriggered: clearEntry();
        }
        DSM.SignalTransition {
            signal: processor.error
            targetState: errorState
        }
        DSM.SignalTransition {
            signal: keyManager.memoryClearPressed
            guard: (keyManager.memoryClearOperable)
            onTriggered: processor.clearMemory();
        }
        DSM.SignalTransition {
            signal: keyManager.memoryRecallPressed
            guard: (keyManager.memoryRecallOperable)
            targetState: memoryRecallState
        }
        DSM.SignalTransition {
            signal: keyManager.signPressed
            guard: (processor.signable)
            onTriggered: processor.toggleSign();
        }

        DSM.State {
            id: operandState

            initialState: accumulateState

            onEntered: processor.setupOperandState();

            DSM.SignalTransition {
                signal: keyManager.addSubPressed
                targetState: operatorState
                onTriggered: processor.calculateAll(false);
            }
            DSM.SignalTransition {
                signal: keyManager.equalPressed
                guard: (keyManager.equalOperable)
                targetState: resultState
            }
            DSM.SignalTransition {
                signal: keyManager.functionPressed
                targetState: functionState
            }
            DSM.SignalTransition {
                signal: keyManager.memoryUpdatePressed
                targetState: memoryUpdateState
            }
            DSM.SignalTransition {
                signal: keyManager.mulDivPressed
                targetState: operatorState
                onTriggered: processor.calculateLast();
            }

            DSM.State {
                id: accumulateState

                initialState: zeroState

                DSM.SignalTransition {
                    signal: keyManager.digitPressed
                    onTriggered: accumulate();
                }
                DSM.SignalTransition {
                    signal: keyManager.pointPressed
                    targetState: pointState
                }
                DSM.SignalTransition {
                    signal: keyManager.zeroPressed
                    onTriggered: accumulate();
                }

                DSM.State {
                    id: digitState

                    onEntered: processor.accumulateFirstDigit(keyManager.key);
                }

                DSM.State {
                    id: pointState

                    onEntered: processor.accumulateFirstPoint(keyManager.key);

                    DSM.SignalTransition {
                        signal: keyManager.pointPressed
                    }
                }

                DSM.State {
                    id: zeroState

                    onEntered: accumulate();

                    DSM.SignalTransition {
                        signal: keyManager.digitPressed
                        targetState: digitState
                    }
                    DSM.SignalTransition {
                        signal: keyManager.zeroPressed
                    }
                }
            } // End of accumulateState

            DSM.State {
                id: manipulateState

                DSM.SignalTransition {
                    signal: keyManager.digitPressed
                    targetState: digitState
                    onTriggered: processor.resetBeforeAccumulate();
                }
                DSM.SignalTransition {
                    signal: keyManager.pointPressed
                    targetState: pointState
                    onTriggered: processor.resetBeforeAccumulate();
                }
                DSM.SignalTransition {
                    signal: keyManager.zeroPressed
                    targetState: zeroState
                    onTriggered: processor.resetBeforeAccumulate();
                }

                DSM.State {
                    id: functionState

                    onEntered: processor.applyFunction(keyManager.key);

                    DSM.SignalTransition {
                        signal: keyManager.functionPressed
                        onTriggered: processor.applyFunction(keyManager.key);
                    }
                }

                DSM.State {
                    id: memoryRecallState

                    onEntered: processor.recallMemory();

                    DSM.SignalTransition {
                        signal: keyManager.memoryRecallPressed
                    }
                }

                DSM.State {
                    id: memoryUpdateState

                    onEntered: processor.updateMemory(keyManager.key);

                    DSM.SignalTransition {
                        signal: keyManager.memoryUpdatePressed
                        onTriggered: processor.updateMemory(keyManager.key);
                    }
                }

                DSM.State {
                    id: signState

                    onEntered: processor.toggleSign();
                }
            } // End of manipulateState
        } // End of operandState

        DSM.State {
            id: operationState

            DSM.SignalTransition {
                signal: keyManager.digitPressed
                targetState: digitState
            }
            DSM.SignalTransition {
                signal: keyManager.pointPressed
                targetState: pointState
            }
            DSM.SignalTransition {
                signal: keyManager.signPressed
            }
            DSM.SignalTransition {
                signal: keyManager.zeroPressed
                targetState: zeroState
            }

            DSM.State {
                id: errorState

                onEntered: processor.displayError();

                onExited: clearError();

                DSM.SignalTransition {
                    signal: processor.error
                }
            } // End of errorState

            DSM.State {
                id: operatorState

                onEntered: {
                    processor.setupOperatorState();
                    processor.updateOperator(keyManager.key);
                }

                DSM.SignalTransition {
                    signal: keyManager.addSubPressed
                    onTriggered: processor.updateOperator(keyManager.key);
                }
                DSM.SignalTransition {
                    signal: keyManager.equalPressed
                    targetState: resultState
                    guard: (config.allowEqualKeyShortcut)
                    onTriggered: processor.setupEqualShortcut();
                }
                DSM.SignalTransition {
                    signal: keyManager.mulDivPressed
                    onTriggered: processor.updateOperator(keyManager.key);
                }
            } // End of operatorState

            DSM.State {
                id: resultState

                onEntered: {
                    processor.setupResultState();
                    processor.calculateAll(true);
                }

                onExited: processor.resetAfterResult();

                DSM.SignalTransition {
                    signal: keyManager.addSubPressed
                    targetState: operatorState
                    onTriggered: processor.updateResult(false);
                }
                DSM.SignalTransition {
                    signal: keyManager.equalPressed
                    guard: (config.equalKeyRepeatsLastOperation)
                    onTriggered: processor.repeatEqual();
                }
                DSM.SignalTransition {
                    signal: keyManager.functionPressed
                    targetState: functionState
                    onTriggered: processor.updateResult(true);
                }
                DSM.SignalTransition {
                    signal: keyManager.memoryUpdatePressed
                    targetState: memoryUpdateState
                    onTriggered: processor.updateResult(true);
                }
                DSM.SignalTransition {
                    signal: keyManager.mulDivPressed
                    targetState: operatorState
                    onTriggered: processor.updateResult(false);
                }
                DSM.SignalTransition {
                    signal: keyManager.signPressed
                    targetState: signState
                    onTriggered: processor.updateResult(true);
                }
            } // End of resultState
        } // End of operationState
    } // End of clearState
}
