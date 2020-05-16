#ifndef MEMORY
#define MEMORY

#include <bits/stdc++.h>
#include <QObject>
#include <QVariant>
#include "hole.h"
#include "sort.h"
#include<QDebug>
using namespace std;

class segment
{
    Q_GADGET
    Q_PROPERTY(QString name READ getName WRITE setName)
    Q_PROPERTY(int seg_size READ getSize WRITE setSize)
    Q_PROPERTY(int seg_address READ getAddress WRITE setAddress)
public:
    segment() {this->name=""; this->seg_size=0; this->seg_address = 0;}
    string name;
    int seg_size;
    int seg_address = -1;

    void setName(const QString& name) {this->name= name.toStdString();}
    void setSize(const int& size) {this->seg_size = size;}
    void setAddress(const int& add) {this->seg_address = add;}
    Q_INVOKABLE  int getSize() {return this->seg_size;}
    Q_INVOKABLE int getAddress() {return this->seg_address;}
    Q_INVOKABLE  QString getName() {return QString::fromStdString(this->name);}
};
Q_DECLARE_METATYPE(segment);


class process
{
    Q_GADGET
public:
    Q_INVOKABLE vector<segment> segments;
    Q_INVOKABLE int id;
    Q_INVOKABLE void setID(int x){this->id=x;}
    Q_INVOKABLE QVariant getSegments() {return QVariant::fromValue(this->segments);}
    Q_INVOKABLE void addSegment(segment newSegment) { this->segments.push_back(newSegment);}
    Q_INVOKABLE QString getSegmentName(int i) { return segments[i].getName();}
    Q_INVOKABLE  int getSegmentSize(int i) {return  segments[i].getSize();}
    Q_INVOKABLE int getSegmentAddress(int i) {return segments[i].getAddress();}
    Q_INVOKABLE int size() {return segments.size();}
};
Q_DECLARE_METATYPE(process);



class memory : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE vector<hole> holes;
    Q_INVOKABLE vector<process> processes;
    Q_INVOKABLE vector<segment> dummies;
    Q_INVOKABLE string allocation_type;

    Q_INVOKABLE QVariant createHole()
    {
        hole x ;
        return QVariant::fromValue(x);
    }
    Q_INVOKABLE QVariant createSegment()
    {
        segment x ;
        return QVariant::fromValue(x);
    }
    Q_INVOKABLE QVariant getProcess(int i)
    {
        return processes[i].getSegments();
    }

    Q_INVOKABLE QVariant createProcess()
    {
        process x;
        return QVariant::fromValue(x);
    }
    Q_INVOKABLE QVariant getProcessName(int i)
    {
        return processes[i].getSegments();
    }
    Q_INVOKABLE int getProcessID(int i)
    {
        return processes[i].id;
    }
    Q_INVOKABLE QString getSegmentName(int i,int j)
    {
        return processes[i].getSegmentName(j);
    }
    Q_INVOKABLE int getSegmentSize(int i,int j)
    {
        return processes[i].getSegmentSize(j);
    }
    Q_INVOKABLE int getSegmentAddress(int i,int j)
    {
        return processes[i].getSegmentAddress(j);
    }
    Q_INVOKABLE int getNumProcess()
    {
        return processes.size();
    }


private:
    int memory_size;


    void emitQml() {

        QVariant Processes = QVariant::fromValue(this->processes);
        QVariant Dummies   = QVariant::fromValue(this->dummies);

        emit updateMemoryQml(Processes,Dummies);
    }

signals:
    void updateMemoryQml(QVariant processes , QVariant dummies);
    /*  todo:
        holes:
            - private_function for de-allocating seqment and add this hole to the holes vector then sort
            - puplic_function for de-allocating process
    */
    //----------------------- NEWLY ADDED-----------------------------//
