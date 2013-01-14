%{

int lineNumber = 0;
#include <string.h>
#include <stdlib.h>
#include "../gen/parser.tab.h"

/* *** if this is changed***
remember to also update the function to return a string */
#define debugPrint(str) /*fprintf(stderr,"%s\n",str)*/
#define setToken(token) debugPrint(yytext);yylval.str = 0;return(token)
#define setTokenAndString(token) debugPrint(yytext);yylval.str = strdup(yytext);return(token)

YYSTYPE yylval;
int open_parens = 0;


%}

%x PAREN_EXP


%%
[ \t\r]+                  // ignore whitespace
#.*                       // ignore comments
\n                        { lineNumber++; }

align                     { setToken(ALIGN); }
alphacolor                { setToken(ALPHACOLOR); }
anchorpoint               { setToken(ANCHORPOINT); }
angle                     { setToken(ANGLE); }
antialias                 { setToken(ANTIALIAS); }
backgroundcolor           { setToken(BACKGROUNDCOLOR); }
backgroundshadowcolor     { setToken(BACKGROUNDSHADOWCOLOR); }
backgroundshadowsize      { setToken(BACKGROUNDSHADOWSIZE); }
bandsitem                 { setToken(BANDSITEM); }
browseformat              { setToken(BROWSEFORMAT); }
buffer                    { setToken(BUFFER); }
character                 { setToken(CHARACTER); }
class                     { setToken(CLASS); }
classitem                 { setToken(CLASSITEM); }
classgroup                { setToken(CLASSGROUP); }
cluster                   { setToken(CLUSTER); }
color                     { setToken(COLOR); }
config                    { setToken(CONFIG); }
connection                { setToken(CONNECTION); }
connectiontype            { setToken(CONNECTIONTYPE); }
data                      { setToken(DATA); }
datapattern               { setToken(DATAPATTERN); }
debug                     { setToken(DEBUG); }
driver                    { setToken(DRIVER); }
dump                      { setToken(DUMP); }
empty                     { setToken(EMPTY); }
encoding                  { setToken(ENCODING); }
end                       { setToken(END); }
error                     { setToken(ERROR); }
expression                { setToken(EXPRESSION); }
extent                    { setToken(EXTENT); }
extension                 { setToken(EXTENSION); }
feature                   { setToken(FEATURE); }
filled                    { setToken(FILLED); }
filter                    { setToken(FILTER); }
filteritem                { setToken(FILTERITEM); }
footer                    { setToken(FOOTER); }
font                      { setToken(FONT); }
fontset                   { setToken(FONTSET); }
force                     { setToken(FORCE); }
formatoption              { setToken(FORMATOPTION); }
from                      { setToken(FROM); }
gap                       { setToken(GAP); }
geomtransform             { setToken(GEOMTRANSFORM); }
grid                      { setToken(GRID); }
gridstep                  { setToken(GRIDSTEP); }
graticule                 { setToken(GRATICULE); }
group                     { setToken(GROUP); }
header                    { setToken(HEADER); }
image                     { setToken(IMAGE); }
imagecolor                { setToken(IMAGECOLOR); }
imagetype                 { setToken(IMAGETYPE); }
imagequality              { setToken(IMAGEQUALITY); }
imagemode                 { setToken(IMAGEMODE); }
imagepath                 { setToken(IMAGEPATH); }
imageurl                  { setToken(IMAGEURL); }
include                   { setToken(INCLUDE); }
index                     { setToken(INDEX); }
initialgap                { setToken(INITIALGAP); }
interlace                 { setToken(INTERLACE); }
intervals                 { setToken(INTERVALS); } 
join                      { setToken(JOIN); }
keyimage                  { setToken(KEYIMAGE); }
keysize                   { setToken(KEYSIZE); }
keyspacing                { setToken(KEYSPACING); }
label                     { setToken(LABEL); }
labelcache                { setToken(LABELCACHE); }
labelformat               { setToken(LABELFORMAT); }
labelitem                 { setToken(LABELITEM); }
labelmaxscale             { setToken(LABELMAXSCALE); }
labelmaxscaledenom        { setToken(LABELMAXSCALEDENOM); }
labelminscale             { setToken(LABELMINSCALE); }
labelminscaledenom        { setToken(LABELMINSCALEDENOM); }
labelrequires             { setToken(LABELREQUIRES); }
latlon                    { setToken(LATLON); }
layer                     { setToken(LAYER); }
leader                    { setToken(LEADER); }
legend                    { setToken(LEGEND); }
legendformat              { setToken(LEGENDFORMAT); }
linecap                   { setToken(LINECAP); }
linejoin                  { setToken(LINEJOIN); }
linejoinmaxsize           { setToken(LINEJOINMAXSIZE); }
log                       { setToken(LOG); }
map                       { setToken(MAP); }
marker                    { setToken(MARKER); }
markersize                { setToken(MARKERSIZE); }
mask                      { setToken(MASK); }
maxarcs                   { setToken(MAXARCS); }
maxboxsize                { setToken(MAXBOXSIZE); }
maxdistance               { setToken(MAXDISTANCE); }
maxfeatures               { setToken(MAXFEATURES); }
maxinterval               { setToken(MAXINTERVAL); }
maxoverlapangle           { setToken(MAXOVERLAPANGLE); }
maxscale                  { setToken(MAXSCALE); }
maxscaledenom             { setToken(MAXSCALEDENOM); }
maxgeowidth               { setToken(MAXGEOWIDTH); }
maxlength                 { setToken(MAXLENGTH); }
maxsize                   { setToken(MAXSIZE); }
maxsubdivide              { setToken(MAXSUBDIVIDE); }
maxtemplate               { setToken(MAXTEMPLATE); }
maxwidth                  { setToken(MAXWIDTH); }
metadata                  { setToken(METADATA); }
mimetype                  { setToken(MIMETYPE); }
minarcs                   { setToken(MINARCS); }
minboxsize                { setToken(MINBOXSIZE); }
mindistance               { setToken(MINDISTANCE); }
minfeaturesize            { setToken(MINFEATURESIZE); }
mininterval               { setToken(MININTERVAL); }
minscale                  { setToken(MINSCALE); }
minscaledenom             { setToken(MINSCALEDENOM); }
mingeowidth               { setToken(MINGEOWIDTH); }
minlength                 { setToken(MINLENGTH); }
minsize                   { setToken(MINSIZE); }
minsubdivide              { setToken(MINSUBDIVIDE); }
mintemplate               { setToken(MINTEMPLATE); }
minwidth                  { setToken(MINWIDTH); }
name                      { setToken(NAME); }
offset                    { setToken(OFFSET); }
offsite                   { setToken(OFFSITE); }
opacity                   { setToken(OPACITY); }
outlinecolor              { setToken(OUTLINECOLOR); }
outlinewidth              { setToken(OUTLINEWIDTH); }
outputformat              { setToken(OUTPUTFORMAT); }
overlaybackgroundcolor    { setToken(OVERLAYBACKGROUNDCOLOR); }
overlaycolor              { setToken(OVERLAYCOLOR); }
overlaymaxsize            { setToken(OVERLAYMAXSIZE); }
overlayminsize            { setToken(OVERLAYMINSIZE); }
overlayoutlinecolor       { setToken(OVERLAYOUTLINECOLOR); }
overlaysize               { setToken(OVERLAYSIZE); }
overlaysymbol             { setToken(OVERLAYSYMBOL); }
partials                  { setToken(PARTIALS); }
pattern                   { setToken(PATTERN); }
plugin                    { setToken(MS_PLUGIN); }
points                    { setToken(POINTS); }
polaroffset               { setToken(POLAROFFSET); }
items                     { setToken(ITEMS); }
position                  { setToken(POSITION); }
postlabelcache            { setToken(POSTLABELCACHE); }
priority                  { setToken(PRIORITY); }
processing                { setToken(PROCESSING); }
projection                { setToken(PROJECTION); }
queryformat               { setToken(QUERYFORMAT); }
querymap                  { setToken(QUERYMAP); }
reference                 { setToken(REFERENCE); }
region                    { setToken(REGION); }
relativeto                { setToken(RELATIVETO); }
repeatdistance            { setToken(REPEATDISTANCE); }
requires                  { setToken(REQUIRES); }
resolution                { setToken(RESOLUTION); }
defresolution             { setToken(DEFRESOLUTION); }
scale                     { setToken(SCALE); }
scaledenom                { setToken(SCALEDENOM); }
scalebar                  { setToken(SCALEBAR); }
shadowcolor               { setToken(SHADOWCOLOR); }
shadowsize                { setToken(SHADOWSIZE); }
shapepath                 { setToken(SHAPEPATH); }
size                      { setToken(SIZE); }
sizeunits                 { setToken(SIZEUNITS); }
status                    { setToken(STATUS); }
style                     { setToken(STYLE); }
styleitem                 { setToken(STYLEITEM); }
symbol                    { setToken(SYMBOL); }
symbolscale               { setToken(SYMBOLSCALE); }
symbolscaledenom          { setToken(SYMBOLSCALEDENOM); }
symbolset                 { setToken(SYMBOLSET); }
table                     { setToken(TABLE); }
template                  { setToken(TEMPLATE); }
templatepattern           { setToken(TEMPLATEPATTERN); }
text                      { setToken(TEXT); }
tileindex                 { setToken(TILEINDEX); }
tileitem                  { setToken(TILEITEM); }
title                     { setToken(TITLE); }
to                        { setToken(TO); }
tolerance                 { setToken(TOLERANCE); }
toleranceunits            { setToken(TOLERANCEUNITS); }
transparency              { setToken(TRANSPARENCY); }
transparent               { setToken(TRANSPARENT); }
transform                 { setToken(TRANSFORM); }
type                      { setToken(TYPE); }
units                     { setToken(UNITS); }
validation                { setToken(VALIDATION); }
web                       { setToken(WEB); }
width                     { setToken(WIDTH); }
wkt                       { setToken(WKT); }
wrap                      { setToken(WRAP); }

