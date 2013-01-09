

project: create_dirs bin/map2xml5 bin/map2xml6

create_dirs:
	mkdir -p bin gen

bin/map2xml6: gen/parser6.tab.c gen/lexer6.yy.c src/mapfilexml.c
	gcc -g -Wfatal-errors $^ -o$@

gen/parser6.tab.c: src/parser6.y
	bison -d -o$@ $^
			
gen/lexer6.yy.c: src/lexer6.l
	flex -i -o$@ $^

bin/map2xml5: gen/parser5.tab.c gen/lexer5.yy.c src/mapfilexml.c
	gcc -g -Wfatal-errors $^ -o$@

gen/parser5.tab.c: src/parser5.y
	bison -d -o$@ $^
			
gen/lexer5.yy.c: src/lexer5.l
	flex -i -o$@ $^    
    
	
.PHONEY: project create_dirs test6 testmap6 testlayerset6 testsymbolset6 memtest6 test5 testmap5 testlayerset5 testsymbolset5 memtest5

test6: testmap6 testlayerset6 testsymbolset6
	
testmap6: project
	mkdir -p tests/6/tmp
	xsltproc data/6/mapfile.xsl tests/6/mapfile-test.xml | bin/map2xml6 > tests/6/tmp/mapfile-test.xml
	xmllint --noout --schema data/6/mapfile.xsd tests/6/tmp/mapfile-test.xml
	xsltproc data/6/mapfile.xsl tests/6/tmp/mapfile-test.xml > tests/6/tmp/mapfile-test.map
	xsltproc data/6/mapfile.xsl tests/6/mapfile-test.xml | diff -y - tests/6/tmp/mapfile-test.map
	
testlayerset6: project
	mkdir -p tests/6/tmp
	xsltproc data/6/mapfile.xsl tests/6/layerset.xml | bin/map2xml6 > tests/6/tmp/layerset.xml
	xmllint --noout --schema data/6/mapfile.xsd tests/6/tmp/layerset.xml
	xsltproc data/6/mapfile.xsl tests/6/tmp/layerset.xml > tests/6/tmp/layerset.map
	xsltproc data/6/mapfile.xsl tests/6/layerset.xml | diff -y - tests/6/tmp/layerset.map

testsymbolset6: project
	mkdir -p tests/6/tmp
	xsltproc data/6/mapfile.xsl tests/6/symbolset.xml | bin/map2xml6 > tests/6/tmp/symbolset.xml
	xmllint --noout --schema data/6/mapfile.xsd tests/6/tmp/symbolset.xml
	xsltproc data/6/mapfile.xsl tests/6/tmp/symbolset.xml > tests/6/tmp/symbolset.map
	xsltproc data/6/mapfile.xsl tests/6/symbolset.xml | diff -y - tests/6/tmp/symbolset.map

memtest6: project
	xsltproc data/6/mapfile.xsl tests/6/mapfile-test.xml | valgrind bin/map2xml6
	xsltproc data/6/mapfile.xsl tests/6/layerset.xml | valgrind bin/map2xml6
	xsltproc data/6/mapfile.xsl tests/6/symbolset.xml | valgrind bin/map2xml6
 
test5: testmap5 testlayerset5 testsymbolset5
	
testmap5: project
	mkdir -p tests/5/tmp
	xsltproc data/5/mapfile.xsl tests/5/mapfile-test.xml | bin/map2xml5 > tests/5/tmp/mapfile-test.xml
	xmllint --noout --schema data/5/mapfile.xsd tests/5/tmp/mapfile-test.xml
	xsltproc data/5/mapfile.xsl tests/5/tmp/mapfile-test.xml > tests/5/tmp/mapfile-test.map
	xsltproc data/5/mapfile.xsl tests/5/mapfile-test.xml | diff -y - tests/5/tmp/mapfile-test.map
	
testlayerset5: project
	mkdir -p tests/5/tmp
	xsltproc data/5/mapfile.xsl tests/5/layerset.xml | bin/map2xml5 > tests/5/tmp/layerset.xml
	xmllint --noout --schema data/5/mapfile.xsd tests/5/tmp/layerset.xml
	xsltproc data/5/mapfile.xsl tests/5/tmp/layerset.xml > tests/5/tmp/layerset.map
	xsltproc data/5/mapfile.xsl tests/5/layerset.xml | diff -y - tests/5/tmp/layerset.map

testsymbolset5: project
	mkdir -p tests/5/tmp
	xsltproc data/5/mapfile.xsl tests/5/symbolset.xml | bin/map2xml5 > tests/5/tmp/symbolset.xml
	xmllint --noout --schema data/5/mapfile.xsd tests/5/tmp/symbolset.xml
	xsltproc data/5/mapfile.xsl tests/5/tmp/symbolset.xml > tests/5/tmp/symbolset.map
	xsltproc data/5/mapfile.xsl tests/5/symbolset.xml | diff -y - tests/5/tmp/symbolset.map

memtest5: project
	xsltproc data/5/mapfile.xsl tests/5/mapfile-test.xml | valgrind bin/map2xml5
	xsltproc data/5/mapfile.xsl tests/5/layerset.xml | valgrind bin/map2xml5
	xsltproc data/5/mapfile.xsl tests/5/symbolset.xml | valgrind bin/map2xml5
    
    
	
clean:
	rm -f -r bin gen
