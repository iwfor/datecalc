# dist.mk
#
# Copyright (c) 2007 Isaac W. Foraker, all rights reserved.
#==============================================================================

ifdef DISTTO
  __dist_dir=$(DISTDIR)/$(DISTTO)
else
  __dist_dir=$(DISTDIR)
endif

__dist_out_files=$(DISTFILES:%=$(__dist_dir)/%)
CLEANFILES+=$(__dist_out_files)

default:: dist

dist:: $(__dist_out_files)

$(__dist_dir)/% : %
	$(MKDIR) $(dir $@)
	$(CP) $< $@
