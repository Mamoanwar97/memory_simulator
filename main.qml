import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    id : windowRay2

    Row{
        Rectangle {
            width: 400
            height: windowRay2.height
            Memory{
                id:memory
            }
        }
        Button {
            id : btn
            text: "Send"
            width: 300
            height: 200
            onClicked: {
                console.log("before :",memory.segments);
                memory.clear();
                console.log("after :",memory.segments);

                MemoryBackend.set_allocation_type("first");
                MemoryBackend.set_size(1000);

            }
        }
    }
    Component.onCompleted: {
        memory.addSegment(50);
        memory.addSegment(450);
        memory.addDummySegment(150);


        MemoryBackend.set_allocation_type("first");
        MemoryBackend.set_size(1000);
    }

    Connections {
        target: MemoryBackend;
        onSendProcesses : slotReceiveProcesses(processes);
        onSendDummies   : slotReceiveDummies(dummies);
    }

    function slotReceiveProcesses (processes) {
        for (var i =0 ; i < processes.length; i ++)
        {
            console.log("######## Process",i);
            for(var j =0 ; j < processes[i].segments.length; j++) {
                console.log("seg",j,processes[i].segments[j].seg_size);
            }
            
        }
    }

    function slotReceiveDummies (dummies) {
        for(var j =0 ; j <dummies.length; j++) {
            console.log("seg",j,dummies[j].seg_size);

        }
    }
}
