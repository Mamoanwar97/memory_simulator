import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0

Window {
    visible: true
    width: 1280
    height: 720
    title: qsTr("Hello World")
    id : windowRay2

    Row {
        Rectangle {
            width: 400
            height: windowRay2.height
            Memory {
                id:memory
            }
        }

        // just for testing
        Button {
            text: "clear"
            onClicked: memory.clear();
        }
        Button {
            text: "Size-Type"
            onClicked: {
                MemoryBackend.set_allocation_type("first");
                MemoryBackend.set_size(1000);
            }
        }

        Button {
            id : btn
            text: "Process"
            onClicked: {
                var process = MemoryBackend.createProcess();
                var segment = MemoryBackend.createSegment();
                console.log(process,segment);
                segment.seg_size = 100;
                segment.seg_address = 17;
                segment.name = "ray2";
                process.addSegment(segment);
                segment.name = "ray2222";
                process.addSegment(segment);

                MemoryBackend.add_process(process);


            }
        }
        Button {
            text: "Hole"
            onClicked: {
                var myHole = MemoryBackend.createHole();
                myHole.hole_address = 70;
                myHole.hole_size = 100;

                MemoryBackend.add_hole(myHole)
            }
        }
    }

    Component.onCompleted: {
        memory.addSegment(50);
        memory.addSegment(450);
        memory.addDummySegment(150);
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
            var segments = processes[i].getSegments();
            for(var j =0 ; j < segments.length; j++) {
                console.log("seg",j,segments[j].seg_size);
            }
            
        }
    }

    function slotReceiveDummies (dummies) {
        for(var j =0 ; j <dummies.length; j++) {
            console.log("seg",j,dummies[j].seg_size);

        }
    }
}
