import QtQuick 2.0

Rectangle {
    width: parent.width
    color: "gray"

    border.width: 2
    border.color: "green"
    Row {
        anchors.centerIn: parent
        Text {
            id: process
            text: ""
        }
        Text {
            id: segment
            text: ""
        }
    }
}
