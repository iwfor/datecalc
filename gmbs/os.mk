# os.mk
#
# Copyright (c) 2007 Isaac W. Foraker, all rights reserved.
#==============================================================================

# Try to determine OS name without shelling out to uname if possible.
ifndef __uname
  export __uname:=$(OSNAME)
endif
ifndef __uname
  export __uname:=$(OSTYPE)
endif
ifndef __uname
  export __uname:=$(if $(COMSPEC),Windows,)
endif
ifndef __uname
  export __uname:=$(shell uname)
endif

ifeq ($(__uname),cygwin)
  PLATFORM_CYGWIN=1
  ISWINDOWS=1
endif
ifeq ($(__uname),Darwin)
  PLATFORM_DARWIN=1
  ISBSD=1
  ISUNIX=1
endif
ifeq ($(__uname),FreeBSD)
  PLATFORM_FREEBSD=1
  ISBSD=1
  ISUNIX=1
endif
ifeq ($(__uname),Linux)
  PLATFORM_LINUX=1
endif
