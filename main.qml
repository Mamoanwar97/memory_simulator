import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
Window {
    visible: true
    width: 1280
    height: 720
    title: qsTr("Hello World")
    id : windowRay2

    Component.onCompleted: {

    }
    TableView {
           y:parent.height
           width: parent.width/2.84
           anchors.verticalCenter : parent.verticalCenter
           anchors.horizontalCenter: parent.horizontalCenter

           TableViewColumn {
               role: "Name"
               title: "Segmant Name"
               width: 150
           }
           TableViewColumn {
               role: "Address"
               title: "Segmant Address"
               width: 150
           }

           TableViewColumn{
               role: "Size"
               title: "Segmant Limit"
               width: 150
           }

           Component.onCompleted: {
              /* for (var i = 0; i < 10; i++) {
                   process.addSegment(i,i,i);
               }*/

           }

           model: processtable

           ListModel {
               id: processtable
               function addSegment(SegmentName,SegmentSize,SegmentAddress)
               {
                  processtable.append({"Name": SegmentName,"Size": SegmentSize,"Address":SegmentAddress})

               }
           }
       }

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
            onClicked: {memory.clear();processtable.clear();}
        }
        Button {
            text: "Size-Type"
            onClicked: {
                MemoryBackend.set_allocation_type("first");
                MemoryBackend.set_size(1000);
                memory.totalSize = 1000;
            }
        }

        Button {
            id : btn
            text: "Process"
            onClicked: {
                var process = MemoryBackend.createProcess();
                var segment = MemoryBackend.createSegment();
                // segment 0
                segment.seg_size = 70;
                segment.name ="code";
                process.addSegment(segment);
                segment.seg_size = 100;
                segment.name ="Data";
                process.addSegment(segment);
                segment.seg_size = 150;
                segment.name ="Variables";
                process.addSegment(segment);
//                // segment 1
//                segment.seg_size = 30;
//                process.addSegment(segment);

                MemoryBackend.add_process(process);
                for (var i = 0; i < process.size() ;i++) {
                                   processtable.addSegment(process.getSegmentName(i),process.getSegmentSize(i),process.getSegmentAddress(i));
                               }

            }
        }

        Button {
            text: "Hole"
            property int i : 0
            onClicked: {
                if (i < memory.totalSize-100 ) {

                    if (i != 500 && i !=700) {
                        var myHole = MemoryBackend.createHole();
                        myHole.hole_address = i ;
                        myHole.hole_size = 100;

                        MemoryBackend.add_hole(myHole)
                    }
                    i = i +100;
                }
            }
        }
        Button {
            text: "Dymmy"
            onClicked: MemoryBackend.allocate_dummies();
        }
    }


    Connections {
        target: MemoryBackend;
        onUpdateMemoryQml :
        {
//            updateDrawing(processes,dummies);
            memory.draw(processes,dummies);
        }
    }

    function updateDrawing (processes,dummies) {
        for (var i =0 ; i < processes.length; i ++)
        {
            console.log("######## Process",i);
            var segments = processes[i].getSegments();
            for(var j =0 ; j < segments.length; j++) {
                console.log("seg address:",i,segments[j].seg_address, ",size:",segments[j].seg_size);
            }
            
        }
//        console.log("Dummiesssssssssssss");
//        for(var j =0 ; j <dummies.length; j++) {
//            console.log("dummy",j,dummies[j].seg_size);
//        }

    }

}
