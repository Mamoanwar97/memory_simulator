#include "sort.h"

bool sortByFirst(hole a, hole b)
{
    return a.hole_address < b.hole_address;
}


bool sortBySize(hole a, hole b)
{
    return a.hole_size < b.hole_size;
}
