

.PHONEY: test test2 memtest clean


bin/mapfileparser: mapfileparser.tab.c mapfile.yy.c mapfilexml.c
	gcc -g -Wfatal-errors mapfile.yy.c mapfileparser.tab.c mapfilexml.c -o$@
	
mapfileparser.tab.c: mapfileparser.y
	bison -d mapfileparser.y
		
mapfile.yy.c: mapfilelexer.l
	flex -i -omapfile.yy.c mapfilelexer.l


test: bin/mapfileparser
	xsltproc mapfile.xsl maps/test.xml | bin/mapfileparser > temp.xml
	xmllint --noout --schema mapfile.xsd temp.xml
	xsltproc mapfile.xsl temp.xml > temp.map
	xsltproc mapfile.xsl maps/test.xml > temp2.map
	diff temp2.map temp.map
	
test2: bin/mapfileparser
	xsltproc mapfile.xsl maps/test.xml | bin/mapfileparser

memtest: bin/mapfileparser
	xsltproc mapfile.xsl maps/test.xml | valgrind bin/mapfileparser
	
clean:
	rm -f mapfileparser.tab.c
	rm -f mapfileparser.tab.h
	rm -f mapfile.yy.c
	rm -f bin/*
