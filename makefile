DIRS = kill mkdir rm sum echo

.PHONY: all $(DIRS)
all: $(DIRS)

$(DIRS): 
	as $@/*.s -o $@/$@.o -g
	ld $@/$@.o -o $@/$@
	rm $@/*.o

clean:
	@for prog in $(DIRS); do \
		echo "rm -f $$prog/$$prog"; \
		rm -f $$prog/$$prog; \
	done
