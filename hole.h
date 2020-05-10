#ifndef HOLE_H
#define HOLE_H
#include <QObject>


// note that Q_GADGET and Q_DECLARE_MATATYPE to register the hole into the Meta Object System to be sent to javascript
// it allows to send it via signals-slots system by wrapping it with QVariant

/*
 not important note : it can be added with QObject subclass as it always sent by value
 and QObject cannot be sent by value as its copy constructor and assignment is disabled due to many reasons
 serch about "why QObject should be referenced not copied"
*/
class hole
{
    Q_GADGET

    // property to access via javascript via direct name
    Q_PROPERTY(int hole_address READ get_addr WRITE set_addr)
    Q_PROPERTY(int hole_size READ getSize WRITE setSize)

public:
    int hole_address;
    int hole_size;

    int get_addr() {return hole_address;}
    void set_addr(const int& addr) {this->hole_address = addr;}

    int getSize() {return  hole_size;}
    void setSize(const int& size) {this->hole_size = size;}

};
Q_DECLARE_METATYPE(hole);

#endif // HOLE_H
