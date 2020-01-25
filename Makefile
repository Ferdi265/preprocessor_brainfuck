CC = gcc

MAX_LITERAL = 255

VARIABLES = _HALT _PRELOOP
TARGETS = $(VARIABLES:%=literals/%.h)

.PHONY: build
build: $(TARGETS)

.PHONY: clean
clean:
	rm -f $(TARGETS)

.PHONY: run
run: main.h build
	$(CC) -E $< | grep -vE '#|^$$'

define LITERAL_template =
literals/$(1).h: gen_literal.sh
	mkdir -p literals/
	./$$^ $(1) $(MAX_LITERAL) > $$@
endef

$(foreach _variable, $(VARIABLES),\
	$(eval $(call LITERAL_template,$(_variable))))
