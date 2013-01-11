%{

int lineNumber = 0;
#include <string.h>
#include "../gen/parser.tab.h"

/* *** if this is changed***
remember to also update the function to return a string */
#define debugPrint(str) /*fprintf(stderr,"%s\n",str)*/
#define setToken(token) debugPrint(yytext);yylval.str = 0;return(token)
#define setTokenAndString(token) debugPrint(yytext);yylval.str = strdup(yytext);return(token)

YYSTYPE yylval;

%}



%%
[ \t\r]+                  // ignore whitespace
#.*                       // ignore comments
\n                        { lineNumber++; }
                          
align                     { setToken(ALIGN); }
alphacolor                { setToken(ALPHACOLOR); }
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
legend                    { setToken(LEGEND); }
legendformat              { setToken(LEGENDFORMAT); }
linecap                   { setToken(LINECAP); }
linejoin                  { setToken(LINEJOIN); }
linejoinmaxsize           { setToken(LINEJOINMAXSIZE); }
log                       { setToken(LOG); }
map                       { setToken(MAP); }
marker                    { setToken(MARKER); }
markersize                { setToken(MARKERSIZE); }
maxarcs                   { setToken(MAXARCS); }
maxboxsize                { setToken(MAXBOXSIZE); }
maxfeatures               { setToken(MAXFEATURES); }
maxinterval               { setToken(MAXINTERVAL); }
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
repeatdistance            { setToken(REPEATDISTANCE); }
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
items                     { setToken(ITEMS); }
position                  { setToken(POSITION); }
postlabelcache            { setToken(POSTLABELCACHE); }
priority                  { setToken(PRIORITY); }
processing                { setToken(PROCESSING); }
projection                { setToken(PROJECTION); }
queryformat               { setToken(QUERYFORMAT); }
querymap                  { setToken(QUERYMAP); }
reference                 { setToken(REFERENCE); }
relativeto                { setToken(RELATIVETO); }
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
\(.*\)                    { setTokenAndString(MS_EXPRESSION); }
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
%%

int yywrap(){}
