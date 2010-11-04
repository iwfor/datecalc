TOP?=.
SUBDIRS=src
include $(TOP)/gmbs/rules.mk

clean::
	$(RM) dist work
