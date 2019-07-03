#include "Simple.H"
#include <string>

Simple::Simple(int myArg) {
        myInt = myArg;
        return;
}

int Simple::add( int myArg ) {
        return myInt + myArg;
}

std::string Simple::get_string( std::string str ) {
        std::string foo = "|" + str + "|";
        return foo;
}

StringMap Simple::getMap(StringMap myMap) {
        myMap["Hello"] = "world";
        return myMap;
}

StringVector Simple::getVec(StringVector myVec) {
        myVec.push_back("abc");
        myVec.push_back("123");
        return myVec;
}