private:

    void sort_holes()
    {
        if(allocation_type == "first")
            sort(holes.begin(),holes.end(), sortByFirst);
        else
            sort(holes.begin(),holes.end(), sortBySize);
    }
    void combine_holes()
    {
        sort(holes.begin(),holes.end(), sortByFirst);
        for(int i=0; i< holes.size()-1; i++)
        {
            if((holes[i].hole_address + holes[i].hole_size) == holes[i+1].hole_address)
            {
                hole x;
                x.hole_address = min(holes[i].hole_address, holes[i+1].hole_address);
                x.hole_size = holes[i].hole_size + holes[i+1].hole_size;
                holes.erase(holes.begin()+i);
                holes.erase(holes.begin()+i);
                holes.push_back(x);
                sort(holes.begin(),holes.end(), sortByFirst);
                i = -1;
            }
        }
        sort_holes();
    }
    //pass the seqment by refrence to set its address
    bool add_segment(int process_id, int segment_id) //add first_fit or best fit depending on sorting of holes
    {
        int flag = 0;
        //search for the enough space of the memory
        for(int i = 0; i < holes.size(); i++)
        {
            //find a free space for the segment
            if( processes[process_id].segments[segment_id].seg_size <= holes[i].hole_size && processes[process_id].segments[segment_id].seg_address < memory_size && (processes[process_id].segments[segment_id].seg_address + processes[process_id].segments[segment_id].seg_size) < memory_size)
            {
                flag = 1;
                processes[process_id].segments[segment_id].seg_address = holes[i].hole_address; //set the seqment address as the hole address
                holes[i].hole_address += processes[process_id].segments[segment_id].seg_size; // move the hole's address + to the end of the segment address
                holes[i].hole_size -= processes[process_id].segments[segment_id].seg_size; //decrease the hole's space due to the occupied seqment
                if(holes[i].hole_size == 0) //if size of the hole = 0, erase it from holes
                    holes.erase(holes.begin()+i);
                break;
            }
        }
        if(!flag)
            return false;

        sort_holes();
        return true;
    }
    void delete_segment(int process_id, int segment_id)
    {
        hole x;
        x.hole_address = processes[process_id].segments[segment_id].seg_address;
        x.hole_size = processes[process_id].segments[segment_id].seg_size;
        holes.push_back(x);
        combine_holes();
    }
    bool allocate_process(int id)
    {
        int process_not_complete = 0;
        int i = 0;

        for(i=0; i< processes[id].segments.size(); i++)
        {
            if(!add_segment(id, i))
            {
                process_not_complete = 1;
                break;
            }
        }

        if(process_not_complete)
        {
            for(int j = 0; j < i; j++)
            {
                delete_segment(id, j);
            }
            return false;
        }

        return true;
    }
    void deallocate_process(int id)
    {
        int size = processes[id].segments.size();
        for(int i=0; i< size; i++)
        {
            delete_segment(id, i);
        }
    }

