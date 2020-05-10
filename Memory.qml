import QtQuick 2.0

Rectangle {

    id : memory
    width: 300
    height: parent.height

    border.color: "red"
    border.width: 5
    property double totalSize: 1

    // just to clear them next iteration
    property var segments: []

    function addSegment(segment)
    {
        var ratio = segment.seg_address / memory.totalSize;
        var address = ratio * memory.height;
        console.log("y_address:",segment.seg_address ,memory.totalSize , memory.height,"_____ ratio",ratio);

        var newSegment = Qt.createComponent("Segment.qml");
        var Segment    = newSegment.createObject(memory, {
                                            height : segment.seg_size,
                                            y :  address
                                        });

        memory.segments.push(Segment);
    }


    function addDummySegment( dummy )
    {
        var newSegment = Qt.createComponent("Dummy.qml");
        var Segment    = newSegment.createObject(memory, {
                                            height : dummy.seg_size,
                                            y : dummy
                                        })
        memory.segments.push(Segment);
    }

    function draw( processes,dummies)
    {
        memory.clear();

        for (var i =0 ; i < processes.length; i ++)
        {
            var segments = processes[i].getSegments();
            console.log("segments____",segments);

            for(var j =0 ; j < segments.length; j++) {
                memory.addSegment(segments[j]);
            }
        }

        for(var j =0 ; j <dummies.length; j++) {
            memory.addDummySegment(dummies[i]);
        }
    }

    function clear()
    {
        for (var i = 0 ; i < memory.segments.length; i++)
        {
            memory.segments[i].destroy();
        }
        memory.segments = []

    }
}
