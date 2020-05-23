import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0

Window {
    visible: true
    width: 1280
    height: 720
    minimumHeight: 720
    minimumWidth: 1280
    title: qsTr("Hello World")
    id : windowRay2
    color: "#303841"

    Component.onCompleted: {
    }

    TableView {
        id:mytable
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
        TabBar {
            property int checkedProcess
            id:tabBar
            anchors.bottom:  mytable.top
        }
        Component {

            id: tabButton
            TabButton {
                text: ""
                onClicked: {fillSegmentationTable(text[1]);tabBar.checkedProcess=text[1];}
            }
        }
        Component.onCompleted: {
        }

        model: processtable

        ListModel {
            id: processtable

            function addSegment(SegmentName,SegmentSize,SegmentAddress)
            {
                processtable.append({"Name": SegmentName,"Size": SegmentSize,"Address":SegmentAddress})
            }
            function addProcess()
            {
                for(var i=0;i<10;i++)
                {
                    processtable.append({"Name": "","Size": "","Address":""})
                }
            }
        }
    }

    TableView {
        id:inputTable
        y:parent.height
        width: parent.width/2.84
        anchors.verticalCenter : parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        visible: false
        Repeater {
            id: repeater
            model:5
            Row {
                y:index*30
                id:row
                Rectangle{
                    x:0
                    width: inputTable.width/2
                    height:30
                    border.width: 2
                    border.color:"grey"
                    TextInput{
                        anchors.fill:parent
                        verticalAlignment: Qt.AlignVCenter
                        horizontalAlignment: Qt.AlignHCenter
                        text: ""
                        onTextChanged: MemoryBackend.set_inputProcess_segment_Name(index,text)
                    }
                }
                Rectangle{
                    x:350
                    width: inputTable.width/2
                    height:30
                    border.width: 2
                    border.color: "grey"
                    TextInput{
                        anchors.fill:parent
                        verticalAlignment: Qt.AlignVCenter
                        horizontalAlignment: Qt.AlignHCenter
                        onTextChanged: MemoryBackend.set_inputProcess_segment_size(index,Number(text))
                    }
                }

            }

        }
    }






    Row {
        Rectangle {
            width: 300
            height: windowRay2.height
            Memory {
                id:memory
            }
        }

        // just for testing
        Button {
            text: "clear"
//            onClicked: {memory.clear();processtable.clear();tabBar.clear();}
            onClicked: {repeater.model=8;}
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
            text: "Hole"
            property int i : 0
            onClicked: {
                if(memory.totalSize == 1)
                {
                    console.log("Set the Size and Type");
                    return;
                }

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
            text: "Start"
            onClicked: MemoryBackend.allocate_dummies();
        }

    }
    Button {
        id:addProcess
        text: "Add Process"
        anchors.horizontalCenter: mytable.horizontalCenter
        anchors.top: mytable.bottom
        onClicked: {
            //processtable.clear();
            mytable.visible=false;
            inputTable.visible=true;
            MemoryBackend.set_inputProcess();

        }
    }
    Button {
        id:deallocate
        text: "Deallocate"
        anchors.left: addProcess.right
        anchors.verticalCenter: addProcess.verticalCenter
        onClicked: {processtable.clear();
            clearTab(tabBar.checkedProcess);
            MemoryBackend.removeProcess(tabBar.checkedProcess);
        }
    }
    Button {
        id:verify
        text: "Allocate"
        anchors.right: addProcess.left
        anchors.verticalCenter: addProcess.verticalCenter
        onClicked: {
            mytable.visible=true;
            inputTable.visible=false;
            MemoryBackend.addProcess();
            if( MemoryBackend.getNumProcess() != 0 )
            {
                var Button1=tabButton.createObject(tabBar,{"text":"P"+(MemoryBackend.getNumProcess()-1)})
                tabBar.addItem(Button1);
                inputTable.clear();
                return;
            }
            else
            {
                console.log("Can not appent empty process")
            }
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
    }
    function fillSegmentationTable(processNumber)
    {
        processtable.clear();
        var segments = MemoryBackend.getProcess(processNumber);
        for(var j =0 ; j < segments.length; j++) {
            if (segments[j].seg_size != 0)
                processtable.set(j,{"Name": segments[j].name,"Size": segments[j].seg_size,"Address":segments[j].seg_address})
        }
    }
    function clearTab(process)
    {
        tabBar.removeItem(process);

    }
    function getinput()
    {
        for(var j =0 ; j < 5; j++) {


        }

    }

}
