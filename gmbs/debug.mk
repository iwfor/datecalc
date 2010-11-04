# debug.mk
#
# Copyright (c) 2007 Isaac W. Foraker, all rights reserved.
#==============================================================================

ifdef TRACE
	__debug_tr1=$(warning $0($1))
	__debug_tr2=$(warning $0($1,$2))
	__debug_tr3=$(warning $0($1,$2,$3))
	__debug_tr4=$(warning $0($1,$2,$3,$4))
endif

print-%:
	@echo '$*="${$*}" [$(value $*)]'

dump-%:
	@echo '$*=${$*}'
