CPP = cpp

DEBUG = 0
ifeq ($(DEBUG),1)
CPPFLAGS = -P -DDEBUG
else
CPPFLAGS = -P
endif

RUNLOOP_DEPTH = 4
RUNLOOP_WIDTH = 256

MAX_LITERAL = 255
MAX_CODE = 1024
MAX_INPUT = 1024
MAX_TAPE = 1024

VARIABLES = NESTCOUNT
TARGETS = $(VARIABLES:%=literals/%.h) bf_init.h init_T.h shift_T.h rshift_T.h shift_C.h rshift_C.h shift_I.h

.PHONY: build
build: $(TARGETS) bf_run_d literal_T literal_C literal_I

.PHONY: clean
clean:
	rm -f literals/*
	rm -f bf_run_d*.h
	rm -f $(TARGETS)

.PHONY: run
run: main.h
	$(CPP) $(CPPFLAGS) $< | grep -vE '#|^$$'

bf_init.h: bf_init.h.in
	sed 's/@@MAX_TAPE@@/$(MAX_TAPE)/g' $^ > $@

.PHONY: bf_run_d
bf_run_d: gen_runloop.sh
	./$^ $(RUNLOOP_DEPTH) $(RUNLOOP_WIDTH)

init_T.h: gen_init.sh
	./$^ T $(MAX_TAPE) > $@

shift_T.h: gen_shift.sh
	./$^ T $(MAX_TAPE) $(MAX_TAPE) > $@

rshift_T.h: gen_rshift.sh
	./$^ T $(MAX_TAPE) $(MAX_TAPE) > $@

.PHONY: literal_T
literal_T: gen_literal.sh
	for i in $$(seq 0 $(MAX_TAPE)); do \
		./$^ Tm$$i $(MAX_LITERAL) > literals/Tm$$i.h; \
	done
	for i in $$(seq 0 $$(($(MAX_TAPE) - 1))); do \
		./$^ T$$i $(MAX_LITERAL) > literals/T$$i.h; \
	done
	./$^ Tc $(MAX_TAPE) > literals/Tc.h
	./$^ Tr $(MAX_TAPE) > literals/Tr.h

shift_C.h: gen_shift.sh
	./$^ C $(MAX_CODE) $(MAX_CODE) > $@

rshift_C.h: gen_rshift.sh
	./$^ C $(MAX_CODE) $(MAX_CODE) > $@

.PHONY: literal_C
literal_C: gen_literal.sh
	for i in $$(seq 0 $(MAX_CODE)); do \
		./$^ Cm$$i $(MAX_LITERAL) > literals/Cm$$i.h; \
	done
	for i in $$(seq 0 $$(($(MAX_CODE) - 1))); do \
		./$^ C$$i $(MAX_LITERAL) > literals/C$$i.h; \
	done
	./$^ Cc $(MAX_CODE) > literals/Cc.h
	./$^ Cr $(MAX_CODE) > literals/Cr.h

shift_I.h: gen_shift.sh
	./$^ I $(MAX_INPUT) $(MAX_INPUT) > $@

.PHONY: literal_I
literal_I: gen_literal.sh
	for i in $$(seq 0 $$(($(MAX_INPUT) - 1))); do \
		./$^ I$$i $(MAX_LITERAL) > literals/I$$i.h; \
	done
	./$^ Ic $(MAX_INPUT) > literals/Ic.h
	./$^ Ir $(MAX_INPUT) > literals/Ir.h

define LITERAL_template =
literals/$(1).h: gen_literal.sh
	mkdir -p literals/
	./$$^ $(1) $(MAX_LITERAL) > $$@
endef

$(foreach _variable, $(VARIABLES),\
	$(eval $(call LITERAL_template,$(_variable))))
