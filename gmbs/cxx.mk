# cxx.mk
#
# Copyright (c) 2007 Isaac W. Foraker, all rights reserved.
#==============================================================================

CFILES?=$(wildcard *.cxx *.cpp *c)

__cur_obj_dir=$(OBJDIR)/$(NAME)$(__cxxname_suf)
__lib_obj_dir=$(__cur_obj_dir)/lib
__shr_obj_dir=$(__cur_obj_dir)/shr
__bin_obj_dir=$(__cur_obj_dir)/bin
__test_obj_dir=$(OBJDIR)/$(TESTNAME)

#==============================================================================
# Convert LIBRARIES into LDFLAGS
ifeq ($(CXXVENDOR),GCC)
  LDFLAGS+=-L$(LIBDIR)
  LDLIBS+=$(foreach lib,$(LIBRARIES),-l$(lib))
endif
ifeq ($(CXXVENDOR),MS)
  LDFLAGS+=/LIBPATH:$(LIBDIR)
  LDLIBS+=$(foreach lib,$(LIBRARIES),$(lib)$(SUFLIB))
endif

#==============================================================================
ifneq (,$(filter lib,$(WHAT)))
  LIBOUT=$(LIBDIR)/$(PRELIB)$(NAME)$(SUFSTATIC)$(__cxxname_suf)$(SUFLIB)
  LIBOBJECTS=$(CFILES:%.cxx=$(__lib_obj_dir)/%$(SUFOBJ))
  LIBOBJECTS:=$(LIBOBJECTS:%.cpp=$(__lib_obj_dir)/%$(SUFOBJ))
  LIBOBJECTS:=$(LIBOBJECTS:%.c=$(__lib_obj_dir)/%$(SUFOBJ))
  __cxx_targets+=lib
  CLEANFILES+=$(LIBOUT) $(__lib_obj_dir)
endif

#==============================================================================
ifneq (,$(filter bin,$(WHAT)))
  ifneq (,$(filter test,$(WHAT)))
    $(error The 'test' target is incompatible with the 'bin' target.  Use with 'lib' or 'shr' instead.)
  endif
  BINOUT=$(BINDIR)/$(PREBIN)$(NAME)$(__cxxname_suf)$(SUFBIN)
  BINOBJECTS=$(CFILES:%.cxx=$(__bin_obj_dir)/%$(SUFOBJ))
  BINOBJECTS:=$(BINOBJECTS:%.cpp=$(__bin_obj_dir)/%$(SUFOBJ))
  BINOBJECTS:=$(BINOBJECTS:%.c=$(__bin_obj_dir)/%$(SUFOBJ))
  __cxx_targets+=bin
  CLEANFILES+=$(BINOUT) $(__bin_obj_dir)
endif

#==============================================================================
ifneq (,$(filter test,$(WHAT)))
TESTNAME?=test_$(NAME)
  __test_source_dir=$(GENSOURCEDIR)/$(TESTNAME)
  __test_source=$(__test_source_dir)/$(TESTNAME).cxx
  TESTFILES=$(wildcard test_*.h)
  TESTOUT=$(TESTDIR)/$(NAME)$(__cxxname_suf)$(SUFBIN)
  __test_source_file=$(notdir $(__test_source))
  __test_object=$(__test_source_file:%.cxx=$(__test_obj_dir)/%$(SUFOBJ))
  TESTOBJECTS+=$(if $(filter lib,$(WHAT)),$(LIBOBJECTS),$(SHROBJECTS))
  TESTOBJECTS+=$(__test_object)
  __cxx_targets+=maketest
  CLEANFILES+=$(__test_source) $(TESTOUT) $(__test_obj_dir)
endif

#==============================================================================
ifdef LIBOUT
lib: $(LIBOUT)
$(LIBOUT): $(LIBOBJECTS)
	$(MKDIR) $(dir $@)
	$(AR) $(ARFLAGS) $(AROUT)$@ $^ $(LDLIBS)
endif

#==============================================================================
ifdef BINOUT
bin: $(BINOUT)
$(BINOUT): $(BINOBJECTS)
	$(MKDIR) $(dir $@)
	$(LD) $(LDOUT)$@ $(LDFLAGS) $^ $(LDLIBS)
endif

#==============================================================================
ifdef TESTOUT
.PHONY: maketest

maketest:: $(TESTOUT)

test:: $(TESTOUT)
	$(TESTOUT)

$(__test_source): $(TESTFILES)
	$(MKDIR) $(dir $@)
	$(CXXTESTGEN) --error-printer -o $@ $^

$(TESTOUT): $(TESTOBJECTS)
	$(MKDIR) $(dir $@)
	$(LD) $(LDOUT)$@ $(LDFLAGS) $^ $(LDLIBS)

endif

#==============================================================================
default:: $(__cxx_targets)
#==============================================================================
__cc_command=$(__debug_tr4)$(strip $(MKDIR) $(dir $1) && \
	     $(CC) $(CPPFLAGS) $3 $(CFLAGS) $4 -o $1 -c $2)
__cxx_command=$(__debug_tr4)$(strip $(MKDIR) $(dir $1) && \
	      $(CXX) $(CPPFLAGS) $3 $(CXXFLAGS) $4 -o $1 -c $2)

#==============================================================================
# Lib objects
$(__lib_obj_dir)/%$(SUFOBJ) : %.c
	$(call __cc_command,$@,$<,$(LIBCPPFLAGS),$(LIBCFLAGS))

$(__lib_obj_dir)/%$(SUFOBJ) : %.cpp
	$(call __cxx_command,$@,$<,$(LIBCPPFLAGS),$(LIBCXXFLAGS))

$(__lib_obj_dir)/%$(SUFOBJ) : %.cxx
	$(call __cxx_command,$@,$<,$(LIBCPPFLAGS),$(LIBCXXFLAGS))

#==============================================================================
# Bin objects
$(__bin_obj_dir)/%$(SUFOBJ) : %.c
	$(call __cc_command,$@,$<,$(BINCPPFLAGS),$(BINCFLAGS))

$(__bin_obj_dir)/%$(SUFOBJ) : %.cpp
	$(call __cxx_command,$@,$<,$(BINCPPFLAGS),$(BINCXXFLAGS))

$(__bin_obj_dir)/%$(SUFOBJ) : %.cxx
	$(call __cxx_command,$@,$<,$(BINCPPFLAGS),$(BINCXXFLAGS))

#==============================================================================
# Shr objects
$(__shr_obj_dir)/%$(SUFOBJ) : %.c
	$(call __cc_command,$@,$<,$(SHRCPPFLAGS),$(SHRCFLAGS))

$(__shr_obj_dir)/%$(SUFOBJ) : %.cpp
	$(call __cxx_command,$@,$<,$(SHRCPPFLAGS),$(SHRCXXFLAGS))

$(__shr_obj_dir)/%$(SUFOBJ) : %.cxx
	$(call __cxx_command,$@,$<,$(SHRCPPFLAGS),$(SHRCXXFLAGS))

#==============================================================================
# Test objects
$(__test_obj_dir)/%$(SUFOBJ) : $(__test_source_dir)/%.cxx
	$(call __cxx_command,$@,$<,$(TESTCPPFLAGS),$(TESTCXXFLAGS))
