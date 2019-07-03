# The posting

This post was found at https://www.perlmonks.org/?node_id=853194 and I wanted to save it for posterity here.

## Preface

I know enough C and C++ to get things done, I'm definitely not a core Perl hacker, or any form of a low level programmer. With that in mind, there is a good chance I am incorrectly interpreting some of the terminology or the general approach. One area that I am very leary of is memory management. Just getting something working doesn't mean that you have all the leaks nailed down. That's my next task on this long, painful road. Oh, and before anyone decides to dump on my post, just keep in mind I've been trying to do this for a long time, and have bought books, scoured the internet, and asked people on forums. "This" was the BEST I could do.

So, I have always considered XS, the "final frontier" for me with Perl. I've been coding in Perl religiously for over a decade, and have done good bit of C and C++ as well. But marrying the two together has always been a formidable task that I have feared. I've avoided it through databases, sockets, and flat files. At my old job, there was an old crufty swig file in a project we used that miraculously was able to pull things together and provide an incredibly complex interface to a shared memory data store. I tried to make sense of it a few times, but in the end (due to a general lack of time and documentation) I ended up just trusting in the magic, and hoped that the swig code never broke.

I have built a few components in C++ that I am really proud of, and decided it was time to figure out how to link my beloved Perl to the world of C++. I like to think I am good at researching programming problems. I should really re-state this as, I am really good at using google, to solve compex programming problems. Sadly it's more like "I've never done anything unique, and anything I have problems with someone else has already had, and posted about it, years ago, and garnered responses from the luminaries that lead our community". I just am good enough with Google to find those threads to get me in the right direction to solve whatever problem I'm having, when my army of O'Reilley books aren't there to teach me what I need to know.

Here is my task. I have a C++ library, that I would like to be able to access from perl. The library is object oriented, takes strings as arguments, and returns strings, or vectors of strings, or hashes of strings/strings. I'll be honest, I'm not a C++ guru, I have used Boost and ACE to write safe multi-threaded code, and I have a decent understanding of memory management in C/C++ but that is pretty much the end for me.

## BEGIN BOOK REVIEW

Disclaimer: This isn't a book review ;-), but I figured I'd make a few comments on this book I paid $44.99 for, since it's directly applicable to my problem.

