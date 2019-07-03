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
