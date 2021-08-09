import QtQuick 2.4

QtObject {
    id: object

    default property alias data: object.__data
    property list<QtObject> __data
}
