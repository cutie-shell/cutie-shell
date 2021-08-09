import QtQuick 2.4
import "." as App

App.Object {
    id: processor

    readonly property bool clearable: operandBuffer.clearable
    readonly property bool equalable: operators.length
    readonly property bool memorable: memory.active
    readonly property bool signable: operandBuffer.text !== ""

    property bool equalKeyRepeatsLastOperation: false

    property string displayText
    property string errorMessage
    property string expressionText: expressionBuilder.text
    property string memoryText: memory.text
    property string resultText: App.Util.stringify(calculationResult)

    property double calculationResult
    property double operand

    property string lastOperand
    property string lastOperator

    property var operands: []
    property var operators: []

    signal error()

    onCalculationResultChanged: validate(calculationResult);

    onOperandChanged: validate(operand);

    function accumulate(key) {
        operandBuffer.append(key);
        expressionBuilder.update(operandBuffer.text);
    }

    function accumulateFirstDigit(key) {
        operandBuffer.swap("0", "");
        accumulate(key);
    }

    function accumulateFirstPoint(key) {
        operandBuffer.swap("", "0");
        accumulate(key);
    }

    function applyFunction(key) {
        expressionBuilder.applyMathFunction(key);
        operand = operandBuffer.number;
        var mathFunction
        switch (key) {
            default:
                mathFunction = Math[key];
                break;
            case "%":
                mathFunction = function() { return operand / 100 };
                break;
            case "sqr": // We have to create our own function for square.
                mathFunction = function() { return operand * operand };
                break;
        }
        operand = mathFunction(operand);
        operandBuffer.update(operand);
        if (!operators.length) {
            operands.pop();
            operands.push(operand);
            calculationResult = operand;
        }
    }

    function calculateAll(updateExpression) {
        var num = operandBuffer.number;
        var operator;
        if (operators.length === 2) {
            operand = operands.pop();
            operator = operators.pop();
            switch (operator) {
                case "*":
                    operand *= num;
                    break;
                case "/":
                    operand /= num;
                    break;
            }
            num = operand;
            if (equalKeyRepeatsLastOperation) {
                operandBuffer.update(operand);
            }
        }
        if (operators.length === 1) {
            operand = operands.pop();
            operator = operators.pop();
            switch (operator) {
                case "+":
                    operand += num;
                    break;
                case "-":
                    operand -= num;
                    break;
                case "*":
                    operand *= num;
                    break;
                case "/":
                    operand /= num;
                    break;
            }
        } else {
            operands.pop();
            operand = operandBuffer.number;
        }
        operands.push(operand);
        calculationResult = operand;
        if (updateExpression) {
            expressionBuilder.push("=");
            expressionBuilder.push(calculationResult);
        }
        operators = operators;  // To trigger any bindings to this list.
    }

    function calculateLast() {
        if (!operands.length) {
            operand = operandBuffer.number;
        } else {
            operand = operands.pop();
            var operator = operators.pop();
            switch (operator) {
                case "*":
                    operand *= operandBuffer.number;
                    break;
                case "/":
                    operand /= operandBuffer.number;
                    break;
                case "+": case "-":
                    operands.push(operand);
                    operators.push(operator);
                    operand = operandBuffer.number;
                    break;
            }
        }
        operands.push(operand);
        operators = operators;  // To trigger any bindings to this list.
    }

    function clear() {
        calculationResult = 0.0;
        displayText = "";
        errorMessage = "ERROR";
        expressionBuilder.reset();
        operandBuffer.reset();
        operands.length = 0;
        operators.length = 0;
    }

    function clearEntry() {
        expressionBuilder.pop();
        operandBuffer.clear();
    }

    function clearMemory() {
        memory.clear();
    }

    function displayError() {
        displayText = errorMessage;
        operandBuffer.reset();
    }

    function recallMemory() {
        expressionBuilder.pop();
        operandBuffer.update(memory.recall());
        expressionBuilder.push(operandBuffer.text);
    }

    function repeatEqual() {
        operators[0] = lastOperator;
        operators = operators;  // To trigger any bindings to this list.
        calculateAll(true);
    }

    function resetBeforeAccumulate() {
        expressionBuilder.pop();
        operandBuffer.clear();
    }

    function resetAfterResult() {
        lastOperator = "";
        expressionBuilder.clear();
        operandBuffer.clear();
    }

    function setupEqualShortcut() {
        operandBuffer.update(operands[0]);
//        operand2 = 0.00;
//        operator2 = "";
    }

    function setupOperandState() {
        displayText = Qt.binding(operandBuffer.show);
        if (operandBuffer.text === "") {
            expressionBuilder.push("");
        }
    }

    function setupOperatorState() {
        lastOperand = operandBuffer.text
        displayText = Qt.binding(showOperatorState);
        operandBuffer.reset();
    }

    function setupResultState() {
        displayText = Qt.binding(showResultState);
        lastOperator = (operators.length) ? operators[0] : "";
    }

    function showOperatorState() {
        var value = (operators.length === 2) ? lastOperand : operands[0];
        return App.Util.withTrailingPoint(value);
    }

    function showResultState() {
        return App.Util.withTrailingPoint(calculationResult);
    }

    function toggleSign() {
        operandBuffer.toggleSign();
        expressionBuilder.update(operandBuffer.text);
    }

    function updateMemory(key) {
        memory.update(key, operandBuffer.number);
    }

    function updateOperator(key) {
        if (operators.length === operands.length) {
            expressionBuilder.pop();
            operators.pop();
        }
        operators.push(key);
        expressionBuilder.push(key);
        operators = operators;  // To trigger any bindings to this list.
    }

    function updateResult(updateOperandBuffer) {
        expressionBuilder.push(calculationResult);
        if (updateOperandBuffer) {
            operandBuffer.update(calculationResult);
        }
    }

    function validate(num) {
        if (!isFinite(num)) {
            expressionBuilder.error();
            processor.error();
        }
    }

    App.ExpressionBuilder {
        id: expressionBuilder
    }

    App.Memory {
        id: memory
    }

    App.OperandBuffer {
        id: operandBuffer

        onNumberChanged: processor.validate(number);
    }
}
