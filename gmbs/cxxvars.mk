# cxxvars.mk
#
# Copyright (c) 2007 Isaac W. Foraker, all rights reserved.
#==============================================================================

# Supported Vendors: GCC, MS
CXXVENDOR?=GCC

ifdef DEBUG
  __cxxname_suf=d
endif
SUFSTATIC?=s

SUFOBJ=.o
SUFLIB=.a

ifdef ISUNIX
  PRELIB=lib
  ifdef PLATFORM_DARWIN
    SUFSHR=.dylib
  else
    SUFSHR=.so
  endif
endif
ifdef ISWINDOWS
  ifeq ($(CXXVENDOR),MS)
    SUFLIB:=.lib
    SUFOBJ:=.obj
  endif
  SUFBIN=.exe
  SUFSHR=.dll
endif

ifeq ($(CXXVENDOR),GCC)
  CC=gcc
  CXX=g++
  AR=ar
  SAR=g++
  LD=g++
  CXXFLAGS+=-Wall
  CFLAGS+=-Wall
  ARFLAGS=r
  # Note: There is a purposeful space after -o
  LDOUT=-o 
  ifdef DEBUG
    CXXFLAGS=-g
    CFLAGS=-g
  else
    CXXFLAGS=-O2
    CFLAGS=-O2
  endif
endif
ifeq ($(CXXVENDOR),MS)
  CC=cl /nologo
  CXX=cl /nologo
  AR=link /nologo /lib
  SAR=link /nologo /dll
  LIB=link /nologo
  CXXFLAGS+=-EHsc -W3 -Wp64
  CFLAGS+=-W3 -Wp64
  AROUT=/out:
  LDOUT=/out:
  ifdef DEBUG
    CXXFLAGS+=-Od -Z7
    CFLAGS+=-Od -Z7
    LDFLAGS+=/debug
    SARFLAGS+=/debug
  else
    CPPFLAGS+=-DNDEBUG
    CXXFLAGS+=-Ox
    CFLAGS+=-Ox
  endif
endif

#==============================================================================
# CxxTest variables
CXXTEST=$(TOP)/vendor/cxxtest
CXXTESTGEN=$(CXXTEST)/cxxtestgen.pl
TESTCPPFLAGS+=-I$(CXXTEST) -I.
