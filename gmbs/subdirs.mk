# subdirs.mk
#
# Copyright (c) 2007 Isaac W. Foraker, all rights reserved.
#==============================================================================

ifndef NORECURSE

default clean test::
	for f in $(SUBDIRS); do $(MAKE) -C $$f $@ || exit 1 ; done

endif
