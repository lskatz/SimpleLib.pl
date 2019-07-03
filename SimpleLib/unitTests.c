#include "Simple.H"
#include <iostream>
#include <string>

int main( int argc, char * argv[] ) {

        Simple s = Simple(5);
        std::cout << s.add(9) << std::endl;

        std::string moo = "abc";
        std::string foo = s.get_string(moo);

        std::cout << foo << std::endl;

        StringMap m;
        m["qqq"] = "uuu";

        StringMap n = s.getMap(m);
        std::cout << "n[qqq] " << n["qqq"] << std::endl;

        StringVector v;
        v.push_back("999");

        StringVector w = s.getVec(v);
        std::cout << "w[0] " << w[0] << std::endl;
        std::cout << "w[1] " << w[1] << std::endl;
        std::cout << "w[2] " << w[2] << std::endl;

        return 0;
}
