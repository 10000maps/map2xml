

.PHONEY: test clean


bin/mapfileparser: mapfileparser.tab.c mapfile.yy.c mapfilexml.c
	gcc -Wfatal-errors mapfile.yy.c mapfileparser.tab.c mapfilexml.c -o$@
	
mapfileparser.tab.c: mapfileparser.y
	bison -d mapfileparser.y
		
mapfile.yy.c: mapfilelexer.l
	flex -i -omapfile.yy.c mapfilelexer.l


test: bin/mapfileparser
	bin/mapfileparser < maps/test1.map
	
clean:
	rm -f mapfileparser.tab.c
	rm -f mapfileparser.tab.h
	rm -f mapfile.yy.c
	rm -f bin/*
