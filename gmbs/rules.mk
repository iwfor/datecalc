# rules.mk
#
# Copyright (c) 2007 Isaac W. Foraker, all rights reserved.
#==============================================================================
ifndef TOP
  $(error TOP not defined)
endif
#==============================================================================
# Get the gmbs include dir.
__gmbs_dir:=$(patsubst %rules.mk,%,$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
#==============================================================================
# Set NAME if not specified.
NAME?=$(not-dir $(CURDIR))
#==============================================================================
include $(__gmbs_dir)debug.mk
include $(__gmbs_dir)os.mk
include $(__gmbs_dir)cxxvars.mk
#==============================================================================
WORKDIR?=$(TOP)/work
OBJDIR?=$(WORKDIR)/obj
GENDIR?=$(WORKDIR)/gen
GENSOURCEDIR?=$(GENDIR)/src
DISTDIR?=$(TOP)/dist
LIBDIR?=$(DISTDIR)/lib
BINDIR?=$(DISTDIR)/bin
SHRDIR?=$(if $(ISWINDOWS),$(BINDIR),$(LIBDIR))
DOCDIR?=$(DISTDIR)/share/doc
TESTDIR?=$(WORKDIR)/test

MKDIR=mkdir -p
RM=rm -rf
CP=cp

#==============================================================================
-include $(TOP)/project.mk
#==============================================================================
.PHONY: default all test clean

default::

all:: default test

test::

#==============================================================================
ifdef SUBDIRS
  include $(__gmbs_dir)subdirs.mk
endif
#==============================================================================
ifdef DISTFILES
  include $(__gmbs_dir)dist.mk
endif
#==============================================================================
ifneq (,$(filter lib bin shr test,$(WHAT)))
  include $(__gmbs_dir)cxx.mk
endif
#==============================================================================
# The clean target goes after all includes.
clean::
ifdef CLEANFILES
	$(RM) $(CLEANFILES)
endif
