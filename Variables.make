####
#### USER CONFIGURABLE
####

#PROFILEFLAG=-pg
OPTIFLAG=-DNDEBUG -DNPRINT -O2
DEBUGFLAG=-g

# turn off -pipe if linker doesn't support it
EXTRACXXFLAGS=-pipe -Wall -W   -Wmissing-prototypes 

#
# -lefence = ElectricFence.
#
# ElectricFence is a memory debugger which uses the 
# VM hardware to trap malloc/free errors.
#
#EXTRALIB+=-lefence

####
#### END USER CONFIGURABLE part.
####

ifdef PROFILEFLAG
	DEFINES+=$(OPTIFLAG) $(PROFILEFLAG)
	EXTRALIB+=-pg
endif

ifndef DEBUGFLAG
	DEFINES+=$(OPTIFLAG)
else
	DEFINES+=$(DEBUGFLAG)
endif



# version info
MAJVER=0
MINVER=0
PATCHLEVEL=25
VERSION=$(MAJVER).$(MINVER).$(PATCHLEVEL)
CXXVER=`$(CXX) --version`

#flower version
NEEDEFLOWERVER=1.0.20

# directories
TOPDIR  := $(shell if [ "$$PWD" != "" ]; then echo $$PWD; else pwd; fi)
OBJECTDIR=objects
HEADERDIR=hdr
CCDIR=src
INITDIR=init
DEPDIR=deps
INPUTDIR=input
#vpath %.cc $(CCDIR)
#vpath %.hh $(HEADERDIR)
#vpath %.y $(CCDIR)
#vpath %.l $(CCDIR)
#vpath %.o $(OBJECTDIR)
#vpath %.dep $(DEPDIR)

# 
#
include Sources.make
progdocs=$(hdr) $(mycc)
gencc=parser.cc lexer.cc
cc=$(mycc) $(gencc)

CCSOURCE=$(addprefix $(CCDIR)/, $(cc))
obs=$(addprefix $(OBJECTDIR)/,$(cc:.cc=.o)) 
ALLDEPS=$(addprefix $(DEPDIR)/,$(cc:.cc=.dep))

#dist
.EXPORT_ALL_VARIABLES:

DOCDIR=docdir

PACKAGENAME=lilypond
DNAME=$(PACKAGENAME)-$(VERSION)

# distribution files.
othersrc=lexer.l parser.y
SCRIPTS=make_version make_patch genheader clearlily
MAKFILES=Makefile Variables.make Sources.make Initial.make Generate.make \
	configure
OFILES=COPYING README NEWS TODO
IFILES= standchen.tex titledefs.tex pavane.tex lilyponddefs.tex test.tex .dstreamrc dimen.tex 
DFILES=$(MAKFILES) $(OFILES) $(IFILES) $(SCRIPTS)

#compiling
LOADLIBES=-L$(FLOWERDIR) -lflower $(EXTRALIB)
FLOWERDIR=../flower

CXXFLAGS=$(DEFINES) -I$(HEADERDIR) -I$(FLOWERDIR) $(EXTRACXXFLAGS)
FLEX=flex
BISON=bison
exe=$(PACKAGENAME)
OUTPUT_OPTION=$< -o $@
DDIR=$(TOPDIR)/$(DNAME)
SUBDIRS=Documentation $(OBJECTDIR) $(CCDIR) $(HEADERDIR) $(INITDIR) $(DEPDIR) \
	$(INPUTDIR)

depfile=deps/$(subst .o,.dep,$(notdir $@)) 
DODEP=rm -f $(depfile); DEPENDENCIES_OUTPUT="$(depfile) $(OBJECTDIR)/$(notdir $@)"

