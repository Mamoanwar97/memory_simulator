import QtQuick 2.0

Rectangle {

    id : memory
    width: parent.width
    height: parent.height

    border.color: "#303841"
    border.width: 2
    property double totalSize: 1

    // just to clear them next iteration
    property var segments: []

    function addSegment(segment,id)
    {

        var newSegment = Qt.createComponent("Segment.qml");
        var Segment    = newSegment.createObject(memory, {
                                     height : Qt.binding(function() { return segment.seg_size / memory.totalSize * memory.height}),
                                     y :  Qt.binding(function() { return segment.seg_address / memory.totalSize * memory.height}),
                                     name: "P" + id.toString() +  " Size=" + segment.seg_size.toString()
                                        });
        memory.segments.push(Segment);
    }
    function getSegmentName(segment)
    {
        memory.segments.valueOf(segment);
    }


    function addDummySegment( dummy , j )
    {
        var newSegment = Qt.createComponent("Dummy.qml");
        var Segment    = newSegment.createObject(memory, {
                                           height : Qt.binding(function() { return dummy.seg_size / memory.totalSize * memory.height}),
                                           y :  Qt.binding(function() { return dummy.seg_address / memory.totalSize * memory.height}),
                                           index : j
                                        })
        memory.segments.push(Segment);
    }

    function draw( processes,dummies)
    {
        memory.clear();

        for (var i =0 ; i < processes.length; i ++)
        {
            var segments = processes[i].getSegments();
            console.log(segments);
            for(var j =0 ; j < segments.length; j++) {
                memory.addSegment(segments[j],processes[i].getID());
            }
        }

        for(var j =0 ; j <dummies.length; j++) {
            memory.addDummySegment(dummies[j],j);
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
