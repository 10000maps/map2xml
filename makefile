
.PHONEY: xml lex test

test: bin/mapfileparser
	bin/mapfileparser < maps/test1.map

bin/mapfileparser: mapfileparser.tab.c mapfile.yy.c mapfilexml.c
	gcc -Wfatal-errors mapfile.yy.c mapfileparser.tab.c mapfilexml.c -o$@
	
xml: bin/mapfilexmltest
	bin/mapfilexmltest 

bin/mapfilexmltest: mapfilexmltest.c mapfilexml.c
	gcc mapfilexmltest.c mapfilexml.c -o $@
	
lex: bin/mapfilelexer
	bin/mapfilelexer < maps/test1.map
	
bin/mapfilelexer: mapfileparser.tab.c mapfile.yy.c mapfilelexer.c
	gcc -Werror -Wfatal-errors mapfile.yy.c -o $@ 
	
mapfileparser.tab.c: mapfileparser.y
	bison -d mapfileparser.y
	
mapfilelexer.c:
	
mapfile.yy.c: mapfilelexer.l
	flex -i -omapfile.yy.c mapfilelexer.l
	

