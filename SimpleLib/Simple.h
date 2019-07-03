#include <string>
#include <map>
#include <vector>

using namespace std;

typedef map<string,string> StringMap;
typedef StringMap::iterator StringMapIt;

typedef vector<string> StringVector;
typedef StringVector::iterator StringVectorIt;

class Simple {
        public:
                Simple(int myArg);
                int add(int myArg);
                std::string get_string(std::string str);
                StringMap getMap(StringMap myMap);
                StringVector getVec(StringVector myVec);
        protected:
                int myInt;
};
