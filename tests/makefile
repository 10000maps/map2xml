

testfiles := mapfile-test layerset symbolset
.SECONDARY:

all: test6

tmp/6/orig.%.map: 6/%.xml
	xsltproc 6/mapfile.xsl $^ > $@

tmp/6/new.%.xml: tmp/6/orig.%.map
	../bin/map2xml6 < $^ > $@
	
tmp/6/new.%.map: tmp/6/new.%.xml
	xsltproc 6/mapfile.xsl $^ > $@

.PHONY: test%6
test%6: tmp/6/orig.%.map tmp/6/new.%.map
	diff $^
	#end of diff

.PHONY: test6	
test6: dependecy clean $(foreach file,$(testfiles),test$(file)6)
	#tests complete

.PHONY: memtest%6
memtest%6: tmp/6/orig.%.map
	valgrind ../bin/map2xml6 < $^
	
.PHONY: memtest6
memtest6: $(foreach file,$(testfiles),memtest$(file)6)
	#tests complete

tmp/5/orig.%.map: 5/%.xml
	xsltproc 5/mapfile.xsl $^ > $@

tmp/5/new.%.xml: tmp/5/orig.%.map
	../bin/map2xml5 < $^ > $@
	
tmp/5/new.%.map: tmp/5/new.%.xml
	xsltproc 5/mapfile.xsl $^ > $@

.PHONY: test%5
test%5: tmp/5/orig.%.map tmp/5/new.%.map
	diff $^
	#end of diff

.PHONY: test5	
test5: $(foreach file,$(testfiles),test$(file)5)
	#tests complete

.PHONY: memtest%5
memtest%5: tmp/5/orig.%.map
	valgrind ../bin/map2xml5 < $^
	
.PHONY: memtest5
memtest5: $(foreach file,$(testfiles),memtest$(file)5)
	#tests complete
	
.PHONY: clean
clean:
	rm -r -f tmp
	mkdir -p tmp/5 tmp/6
	
.PHONY: dependecy
dependecy:
	cd ..;make