\[.*\]                    { setTokenAndString(MS_BINDING); }
-?[0-9]+|-?[0-9]+\.[0-9]*|-?\.[0-9]*|-?[0-9]+[eE][+-]?[0-9]+|-?[0-9]+\.[0-9]*[eE][+-]?[0-9]+|-?\.[0-9]*[eE][+-]?[0-9]+ {
                            setTokenAndString(MS_NUMBER); }
\/[^\/]*\/i?              { setTokenAndString(MS_REGEX); }
[a-z/\.][a-z0-9/\._\-\=]* { setTokenAndString(MS_STRING); }
(\"(\\.|[^"])*\"|\'(\\.|[^'])*\')i? {
	int len = strlen(yytext);
	int hasI = yytext[len-1] == 'i' ? 1 : 0;
	int newLen = len - (hasI ? 2 : 1);
	char *stripped = (char*) malloc(newLen);
	memcpy(stripped,yytext+1,newLen-1);
	stripped[newLen-1] = '\0';
	debugPrint(stripped);
	yylval.str = stripped;
	return MS_STRING;
}

\(                        { BEGIN(PAREN_EXP); yymore(); open_parens = 1; }
<PAREN_EXP>[^\)\(]        { yymore(); }
<PAREN_EXP>\(             { yymore(); open_parens++; }
<PAREN_EXP>\)             {
	open_parens--;
	yymore();
	if(open_parens < 1){
		BEGIN(0);
		setTokenAndString(MS_EXPRESSION);
	}
}

%%

int yywrap(){}