To start off, I am staring at a copy of "Extending and Embedding Perl", by Tim Jenness and Simon Cozens. It is an odd book. Two of the eleven chapters are spent teaching you C, and two more chapters are spent discussing how to hack Perl itself. The rest of the book is a bit more applicable to the title, with two chapters devoted to embedding perl and five chapters to extending. (though, "Alternatives to XS" could have been a much larger topic, but I'll get to that later).

The reason I point out the distribution of material in the book is, in those 4 chapters about using XS, it misses the most basic use case in all of the examples. Linking Perl to an existing C or C++ library. Every single one of their examples shows the C code being embedded in the ".xs" file directly. There is no mention of how you would even accomplish this, anywhere in the book! Just to prove the point, go download the example code yourself and do an "find . |egrep -i '\.ch$'". You won't find anything outside of chapters one and three, the ones that deal with teaching you C, and a short blib on h2xs in chapter 7, but even that shows you the actual C code in the ".xs" file.

There are 7 pages devoted to extending to C++. I typed in the examples, and with a little work, got them working. The example didn't cover external files, nor did it cover how to pass complex variables (the examples dealt with "int's" for input an output). So for, to summarize (finally), this is a good reference book, and when I actually need to jerk around with SV's and HV's, and IV's, then I can learn what they are and how they work.

If I could change it, I'd just get rid of all the extra stuff, and make more room for XS and Perl's internals. If there was room to spare, maybe full chapters on Swig and Inline, as they are both solid solutions that deserve more than short mentions.

## END BOOK REVIEW

_Thus begun my internet search._

I started at Perlmonks. Queries concerning: "XS C++" and "XS external library" were fruitless for the most part. http://perlmonks.org/?node_id=517931 .. tye, had the most impressive response (yes, I upvoted him), but it only dealt with C++ loaded directly in the XS file, and with "char's".

Then I hit the chatterbox. tye of course was online, being the helpful guy he is held an amazing amount of patience with me as I slowly answered my questions. He did his absolute best to steer me away from XS entirely, and to use SWIG or Inline::C++ instead. But my position was simple, I didn't see any of the "awesome" libraries on CPAN resorting to this, why should I? Why is this so damn hard? Why is it so poorly documented? Why do I have a book on the subject that I paid 50$ for and I still have no clue how to accomplish such simple tasks? tye sensed my frusrtration, and kept pressing for alternatives. It was at this point I decided that I'd play the "Picard" card with XS.

*"They invade our space, and we fall back. They assimilate countless worlds, and we fall back. Not again. Not this time. The line must be drawn here! This far, no farther! And I will make them pay for what they have done!" - Jean Luc Picard, Star Trek First Contact*

Come hell or high water (?) I am going to figure this out.

----------------------------------------------------------

Inline::C++ : This module, when it works, works really well. It provides a seemless integration between Perl and C++, and you barely have to lift a finger. The people who wrote this are beyond smart. I applaud their work. Here is where it breaks down for me. You need to have a compiler and your environment set up the same way for every machine that you want to use your library on (unless you do even more smart env logic in your BEGIN blocks). If you don't have a compiler, and/or don't want to rely on re-compiling when you run the program, I'm told you can distribute the compiled bits, but packaging this became almost as much of a daunting task as the original problem itself.

SWIG : I used to work with a guy who worked on the SWIG team. His initials are "M.M" (for friends of mine that read this). Nobody can understand a word he says (in English), as he's from Chile, but what is funny is nobody can understand what he says in spanish eiher (and that comes from people who are native spanish speakers). Heh, anyway, that's sort of how SWIG is. You tell it to do something, and either it works, or it spits back unintelligble mess that is totally undecipherable. Just like my old job, you have to trust the magic, and if it breaks, you have no recourse. Their website has decent documentation, but not enough detail on how to resolve complex issues, leaving you to scour the internet like I did on XS. Do you use an abstraction that will have problems, but a smaller pool of people that can help? Or do you tough it out and use the harder solution, but one that has a larger pool of support? Guess which one I'm going with.

----------------------------------------------------------

I tried to just look at existing perl modules that I knew linked to C/C++ on CPAN. I knew libxml, Wx, and the various DBD::\* libraries had to make calls to the underlying layers, but the typemaps were far too complex for my puny mind to comprehend. I hoped the Wx library would have some insight, but it too blew my mind. I needed a concrete example or documentation on what steps needed to be taken.

[John Keiser](http://www.johnkeiser.com/perl-xs-c++.html) seems almost as frustrated as I am. This link is referenced in MANY other articles on the internet concerning XS and C++. Of course, this doesn't have an example of using external files, and ::sigh:: it only deals with int's for inputs and outputs. Sadly, since this was written in 2001, I ran into some issues just getting the examples working. In the end, I just gave up on it and looked for other documentation.

[Stack Overflow](http://stackoverflow.com/questions/428153/how-do-i-call-a-c-static-library-from-perl) is a pretty good place to get answers to questions, most of the answers pointed to SWIG, Inline::C, and the perl-xs-tut (we'll get to the xs-tut here in a second).

Perl XS Mailing list [1](http://www.mail-archive.com/perl-xs@perl.org/msg00889.html) and [2](http://www.mail-archive.com/perl-xs@perl.org/msg00631.html) : I found these gems, while digging, and it gave me hope that building a typemap for std::string and std::vector might be possible. Unfortunately, the code was meant more as a scratchpad (and he states this explicitly). So close!

The [Perl XS mailing list](http://www.mail-archive.com/perl-xs@perl.org/info.html) is a really great site. This place has a great signal to noise ratio (similar to the mod_perl mailing list). Yet again, things that I have questioned, more or less, have already been asked, answered, or told they are thinking about the problem wrong (the latter being my problem).

[Boom!](http://www.mail-archive.com/perl-xs@perl.org/msg01965.html), here was some documentation of an external file with XS. Lots of concepts and little example though. I really wanted everything explained, no more magic.

[WrappingPerl](http://science.larc.nasa.gov/ceres/presentations/WrappingPerl.ppt) : Uses external files! Uses the STL!! ... Uses SWIG. Damn it. Ok, so I typed all this out, and got it working, and tried to figure out what SWIG was generating based on the resulting ".cxx" file. It ended up being another brick wall. I was impressed that SWIG was capable of doing almost everything I needed it to do, but it was the same magic that I had to "trust" like I did back in my previous job. I decided that I was NOT going to use swig.

[Kaye SWIG](http://perl.org.il/presentations/offer_kaye_swig/index.html) : An even better SWIG example. It was recently posted to Alberto Simões's perl blog by Kaye (courtesy of Shlomo Yona). This is the best SWIG documentation that deals with complex data structures and external files available. If anyone else writes a book about XS, they should just dump this entire distribution to paper, as it is incredibly well documented. Too bad it's C, otherwise I probably would have given up XS and just used this.

[Perl XS Tutorial](http://perldoc.perl.org/perlxstut.html) : Yes! Why the hell didn't I look here first?! Example 4 is perfect! External files! MYEXTLIB! (wtf is an MYEXTLIB?!)

As an aside, look at the perldoc for ExtUtils::Makemaker, under MYEXTLIB, and see if you make the connection that THIS is the attribute that allows you to reference external libraries, yes I know EXTLIB should have clued me in, but it didn't register as the solution to my problem).

Holy crap the ExtUtils::MakeMaker is complicated. Where the heck did this "MY" namespace come from? What is all this weird "make" snippets littered all around? Ok, just get it working, and then you can reverse engineer it so you can teach yourself what all these keywords mean so you can actually learn something, rather than trusting the "magic". So that's what I did. (I'll cover that when I finally get to the example).

I used Module::Install for my last CPAN projet, "Ravenel". I wondered if it could build XS modules as well. But it's funny to me, since everyone seems to hate ExtUtils::MakeMaker, but all the modules that use XS all use it. It looks like this is the only syste worth using if you're dealing with this stuff.

Ok, let's not get too excited, I still need to know how to build a typemap for STL based objects, and if it's possible, complex ones (Vectors and Maps).

Typically, in any google search of a technical nature, you inevitable will start seeing posts in languages other than your own, I don't start hitting these until I exhaust all of the ones that are in english (obviously). (What do you call someone who is in Europe and can speak 5 languages? A waiter. What do you call someone who speaks one language and who is in Europe? An American.) Google translate does a decent job of getting the point across, but the concepts backing the idea always seem to be lost in translation (love that movie).

[Japanese blog](http://d.hatena.ne.jp/higepon/20060223/1140684810) : I ran into this first. And I thought I finally found it. The typemaps that wrap the STL for Perl. I have a "simple" class that you instantiate with a string as an arugment, and some methods that take strings and spit them back out. This is formatted for SWIG, and combined with the earlier lesson I found on swig, I probably could have just got by with this. But I've come too far now. XS or bust!

Holly's Blog But, this, is when I hit the proverbial jackpot. "Holly's page". I don't know who Holly is, but he/she is amazing and I wish I could sing his or her praises from the tallest buildings / trees / mountains. Holly has a 9 part XS C++ programming course on his or her site "The introduction perlxs 1-9". It covers damn near everything I would ever want to know about XS, with concrete examples.

Dear Holly, you rock, you have my undying devotion until the end of time, because you have documented your brilliance with so much clarity that I was able to translate it from Japanese and still get what I needed out of it. I owe you a beer, sake, fruit juice, or whatever it is you drink. Thank you from the bottom of my beaten down soul. --dextius

I feel better now that I've gotten that diatribe out of the way. Let's show you an example of using an external library, passing strings back and forth between Perl and C++. Then, let's explain what every line does so we can demystify some of the magic and fear that comes when dealing with XS. Before I dump out all my code, there is one point I need to make. I found it's easier to abandon your build script that you normally use to build your C++ project, and just use what Makefile.PL generates. I accomplished this by simply copying my code into this new directory tree.

## Here is the code

Change directories in your shell to somewhere where you can create new stuff and then run this.

    h2xs -A -n SimpleTest

This will create a skeleton for us to work with. Now create the SimpleLib directory.

    mkdir SimpleTest/SimpleLib

Here is the code for our "simple" library.

### /SimpleTest/SimpleLib/Simple.h

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

### /SimpleTest/SimpleLib/Simple.c

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

### /SimpleTest/SimpleLib/Makefile.PL

    use ExtUtils::MakeMaker;

    ( $CC, $Verbose ) = ( 'g++', 1 ); # define g++ as your CPP compiler
    WriteMakefile(
            NAME    => 'Simple::SimpleLib', # the name of the library we're building
            SKIP    => [qw(all static static_lib dynamic dynamic_lib)],
            clean   => {'FILES' => 'libSimpleLib$(LIB_EXT) unitTests'}, # when you run make clean, it'll delete the shared library and the binary too.
            CC      => $CC, # Our CPP compiler
            LD      => '$(CC)',
            CCFLAGS => '-fPIC', # this instructs the CPP compiler to use "Position independence", basically a shared library, more details here
                                # http://www.fpx.de/fp/Software/tcl-c++/tcl-c++.html
    );

    # Ok, this "MY::top_targets" command isn't even mentioned in the pod for ExtUtils::MakeMaker.
    # Just understand that it is a method that allows you to modify the targets that the makefile will build.
    # (when you type just "make", you're really invoking "make all").
    # You can see that "all" points to static, which points to libSimpleLib.a, which actually does the real work.
    # O_FILES refers to the object files that are created when the ".c" files are compiled.

    # You can see what is going on here when you actually run "make"

    # g++ -c   -fPIC -O2 -march=nocona -mmmx -msse -msse2 -msse3   -DVERSION=\"\" -DXS_VERSION=\"\" Simple.C
    # g++ -c   -fPIC -O2 -march=nocona -mmmx -msse -msse2 -msse3   -DVERSION=\"\" -DXS_VERSION=\"\" unitTests.C
    # ar cr libSimpleLib.a Simple.o unitTests.o
    # : libSimpleLib.a

    # "ar" is an archiving program that takes object files and packages them into archives.  It reminds me a lot of tar, except minus the raw device related stuff.

    # When you run "make bin" it takes the object files created when we ran "make" and links them to create the binary unitTests (since unitTests has a "main" function defined).

    # g++ Simple.o unitTests.o -o unitTests

    sub MY::top_targets {
            '
    all :: static

    pure_all :: static

    static :: libSimpleLib$(LIB_EXT)

    # These must be indented with tabs!!!

    libSimpleLib$(LIB_EXT): $(O_FILES)
            $(AR) cr libSimpleLib$(LIB_EXT) $(O_FILES)
            $(RANLIB) libSimpleLib$(LIB_EXT)

    # Tab indent these lines

    bin: $(O_FILES)
            $(LD) $(O_FILES) -o unitTests
            ';
    }

### /SimpleTest/SimpleLib/unitTests.c (A quick test "main")

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

At this point, you can compile "SimpleLib". You'll run these commands.

    cd SimpleLib
    perl Makefile.PL
    make
    make bin

To verify, run the unitTests binary.

    ./unitTests

It should return:

    14
    |abc|

Before I go any further, lets look at the Makefile.PL as it is key to all of our future plans.

1. We need to build a shared library, "make" will generate the "libSimpleLib.a" file.

2. "make bin" will generate the unitTests binary, running a "file unitTests" will tell you what architecture you're building for.

3. It is important your version of Perl was compiled with the same architecture (perl -v will tell you this).

4. A great resource on make is available here: Makefile Tutorial

Ok. Great, now we have a shared library built, and trust that it actually is capable of doing something when told to (via the unitTests binary). Now let's hook this up to Perl.

### /SimpleTest/Makefile.PL

    use 5.008003;
    use ExtUtils::MakeMaker;

    $CC = 'g++';

    # See lib/ExtUtils/MakeMaker.pm for details of how to influence
    # the contents of the Makefile that is written.
    WriteMakefile(
        NAME              => 'Simple',
        VERSION_FROM      => 'lib/Simple.pm', # finds $VERSION
        PREREQ_PM         => {}, # e.g., Module::Name => 1.1
        CC                => $CC,
        LD                => '$(CC)',
        ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
          (ABSTRACT_FROM  => 'lib/Simple.pm', # retrieve abstract from module
           AUTHOR         => 'dextius <dextius@blahblah.com>') : ()),
        LIBS              => [''], # e.g., '-lm'
        DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
        INC               => '-I.', # e.g., '-I. -I/usr/include/other'
        # OBJECT            => '$(O_FILES)', # link all the C files too # Un-comment this if you add C files to link with later:
        # target the shared library we just created "MYEXTLIB" tells make to use this shared library.
        'MYEXTLIB' => 'SimpleLib/libSimpleLib$(LIB_EXT)',
    );

    # (THE INDENTION on "cd SimpleLib..." MUST BE A TAB)

    sub MY::postamble {
    '
    $(MYEXTLIB): SimpleLib/Makefile
            cd SimpleLib && $(MAKE) $(PASSTHRU)
    ';
    }

### /SimpleTest/Simple.xs

    # Ahh now we are getting to the meat and potatoes of this monster.
    # Most of this mess is generated by h2xs, but let's see what else we got.

    #include "EXTERN.h"
    #include "perl.h"
    #include "XSUB.h"

    #include "ppport.h"

    # This line being ABOVE the "MODULE =" line is critical, as everything above that line is treated as pure C++
    # Anything below it is in XS macro land.

    #include "SimpleLib/Simple.h"

    using namespace std;

    MODULE = Simple         PACKAGE = Simple

    # The constructor.  Kind of looks like C++ here.  I pass in an "int".

    Simple *
    Simple::new( y )
            int y

    # I have no idea how "SimplePtr" became a valid keyword, but somehow the XS engine realizes that it is the return type of the constructor.
    # It's magic to me, for now.

    MODULE = Simple         PACKAGE = SimplePtr

    # Here is some basic XS, the documentation on this is covered pretty well in "Extending and Embedding Perl", specifically chapters 2 and 6.

    int
    Simple::add(x)
                    int x
            OUTPUT:
                    RETVAL

    string
    Simple::get_string(z)
                    string z
            OUTPUT:
                    RETVAL

    StringMap
    Simple::getMap(myMap)
                    StringMap myMap
            OUTPUT:
                    RETVAL

    StringVector
    Simple::getVec(myVec)
                    StringVector myVec
            OUTPUT:
                    RETVAL

### typemap

    TYPEMAP
    Simple      * T_PTROBJ
    string        T_STRING
    StringMap     T_STRING_MAP
    StringVector  T_STRING_VECTOR

    # Ok, let's step through this one fragment at a time.  First we're going to declare the "input" type
    # (ie: an argument passed in from perl to C++) of T_STRING, which maps to the C++ STL type of std::string.
    #
    # SvTYPE is a function that looks at an SV's type to determine if it's an ordinary SV.
    # It's basically the XS version of "ref".  SVt_PV is a string.  But you should use SvROK (the other half of "ref")
    # first, not sure why it's not.  If the string typemap receives something that isn't one, it'll warn and return undef.

    # SvCUR is a function that lets you interrogate the length of a scalar.
    # SvCUR has a friend named SvLEN that tells you how long it could be.
    # If it's length is 0, warn and return undef (not always desired, but for now it's fine.

    # The last line generates a string from the argument given.
    # "string" is the actual C++ class constructor.
    # SvPV_nolen lets you extract the value of a scalar and coerce it as a char *,
    # of unlimited length, because the C++ std::string constructor doesn't care, I think.

    INPUT
    T_STRING
        {
            if (SvTYPE($arg) != SVt_PV) {
                warn(\"${Package}::$func_name() -- $var is invalid svtype\");
                XSRETURN_UNDEF;
            }
            if (SvCUR($arg) == 0) {
                warn(\"${Package}::$func_name() -- $var is empty\");
                XSRETURN_UNDEF;
            }
            $var = string(SvPV_nolen($arg));
        }

    # Ok, this next section covers strings returned from C++ functions or methods (hence the OUTPUT),
    # that need to be transformed back into scalars for perl to deal with.  The "sv_setpvn" macro sets
    # the value of a scalar.

    OUTPUT
    T_STRING
        sv_setpvn($arg, $var.c_str(), $var.size());

    # Now things get complicated, let's handle an "array reference" and turn it into a std::vector of std::string's
    # and pass it into a C++ function or method, yee-hah..
    #
    # AV *av is a perl array.
    # I32 len is a 32 bit int. (why not just use int?)
    # SvROK "is this a reference" sort of like ref, except it doesn't tell you which kind. (SvRV dereferences the reference)
    # SVt_PVAV is Perl's C structure for an Array.
    # So, the entire line says, "if the argument is a perl array reference:"
    # Dereference the arg, then downcast it to a pointer of an array type (since we know it is one), assign that to our array type (av).
    # Assign the length of the arraa, using "av_len".
    # We return undef if it's length is 0 (not sure why we couldn't return an empty list here, but whatever)
    # The "else" handles the case when it's not handed an array reference as an argument
    #
    # Now for the guts.  Iterate over every element (the for loop)..Call the vector's method "push_back".
    # Create a new string, calling the scalar extraction SvPV_nolen, against the dereferenced value of what av_fetch returned.
    # It passes the array, the position, and a third argument detailing if Perl needs to auto extend the list
    # (because you're about to write to that index position).  av_fetch returns a pointer to a pointer to an SV, hence the deref'ing "*av_fetch".
    # lastly, we need to assign the "$var" (what goes to C++ to t_sv, our C++ StringVector, the header shows this is a std::vector<std::string>

    INPUT
    T_STRING_VECTOR
        {
            AV  *av;
            I32 len;
            StringVector t_sv;
            if(SvROK($arg) && SvTYPE(SvRV($arg)) == SVt_PVAV){
                av  = (AV *)SvRV($arg);
                len = av_len(av) + 1;
                if(len == 0){
                    warn(\"${Package}::$func_name() -- $var is empty array reference\");
                    XSRETURN_UNDEF;
                }

            } else {
                warn(\"${Package}::$func_name() -- $var is not a array reference\");
                XSRETURN_UNDEF;
            }
            for (I32 i = 0; i < len; i++) {
                t_sv.push_back(string(SvPV_nolen(*av_fetch(av, i, 0))));
            }
            $var = t_sv;
        }

    # Now for String vectors returned back to Perl
    # If it the C++ vector is empty, it returns undef back to perl
    # Why is it when I see "sv_2mortal" I think about the intro to the Sega game, "Altered Beast"... "Rise from your grave!"
    # So many weirdly named keywords in Perl.  I love the language, maybe even because of it's quirks.
    #
    # Anyway, we create a new Array.  (the rest is covered similarly on page 124 of Extending and Embedding Perl).
    #
    # SvSetSV will COPY the data from one variable to another, unless they're pointing to the same thing.
    # newRV_noinc: This is the C/C++ equivalent of the "\" or reference operator.  We have a list, we want to return it as an array reference.
    # We don't increment because it needs to go out of scope when this block finishes (we're copying to "arg" anyway, so the data lives on).
    # Reading from inside out.  Take an array, cast it as a pointer to a scalar (what newRV_noinc requires).  Pass that to newRV_noinc to
    # create a reference.  "arg" and this new reference value get sent to SvSetSV to copy the contents of your new array ref to the outbound
    # "arg" structure.  Phew!

    OUTPUT
    T_STRING_VECTOR
        {
            if($var.empty()){
                warn(\"${Package}::$func_name() -- vector is empty\");
                XSRETURN_UNDEF;
            }

            AV *av = (AV *)sv_2mortal((SV *)newAV());
            for(StringVectorIt it = $var.begin(); it != $var.end(); it++) {
                av_push(av, newSVpvn(it->c_str(), it->size()));
            }
            SvSetSV($arg, newRV_noinc((SV *)av));
        }

    # Now we need to look at hash referenecs passed as arguments to C++ functions.
    # They'll transform into std::map<std::string, std::string>.
    # HV is a hash value
    # HE is a hash entry (a key)
    # Ok, we've seen most of this already.  So let's move quick.
    # If it's not a hash ref, the return undef (SVt_PVHV is a hash)
    # Next is the C side perl loop over the keys in a hash
    # The key and value from the hash get forced into scalar values via HeSVKEY_force and HeVAL.
    # Those scalars are passed into the insert function of our StringMap (std::map<std::string, std::string>)
    # Assign the ingoing $var to the StringMap we've been inserting into!

    INPUT
    T_STRING_MAP
        {
            HV *hv;
            HE *he;
            StringMap t_sm;
            if(SvROK($arg) && SvTYPE(SvRV($arg)) == SVt_PVHV) {
                hv = (HV *)SvRV($arg);
                if(hv_iterinit(hv) == 0) {
                    warn(\"${Package}::$func_name() -- $var is empty hash reference\");
                    XSRETURN_UNDEF;
                }
            } else {
                warn(\"${Package}::$func_name() -- $var is not a hash reference\");
                XSRETURN_UNDEF;
            }

            while((he = hv_iternext(hv)) != NULL) {
                SV *svkey = HeSVKEY_force(he);
                SV *svval = HeVAL(he);
                t_sm.insert(StringMap::value_type(string(SvPV_nolen(svkey)), string(SvPV_nolen(svval))));
            }
            $var = t_sm;
        }

    # Lastly, deal with functions / methods that return StringMap's back to Perl.
    # If it's empty, return undef..
    # That crazy 'rise from the dead' thing again creating a Hash value that will go out of scope and be freed after this block ends.
    # Now it's basic C++ map looping.  hv_store only takes 5 arguments.  ::blink::
    #       The hash that you want insert into
    #       A const char* of the key
    #       An I32 integer of the length of that char* key we just mentioned
    #       A scalar that is to be the value of the key.
    #       The hashing value (passing 0 will tell Perl to compute it for you)
    # it->first  is the key   of the current element in std::map
    # it->second is the value of the current element in std::map
    # The value needs to be "wrapped" by the creation of a new scalar value, same as what we did when adding elements to an array

    OUTPUT
    T_STRING_MAP
        {
            if($var.empty()){
                warn(\"${Package}::$func_name() -- map is empty\");
                XSRETURN_UNDEF;
            }
            HV *hv = (HV *)sv_2mortal((SV *)newHV());
            for(StringMapIt it = $var.begin(); it != $var.end(); it++) {
                hv_store(hv, (it->first).c_str(), (it->first).size(), newSVpvn((it->second).c_str(), (it->second).size()), 0);
            }
            SvSetSV($arg, newRV_noinc((SV *)hv));
        }


## What do I do when I get: "error: macro "do\_open" requires 7 arguments, but only 2 given"

While I'm here, I ran to a bunch of other fun issues. Linking to Boost or ACE causes all kinds of wacky symbol collisions to fire off, but google was to the rescue, again. Simple add these few lines to your ".xs" file (immediately after #include "ppport.h")

    #undef init_tm
    #undef do_open
    #undef do_close

    #ifdef ENTER
    #undef ENTER
    #endif

Exceptions? So, my code throws exceptions. I cannot catch them, they cause Perl to blow up. I looked around, and eventually found the link above. It, like most of what I have learned about XS frightened me. I can see this is another "spend a week" researching on how other people have approached the problem, and then hack something of my own together, but hopefully someone will read this and tell me what the best approach is.

## Multiple C++ objects exposed by XS (in a single project)?

Wx does this, but it uses it's own custom MakeMaker to pull it off. The one thing I noticed is that it created seperate .xs files for each class. I assume this is what I need to do, but I don't know how to make Makefile.PL pick up the other .xs files I create describing the other objects defined in my header file. I also learned (the hard way) you can't define more than one object in a ".xs" file, or maybe it's just the syntax I was using. I really don't know. I wish I had a few weeks to reverse engineer how Wx is doing this, but there is so *MUCH* code, I'm not even sure where to start.

## Summary

Wow, this was really hard. I still don't know everything. I feel like after pouring over Extending and Embedding Perl over the last month or so I can tackle a C based library with some level of competency. But beyond these simple STL calls and an object wrapper, I still feel totally lost with C++ and XS. So many burning questions, and so few outlets for more information. Again, if I didn't stated it before, the fact that I got any of this working at all wouldn't have been possible with out "Holly's Blog". It's amazing how much information is on that page. It's ironic, that I had to go through Japanese to to get to XS (both of which being undecipherable to me).

What have I learned? That C++ is just another opaque object to Perl, that the typemaps are what allow you to call internal perl5 api's to construct perl datastructures, using C++ code right along side it. Once you learn it, it makes sense, but holy moly, what a hill you have to climb to get there. I also learned that I have a lot more to learn.

Hopefully this mess I have written will inspire much more talented people to write even better documentation so I can update this entire page with a simple link to their page.

Thanks to all the people who wrote these posts on their blogs, and to Perlmonks, and to tye for "inspiring" this :-)
