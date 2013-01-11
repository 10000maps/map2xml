

project: create_dirs bin/map2xml

create_dirs:
	mkdir -p bin gen

bin/map2xml: gen/mapfileparser.tab.c gen/mapfile.yy.c src/mapfilexml.c
	gcc -g -Wfatal-errors $^ -o$@

gen/mapfileparser.tab.c: src/mapfileparser.y
	bison -d -o$@ $^
			
gen/mapfile.yy.c: src/mapfilelexer.l
	flex -i -o$@ $^

	
.PHONEY: project create_dirs test test2 memtest clean

test: testmap testlayerset testsymbolset
	
testmap: project
	mkdir -p tests/tmp
	xsltproc data/mapfile.xsl tests/mapfile-test.xml | bin/map2xml > tests/tmp/mapfile-test.xml
	xmllint --noout --schema data/mapfile.xsd tests/tmp/mapfile-test.xml
	xsltproc data/mapfile.xsl tests/tmp/mapfile-test.xml > tests/tmp/mapfile-test.map
	xsltproc data/mapfile.xsl tests/mapfile-test.xml | diff -y - tests/tmp/mapfile-test.map
	
testlayerset: project
	mkdir -p tests/tmp
	xsltproc data/mapfile.xsl tests/layerset.xml | bin/map2xml > tests/tmp/layerset.xml
	xmllint --noout --schema data/mapfile.xsd tests/tmp/layerset.xml
	xsltproc data/mapfile.xsl tests/tmp/layerset.xml > tests/tmp/layerset.map
	xsltproc data/mapfile.xsl tests/layerset.xml | diff -y - tests/tmp/layerset.map

testsymbolset: project
	mkdir -p tests/tmp
	xsltproc data/mapfile.xsl tests/symbolset.xml | bin/map2xml > tests/tmp/symbolset.xml
	xmllint --noout --schema data/mapfile.xsd tests/tmp/symbolset.xml
	xsltproc data/mapfile.xsl tests/tmp/symbolset.xml > tests/tmp/symbolset.map
	xsltproc data/mapfile.xsl tests/symbolset.xml | diff -y - tests/tmp/symbolset.map

memtest: project
	xsltproc data/mapfile.xsl tests/mapfile-test.xml | valgrind bin/map2xml
	xsltproc data/mapfile.xsl tests/layerset.xml | valgrind bin/map2xml
	xsltproc data/mapfile.xsl tests/symbolset.xml | valgrind bin/map2xml
	
clean:
	rm -f -r bin gen
