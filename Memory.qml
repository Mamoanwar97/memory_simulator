import QtQuick 2.0

Rectangle {

    id : memory
    width: 300
    height: parent.height

    border.color: "red"
    border.width: 5
    property int totalSize: 1

    // just to clear them next iteration
    property var segments: []

    function addSegment(segment)
    {
        var address = (segment.seg_address / memory.totalSize) * memory.height;
        console.log("y_address:",segment.seg_address ,memory.totalSize , memory.height);

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
            for(var j =0 ; j < segments.length; j++) {
                memory.addSegment(segments[i]);
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
