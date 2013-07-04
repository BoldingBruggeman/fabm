#$Id$

SHELL   = /bin/sh

# The compilation mode is obtained from $COMPILATION_MODE - 
# default production - else debug or profiling
ifndef COMPILATION_MODE
compilation=production
else
compilation=$(COMPILATION_MODE)
endif

DEFINES=-D$(FORTRAN_COMPILER)

FEATURES	=
FEATURE_LIBS	=
EXTRA_LIBS	=
INCDIRS		=
LDFLAGS		=

#
# phony targets
#
.PHONY: clean realclean distclean dummy

# Top of this version of FABM.
ifndef FABMDIR
FABMDIR := $(HOME)/FABM/fabm-git
endif
ifeq ($(wildcard $(FABMDIR)/src/fabm.F90),)
$(error the directory FABMDIR=$(FABMDIR) is not a valid FABM directory)
endif

ifndef FABMHOST
FABMHOST = gotm
endif

CPP	= /lib/cpp

FEATURES += fabm
FEATURE_LIBS += -lfabm$(buildtype)
INCDIRS	+= -I$(FABMDIR)/src/drivers/$(FABMHOST)

# Directory related settings.

ifndef BINDIR
BINDIR	= $(FABMDIR)/bin
endif

ifndef LIBDIR
LIBDIR	= $(FABMDIR)/lib/$(FABMHOST)/$(FORTRAN_COMPILER)
endif

LIBFABM = $(LIBDIR)/libfabm$(buildtype).a

ifndef MODDIR
MODDIR	= $(FABMDIR)/modules/$(FABMHOST)/$(FORTRAN_COMPILER)
endif
INCDIRS	+= -I/usr/local/include -I$(FABMDIR)/include -I$(MODDIR)

ifdef FABM_PMLERSEM
DEFINES += -DFABM_PMLERSEM
endif

ifdef FABM_F2003
DEFINES += -D_FABM_F2003_
endif

# Normally this should not be changed - unless you want something very specific.

# The Fortran compiler is determined from the EV FORTRAN_COMPILER - options 
# sofar NAG(linux), FUJITSU(Linux), DECF90 (OSF1 and likely Linux on alpha),
# SunOS, PGF90 - Portland Group Fortran Compiler (on Intel Linux).

# Sets options for debug compilation
ifeq ($(compilation),debug)
buildtype = _debug
DEFINES += -DDEBUG $(STATIC)
FLAGS   = $(DEBUG_FLAGS) 
endif

# Sets options for profiling compilation
ifeq ($(compilation),profiling)
buildtype = _prof
DEFINES += -DPROFILING $(STATIC)
FLAGS   = $(PROF_FLAGS) 
endif

# Sets options for production compilation
ifeq ($(compilation),production)
buildtype = _prod
DEFINES += -DPRODUCTION $(STATIC)
FLAGS   = $(PROD_FLAGS) 
endif

include $(FABMDIR)/compilers/compiler.$(FORTRAN_COMPILER)

# For making the source code documentation.
PROTEX	= protex -b -n -s

.SUFFIXES:
.SUFFIXES: .F90

LINKDIRS	+= -L$(LIBDIR)

CPPFLAGS	= $(DEFINES) $(INCDIRS)
FFLAGS  	= $(DEFINES) $(FLAGS) $(MODULES) $(INCDIRS) $(EXTRAS)
F90FLAGS  	= $(FFLAGS)
LDFLAGS		+= $(FFLAGS) $(LINKDIRS)

#
# Common rules
#
ifeq  ($(can_do_F90),true)
%.o: %.F90
#	@ echo "Compiling $<"
	$(FC) $(F90FLAGS) $(EXTRA_FFLAGS) -c $< -o $@
else
%.f90: %.F90
#	$(CPP) $(CPPFLAGS) $< -o $@
	$(F90_to_f90)
%.o: %.f90
	$(FC) $(F90FLAGS) $(EXTRA_FFLAGS) -c $< -o $@
endif
