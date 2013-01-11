
.SECONDARY:

.PHONY: all
all: create_dirs bin/map2xml

.PHONY: create_dirs
create_dirs:
	mkdir -p bin gen

bin/map2xml: gen/parser.tab.c gen/lexer.yy.c src/map2xml.c
	gcc -g -Wfatal-errors $^ -o$@

gen/parser.tab.c: src/parser.y
	bison -d -o$@ $^
			
gen/lexer.yy.c: src/lexer.l
	flex -i -o$@ $^

.PHONEY: clean	
clean:
	rm -f -r bin gen

.PHONEY: test
test: all
	make -C tests/
