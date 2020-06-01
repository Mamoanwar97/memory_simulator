import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
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

    Rectangle {
        anchors.fill: parent
        color: "#303841"
        GridLayout {
            anchors.centerIn: parent
            width: 800
            height: 600
            id :mainGrid
            rows: 3
            columns:2
            columnSpacing: 40

            TableView {
                id:mytable
                Layout.row: 1
                Layout.column: 0
                Layout.columnSpan: 1
                Layout.rowSpan: 1
                Layout.preferredWidth: mainGrid.width/2
                Layout.preferredHeight:  mainGrid.height/2 - 150

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
                    property int processID
                    id:tabBar
                    anchors.bottom:  mytable.top

                    function clear()
                    {
                        for(var i =0 ; i < tabBar.count; i++)
                        {
                            var item = tabBar.itemAt(i);
                            tabBar.removeItem(item);
                        }
                        console.log("TabBar Cleaaaaar");

                    }
                }
                Component {

                    id: tabButton
                    TabButton {
                        text: ""
                        onClicked: {fillSegmentationTable(Number(text[1]));tabBar.processID=Number(text[1]);}
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
            Component {
                id: inputSegments
                Row {
                    property int index
                    y:index*inputTable.height/5
                    id:row
                    Rectangle{
                        x:0
                        width: inputTable.width/2
                        height:inputTable.height/5
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
                        height:inputTable.height/5
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

            TableView {
                id:inputTable
                Layout.row: 1
                Layout.column: 0
                Layout.columnSpan: 1
                Layout.rowSpan: 1
                Layout.preferredWidth: mainGrid.width/2
                Layout.preferredHeight:  mainGrid.height/2 - 150

                visible: false

            }

            Row{
                Layout.row: 2
                Layout.column: 0
                Layout.columnSpan: 1
                Layout.rowSpan: 1
                Layout.preferredWidth: mainGrid.width/2
                Layout.preferredHeight:  40

                Button {
                    id:verify
                    text: "Allocate"
                    onClicked: {
                        mytable.visible=true;
                        inputTable.visible=false;
                        deallocate.visible=true;
                        addsegment.visible=false;
                        if( MemoryBackend.addProcess())
                        {
                            var Button1=tabButton.createObject(tabBar,{"text":"P"+(MemoryBackend.getinputProcessID())})
                            tabBar.addItem(Button1);
                        }
                        else
                        {
                            console.log("Can not append process")
                        }
                        for(var i = inputTable.children.length; i > 0 ; i--) {
                            inputTable.children[i-1].destroy();
                        }
                    }
                }
                Button {
                    id:addProcess
                    text: "Add Process"
                    onClicked: {
                        //processtable.clear();

                        mytable.visible=false;
                        deallocate.visible=false;
                        addsegment.visible=true;
                        inputTable.visible=true;
                        MemoryBackend.set_inputProcess();
                        var input=inputSegments.createObject(inputTable,{"index":0});

                    }
                }
                Button {
                    id:deallocate
                    visible: true
                    text: "Deallocate"
                    onClicked: {processtable.clear();
                        tabBar.removeItem(tabBar.currentIndex);
                        MemoryBackend.deallocate_process(tabBar.processID);
                    }
                }
                Button {
                    id:addsegment
                    visible:false
                    text: "add segment"
                    onClicked: { var input=inputSegments.createObject(inputTable,{"index":MemoryBackend.inputProcess_addsegment()});}
                }
            }

            Column {
                Layout.row: 0
                Layout.column: 1
                Layout.fillHeight: true
                Layout.rowSpan: 3
                Layout.preferredWidth: mainGrid.width/2
                Layout.preferredHeight:  mainGrid.height

                Rectangle {
                    width: parent.width
                    height: 30
                    color: "#303841"
                    border.width: 1
                    border.color: "#eeeeee"
                    Text {
                        anchors.centerIn: parent
                        id: name
                        text: qsTr("Memory")
                        color: "#eeeeee"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: parent.height -30
                    Memory {
                        id:memory
                    }
                }
            }

            Rectangle {
                Layout.row: 0
                Layout.column: 0
                Layout.columnSpan: 1
                Layout.rowSpan: 1
                Layout.margins: 30
                Layout.preferredWidth: mainGrid.width/2
                Layout.preferredHeight:  mainGrid.height/2
                color:"#3a4750"
                radius: 10
                Rectangle {
                    color: parent.color
                    anchors.fill: parent
                    anchors.margins: 15
                    GridLayout {
                        anchors.fill:  parent
                        id:grid
                        rows: 3
                        columns : 6

                        Button {
                            text: "Start"
                            onClicked: MemoryBackend.allocate_dummies();
                            Layout.row: 0
                            Layout.column: 3
                            Layout.rowSpan: 1
                            Layout.columnSpan: 3
                            Layout.minimumWidth: grid.width/2
                        }

                        Button {
                            text: "Clear"
                            onClicked: {memory.clear();MemoryBackend.clear();tabBar.clear();processtable.clear();}
                            Layout.row: 0
                            Layout.column: 0
                            Layout.rowSpan: 1
                            Layout.columnSpan: 3
                            Layout.minimumWidth: grid.width/2
                        }

                        TextField {
                            id: holeAddress
                            placeholderText: "Address"
                            Layout.row: 1
                            Layout.column: 0
                            Layout.rowSpan: 1
                            Layout.columnSpan: 2
                            //                    Layout.fillWidth: true
                            Layout.preferredWidth: grid.width/3
                        }
                        TextField {
                            id: holeSize
                            placeholderText: "Size"
                            Layout.row: 1
                            Layout.column: 2
                            Layout.rowSpan: 1
                            Layout.columnSpan: 2
                            //                    Layout.fillWidth: true
                            Layout.preferredWidth: grid.width/3
                        }
                        Button {
                            Layout.row: 1
                            Layout.column: 4
                            Layout.rowSpan: 1
                            Layout.columnSpan: 2
                            Layout.preferredWidth: grid.width/3


                            text: "Add Hole"
                            property int i : 0
                            onClicked: {
                                if(memory.totalSize == 1)
                                {
                                    console.log("Set the Size and Type");
                                    return;
                                }

                                var myHole = MemoryBackend.createHole();
                                myHole.hole_address = parseInt( holeAddress.text ) ;
                                myHole.hole_size = parseInt( holeSize.text );
                                MemoryBackend.add_hole(myHole)

                                holeAddress.clear();
                                holeSize.clear();
                            }
                        }
                        TextField {
                            placeholderText: "Total Size"
                            id:setSize
                            Layout.row: 2
                            Layout.column: 0
                            Layout.rowSpan: 1
                            Layout.columnSpan: 2
                            Layout.preferredWidth: grid.width/3
                        }
                        ComboBox {
                            id: selectType
                            Layout.row: 2
                            Layout.column: 2
                            Layout.rowSpan: 1
                            Layout.columnSpan: 2
                            Layout.preferredWidth: grid.width/3
                            model: ["first" , "fittest" ]

                        }
                        Button {
                            Layout.row: 2
                            Layout.column: 4
                            Layout.rowSpan: 1
                            Layout.columnSpan: 2
                            Layout.preferredWidth: grid.width/3

                            text: "Set Size,Type"
                            onClicked: {
                                MemoryBackend.set_allocation_type( selectType.currentText );
                                MemoryBackend.set_size( parseInt(setSize.text) );
                                memory.totalSize = parseInt(setSize.text);
                            }
                        }
                    }
                }
            }
        }


    }

    Connections {
        target: MemoryBackend;
        onUpdateMemoryQml :
        {
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


}