public:
    memory() : QObject() { cout << "Mss" << endl; }

    process inputProcess;
    segment inputSegment[5];
    Q_INVOKABLE void set_inputProcess()
    {
        if(inputProcess.size()==5)
        {

        }
        else{
        for(int i=0 ;i<5;i++)
        {
            inputSegment[i].setName("");
            inputSegment[i].setAddress(0);
            inputSegment[i].setSize(0);

            inputProcess.addSegment(inputSegment[i]);
        }
        }
    }
    Q_INVOKABLE void set_inputProcess_segment_Name(int i,QString Name)
    {
        inputProcess.segments[i].setName(Name);
        qDebug() << inputProcess.segments[i].getName() <<endl;
    }
    Q_INVOKABLE void set_inputProcess_segment_size(int i,int size)
    {

        inputProcess.segments[i].setSize(size);
        qDebug() << inputProcess.segments[i].getSize() <<endl;
    }
    Q_INVOKABLE void set_inputProcess_segment_Address(int i,int address)
    {
        inputProcess.segments[i].setAddress(address);
        qDebug() << inputProcess.segments[i].getAddress() <<endl;
    }
    Q_INVOKABLE void addProcess()
    {
        bool x = add_process(inputProcess);
        emitQml();
        inputProcess.segments.clear();

    }

    //Set first fit or best fit
    Q_INVOKABLE void set_allocation_type(QString type)
    {
        cout << "setType " << type.toStdString() << endl;
        allocation_type = type.toStdString();
    }
    //set total size of the memory
    Q_INVOKABLE void set_size(int t_size)
    {
        cout << "setSize " << t_size << endl;
        memory_size = t_size;
    }
    Q_INVOKABLE void allocate_dummies()
    {
        sort(holes.begin(),holes.end(), sortByFirst);

        int index = 0;

        for(int i = 0; i < holes.size(); i++)
        {
            if(index < holes[i].hole_address)
            {
                segment x;
                x.name = "dummy";
                x.seg_address = index;
                x.seg_size = holes[i].hole_address - index;
                dummies.push_back(x);
            }
            index = holes[i].hole_address + holes[i].hole_size;
        }
        if(index < memory_size)
        {
            segment x;
            x.name = "dummy";
            x.seg_address = index;
            x.seg_size = memory_size - index;
            dummies.push_back(x);
        }
        sort_holes();

        this->emitQml();
    }
    Q_INVOKABLE void deallocate_dummies(int id)
    {
        cout << "delaocate dummy " << id << endl;
        hole x;
        x.hole_address = dummies[id].seg_address;
        x.hole_size = dummies[id].seg_size;
        holes.push_back(x);
        dummies.erase(dummies.begin()+ id);
        combine_holes();
    }
    Q_INVOKABLE void add_hole(hole x)
    {
        cout << "hole to be added " << x.hole_size << "," << x.hole_address <<endl;
        holes.push_back(x);
        combine_holes();

        this->emitQml();
    }

    Q_INVOKABLE bool add_process(process p)
    {
        //        cout << "process to be added "  << endl;
        //        for(int i =0 ;  i < p.segments.size(); i++)
        //            cout << p.segments[i].name <<" ";
        //        cout << endl;

        processes.push_back(p);
        bool x = allocate_process(processes.size()-1);
        if(!x)
        {
            processes.pop_back();
            cout << "didn't allocate process" << endl;
            return false;
        }

        this->emitQml();
        //        this->print_dummies();
        //        this->print_processes();
        return true;
    }

    void remove_process(int id)
    {
        deallocate_process(id);
        processes.erase(processes.begin()+(id));
        this->emitQml();
    }
    void print_segment(int process_id, int segment_id)
    {
        cout << "Segment: " << segment_id << " address: " << processes[process_id].segments[segment_id].seg_address << "    size: " << processes[process_id].segments[segment_id].seg_size << endl;
    }

    void print_process(int id)
    {
        cout << "Process: " << id << endl;
        for(int i = 0; i < processes[id].segments.size(); i++)
        {
            print_segment(id, i);
        }
        cout << "------------------------------------------------------------------------------------------------------" << endl;
    }
    void print_processes()
    {
        for(int i = 0; i < processes.size(); i++)
        {
            print_process(i);
        }
    }
    void print_holes()
    {
        cout << "Holes: " <<  endl;
        for(int i = 0; i < holes.size(); i++)
        {
            cout << "Hole: " << i << " address: " << holes[i].hole_address << "    size: " << holes[i].hole_size << endl;
        }
        cout << "------------------------------------------------------------------------------------------------------" << endl;
    }
    void print_dummies()
    {
        cout << "Dummies: " <<  endl;
        for(int i = 0; i < dummies.size(); i++)
        {
            cout << "dummy: " << i << " address: " << dummies[i].seg_address << "    size: " << dummies[i].seg_size << endl;
        }
        cout << "------------------------------------------------------------------------------------------------------" << endl;
    }
    int getID(int j)
    {
        for(int i = 0; i < processes.size(); i++)
        {
            if(processes[i].id==j)
            {
                return i;
            }
        }
        return -1;
    }
    Q_INVOKABLE void removeProcess(int id)
    {
        int x= getID(id);
        qDebug() << x;
        if(x!=-1)
        {
            processes.erase(processes.begin()+x);
        }
        emitQml();
    }
};

//int main()
//{
//    ios_base::sync_with_stdio(0);
//    cin.tie(0);
//    cout.tie(0);

//    memory mymemory;


//    int x;
//    cout << "Please Enter the memory size: " << endl;
//    cin >> x;
//    mymemory.set_size(x);

//    string y;
//    cout << "Please Enter the Allocation type: " << endl;
//    cin >> y;
//    mymemory.set_allocation_type(y);


//    cout << "Please Enter the number of holes : " << endl;
//    cin >> x;

//    while(x--)
//    {
//        hole z;
//        cout << "Please Enter the hole address and size: " << endl;
//        cin>> z.hole_address >> z.hole_size;
//        mymemory.add_hole(z);
//    }
//    mymemory.allocate_dummies();
//    mymemory.print_holes();
//    mymemory.print_dummies();

//    cout << "Please enter the dummy number to remove : " << endl;
//    cin >> x;
//    mymemory.deallocate_dummies(x);
//    mymemory.print_holes();
//    mymemory.print_dummies();

//    cout << "Please Enter the number of processes : " << endl;
//    cin >> x;

//    for(int m =0; m<x; m++)
//    {
//        int n;
//        cout << "Please Enter the number of segments of process " << m << " : "<< endl;
//        cin >> n;
//        process p;
//        while(n--)
//        {
//            segment z;
//            cout << "Please Enter the segment size: " << endl;
//            cin >> z.seg_size;
//            p.segments.push_back(z);
//        }
//        if(!mymemory.add_process(p)){
//            cout << endl << "not enough space" << endl;
//        }
//    }
//    cout <<endl;
//    mymemory.print_holes();
//    cout <<endl;
//    mymemory.print_processes();

//    cout << "Please Enter the number of process you want to remove : " << endl;
//    cin >> x;
//    mymemory.remove_process(x);

//    cout <<endl;
//    mymemory.print_holes();
//    cout <<endl;
//    mymemory.print_processes();

//    return 0;
//}


#endif
