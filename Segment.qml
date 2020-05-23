import QtQuick 2.0

Rectangle {
    width: parent.width
    color: "#00adb5"
    property string name: ""
    border.width: 2
    border.color: "#eeeeee"
    Row {
        anchors.centerIn: parent
        Text {
            id: text
            text: name
            color: "#eeeeee"
        }
    }
}
