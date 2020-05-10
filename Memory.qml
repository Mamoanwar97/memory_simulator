import QtQuick 2.0

Rectangle {

    id : memory
    width: 300
    height: parent.height

    border.color: "red"
    border.width: 5
    property int totalSize: 500

    // just to clear them next iteration
    property var segments: []

    function addSegment(segment)
    {
        var newSegment = Qt.createComponent("Segment.qml");
        var Segment    = newSegment.createObject(memory, {
                                            height : segment,
                                            y : segment
                                        });

        memory.segments.push(Segment);
    }


    function addDummySegment( dummy )
    {
        var newSegment = Qt.createComponent("Dummy.qml");
        var Segment    = newSegment.createObject(memory, {
                                            height : dummy,
                                            y : dummy
                                        })
        memory.segments.push(Segment);
    }

    function draw( segments , dummies)
    {
        memory.clear();

        for( var i = 0 ; i < segments.length ; i ++)
        {
            memory.addSegment(segments[i]);
        }
        for( var i = 0 ; i < dummies.length ; i ++)
        {
            memory.addDummySegment(dummies[i]);
        }
    }

    function clear()
    {
        for (var i = 0 ; i < memory.segments.length; i++)
        {
            memory.segments[i].destroy();
        }
        memory = []

    }
}
