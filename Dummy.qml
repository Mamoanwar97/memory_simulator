import QtQuick 2.0

Rectangle {
    id:rect
    color: "#3a4750"
    width: parent.width
    border.width: 2
    border.color: "#eeeeee"
    property int index: -1
    Text {
        id: text
        text: qsTr("Dummy")
        color: "#eeeeee"
        anchors.centerIn: parent
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            rect.color =  "#eeeeee"
            text.color =  "#3a4750"
        }
        onExited: {
            text.color =  "#eeeeee"
            rect.color =  "#3a4750"
        }
        onDoubleClicked: {
            MemoryBackend.deallocate_dummies(index);
        }
    }
}
