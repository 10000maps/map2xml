%{

int lineNumber = 0;

#include "mapfileparser.tab.h"

#define setToken(token) yylval.str = strdup(yytext)	;return(token)

YYSTYPE yylval;

%}



%%
[ \t\r]+                              ;

#.*                                   ;

colorrange                            { setToken(COLORRANGE); }
alphacolorrange                       { setToken(ALPHACOLORRANGE); }
datarange                             { setToken(DATARANGE); }
rangeitem                             { setToken(RANGEITEM); }

align                                 { setToken(ALIGN); }
alphacolor                            { setToken(ALPHACOLOR); }
angle                                 { setToken(ANGLE); }
antialias                             { setToken(ANTIALIAS); }
backgroundcolor                       { setToken(BACKGROUNDCOLOR); }
backgroundshadowcolor                 { setToken(BACKGROUNDSHADOWCOLOR); }
backgroundshadowsize                  { setToken(BACKGROUNDSHADOWSIZE); }
bandsitem                             { setToken(BANDSITEM); }
browseformat                          { setToken(BROWSEFORMAT); }
buffer                                { setToken(BUFFER); }
character                             { setToken(CHARACTER); }
class                                 { setToken(CLASS); }
classitem                             { setToken(CLASSITEM); }
classgroup                            { setToken(CLASSGROUP); }
color                                 { setToken(COLOR); }
config                                { setToken(CONFIG); }
connection                            { setToken(CONNECTION); }
connectiontype                        { setToken(CONNECTIONTYPE); }
data                                  { setToken(DATA); }
datapattern                           { setToken(DATAPATTERN); }
debug                                 { setToken(DEBUG); }
driver                                { setToken(DRIVER); }
dump                                  { setToken(DUMP); }
empty                                 { setToken(EMPTY); }
encoding                              { setToken(ENCODING); }
end                                   { setToken(END); }
error                                 { setToken(ERROR); }
expression                            { setToken(EXPRESSION); }
extent                                { setToken(EXTENT); }
extension                             { setToken(EXTENSION); }
feature                               { setToken(FEATURE); }
filled                                { setToken(FILLED); }
filter                                { setToken(FILTER); }
filteritem                            { setToken(FILTERITEM); }
footer                                { setToken(FOOTER); }
font                                  { setToken(FONT); }
fontset                               { setToken(FONTSET); }
force                                 { setToken(FORCE); }
formatoption                          { setToken(FORMATOPTION); }
from                                  { setToken(FROM); }
gap                                   { setToken(GAP); }
geomtransform                         { setToken(GEOMTRANSFORM); }
grid                                  { setToken(GRID); }
graticule                             { setToken(GRATICULE); }
group                                 { setToken(GROUP); }
header                                { setToken(HEADER); }
image                                 { setToken(IMAGE); }
imagecolor                            { setToken(IMAGECOLOR); }
imagetype                             { setToken(IMAGETYPE); }
imagequality                          { setToken(IMAGEQUALITY); }
imagemode                             { setToken(IMAGEMODE); }
imagepath                             { setToken(IMAGEPATH); }
imageurl                              { setToken(IMAGEURL); }
include                               { setToken(INCLUDE); }
index                                 { setToken(INDEX); }
interlace                             { setToken(INTERLACE); }
intervals                             { setToken(INTERVALS); } 
join                                  { setToken(JOIN); }
keyimage                              { setToken(KEYIMAGE); }
keysize                               { setToken(KEYSIZE); }
keyspacing                            { setToken(KEYSPACING); }
label                                 { setToken(LABEL); }
labelcache                            { setToken(LABELCACHE); }
labelformat                           { setToken(LABELFORMAT); }
labelitem                             { setToken(LABELITEM); }
labelmaxscale                         { setToken(LABELMAXSCALE); }
labelmaxscaledenom                    { setToken(LABELMAXSCALEDENOM); }
labelminscale                         { setToken(LABELMINSCALE); }
labelminscaledenom                    { setToken(LABELMINSCALEDENOM); }
labelrequires                         { setToken(LABELREQUIRES); }
latlon                                { setToken(LATLON); }
layer                                 { setToken(LAYER); }
legend                                { setToken(LEGEND); }
legendformat                          { setToken(LEGENDFORMAT); }
linecap                               { setToken(LINECAP); }
linejoin                              { setToken(LINEJOIN); }
linejoinmaxsize                       { setToken(LINEJOINMAXSIZE); }
log                                   { setToken(LOG); }
map                                   { setToken(MAP); }
marker                                { setToken(MARKER); }
markersize                            { setToken(MARKERSIZE); }
maxarcs                               { setToken(MAXARCS); }
maxboxsize                            { setToken(MAXBOXSIZE); }
maxfeatures                           { setToken(MAXFEATURES); }
maxinterval                           { setToken(MAXINTERVAL); }
maxscale                              { setToken(MAXSCALE); }
maxscaledenom                         { setToken(MAXSCALEDENOM); }
maxgeowidth                           { setToken(MAXGEOWIDTH); }
maxlength                             { setToken(MAXLENGTH); }
maxsize                               { setToken(MAXSIZE); }
maxsubdivide                          { setToken(MAXSUBDIVIDE); }
maxtemplate                           { setToken(MAXTEMPLATE); }
maxwidth                              { setToken(MAXWIDTH); }
metadata                              { setToken(METADATA); }
mimetype                              { setToken(MIMETYPE); }
minarcs                               { setToken(MINARCS); }
minboxsize                            { setToken(MINBOXSIZE); }
mindistance                           { setToken(MINDISTANCE); }
repeatdistance                        { setToken(REPEATDISTANCE); }
minfeaturesize                        { setToken(MINFEATURESIZE); }
mininterval                           { setToken(MININTERVAL); }
minscale                              { setToken(MINSCALE); }
minscaledenom                         { setToken(MINSCALEDENOM); }
mingeowidth                           { setToken(MINGEOWIDTH); }
minlength                             { setToken(MINLENGTH); }
minsize                               { setToken(MINSIZE); }
minsubdivide                          { setToken(MINSUBDIVIDE); }
mintemplate                           { setToken(MINTEMPLATE); }
minwidth                              { setToken(MINWIDTH); }
name                                  { setToken(NAME); }
offset                                { setToken(OFFSET); }
offsite                               { setToken(OFFSITE); }
opacity                               { setToken(OPACITY); }
outlinecolor                          { setToken(OUTLINECOLOR); }
outlinewidth                          { setToken(OUTLINEWIDTH); }
outputformat                          { setToken(OUTPUTFORMAT); }
overlaybackgroundcolor                { setToken(OVERLAYBACKGROUNDCOLOR); }
overlaycolor                          { setToken(OVERLAYCOLOR); }
overlaymaxsize                        { setToken(OVERLAYMAXSIZE); }
overlayminsize                        { setToken(OVERLAYMINSIZE); }
overlayoutlinecolor                   { setToken(OVERLAYOUTLINECOLOR); }
overlaysize                           { setToken(OVERLAYSIZE); }
overlaysymbol                         { setToken(OVERLAYSYMBOL); }
partials                              { setToken(PARTIALS); }
pattern                               { setToken(PATTERN); }
points                                { setToken(POINTS); }
items                                 { setToken(ITEMS); }
position                              { setToken(POSITION); }
postlabelcache                        { setToken(POSTLABELCACHE); }
priority                              { setToken(PRIORITY); }
processing                            { setToken(PROCESSING); }
projection                            { setToken(PROJECTION); }
queryformat                           { setToken(QUERYFORMAT); }
querymap                              { setToken(QUERYMAP); }
reference                             { setToken(REFERENCE); }
relativeto                            { setToken(RELATIVETO); }
requires                              { setToken(REQUIRES); }
resolution                            { setToken(RESOLUTION); }
defresolution                         { setToken(DEFRESOLUTION); }
scale                                 { setToken(SCALE); }
scaledenom                            { setToken(SCALEDENOM); }
scalebar                              { setToken(SCALEBAR); }
shadowcolor                           { setToken(SHADOWCOLOR); }
shadowsize                            { setToken(SHADOWSIZE); }
shapepath                             { setToken(SHAPEPATH); }
size                                  { setToken(SIZE); }
sizeunits                             { setToken(SIZEUNITS); }
status                                { setToken(STATUS); }
style                                 { setToken(STYLE); }
styleitem                             { setToken(STYLEITEM); }
symbol                                { setToken(SYMBOL); }
symbolscale                           { setToken(SYMBOLSCALE); }
symbolscaledenom                      { setToken(SYMBOLSCALEDENOM); }
symbolset                             { setToken(SYMBOLSET); }
table                                 { setToken(TABLE); }
template                              { setToken(TEMPLATE); }
templatepattern                       { setToken(TEMPLATEPATTERN); }
text                                  { setToken(TEXT); }
tileindex                             { setToken(TILEINDEX); }
tileitem                              { setToken(TILEITEM); }
title                                 { setToken(TITLE); }
to                                    { setToken(TO); }
tolerance                             { setToken(TOLERANCE); }
toleranceunits                        { setToken(TOLERANCEUNITS); }
transparency                          { setToken(TRANSPARENCY); }
transparent                           { setToken(TRANSPARENT); }
transform                             { setToken(TRANSFORM); }
type                                  { setToken(TYPE); }
units                                 { setToken(UNITS); }
validation                            { setToken(VALIDATION); }
web                                   { setToken(WEB); }
width                                 { setToken(WIDTH); }
wkt                                   { setToken(WKT); }
wrap                                  { setToken(WRAP); }

annotation                            { setToken(MS_LAYER_ANNOTATION); }
auto                                  { setToken(MS_AUTO); }
bevel                                 { setToken(MS_CJC_BEVEL); }
bitmap                                { setToken(MS_BITMAP); }
butt                                  { setToken(MS_CJC_BUTT); }
cartoline                             { setToken(MS_SYMBOL_CARTOLINE); }
cc                                    { setToken(MS_CC); }
center                                { setToken(MS_ALIGN_CENTER); }
chart                                 { setToken(MS_LAYER_CHART); }
circle                                { setToken(MS_LAYER_CIRCLE); }
cl                                    { setToken(MS_CL); }
cr                                    { setToken(MS_CR); }
csv                                   { setToken(MS_DB_CSV); }
mysql                                 { setToken(MS_DB_MYSQL); }
postgresql                            { setToken(MS_DB_POSTGRES); }
default                               { setToken(MS_DEFAULT); }
dd                                    { setToken(MS_DD); }
ellipse                               { setToken(MS_SYMBOL_ELLIPSE); }
embed                                 { setToken(MS_EMBED); }
false                                 { setToken(MS_FALSE); }
feet                                  { setToken(MS_FEET); }
follow                                { setToken(MS_FOLLOW); }
giant                                 { setToken(MS_GIANT); }
hatch                                 { setToken(MS_SYMBOL_HATCH); }
hilite                                { setToken(MS_HILITE); }
inches                                { setToken(MS_INCHES); }
kilometers                            { setToken(MS_KILOMETERS); }
large                                 { setToken(MS_LARGE); }
lc                                    { setToken(MS_LC); }
left                                  { setToken(MS_ALIGN_LEFT); }
line                                  { setToken(MS_LAYER_LINE); }
ll                                    { setToken(MS_LL); }
lr                                    { setToken(MS_LR); }
medium                                { setToken(MS_MEDIUM); }
meters                                { setToken(MS_METERS); }
nauticalmiles                         { setToken(MS_NAUTICALMILES); }
miles                                 { setToken(MS_MILES); }
miter                                 { setToken(MS_CJC_MITER); }
multiple                              { setToken(MS_MULTIPLE); }
none                                  { setToken(MS_CJC_NONE); }
normal                                { setToken(MS_NORMAL); }
off                                   { setToken(MS_OFF); }
ogr                                   { setToken(MS_OGR); }
on                                    { setToken(MS_ON); }
one-to-one                            { setToken(MS_JOIN_ONE_TO_ONE); }
one-to-many                           { setToken(MS_JOIN_ONE_TO_MANY); }
oraclespatial                         { setToken(MS_ORACLESPATIAL); }
percentages                           { setToken(MS_PERCENTAGES); }
pixmap                                { setToken(MS_SYMBOL_PIXMAP); }
pixels                                { setToken(MS_PIXELS); }
point                                 { setToken(MS_LAYER_POINT); }
polygon                               { setToken(MS_LAYER_POLYGON); }
postgis                               { setToken(MS_POSTGIS); }
mygis                                 { setToken(MS_MYGIS); }
plugin                                { setToken(MS_PLUGIN); }
query                                 { setToken(MS_LAYER_QUERY); }
raster                                { setToken(MS_LAYER_RASTER); }
right                                 { setToken(MS_ALIGN_RIGHT); }
round                                 { setToken(MS_CJC_ROUND); }
sde                                   { setToken(MS_SDE); }
selected                              { setToken(MS_SELECTED); }
simple                                { setToken(MS_SYMBOL_SIMPLE); }
single                                { setToken(MS_SINGLE); }
small                                 { setToken(MS_SMALL); }
square                                { setToken(MS_CJC_SQUARE); }
tiny                                  { setToken(MS_TINY); }
triangle                              { setToken(MS_CJC_TRIANGLE); }
true                                  { setToken(MS_TRUE); }
truetype                              { setToken(MS_TRUETYPE); }
uc                                    { setToken(MS_UC); }
ul                                    { setToken(MS_UL); }
ur                                    { setToken(MS_UR); }
vector                                { setToken(MS_SYMBOL_VECTOR); }
wfs                                   { setToken(MS_WFS); }
wms                                   { setToken(MS_WMS); }
alpha                                 { setToken(MS_GD_ALPHA); }

\[.*\]                                { setToken(MS_BINDING); }

-?[0-9]+|-?[0-9]+\.[0-9]*|-?\.[0-9]*|-?[0-9]+[eE][+-]?[0-9]+|-?[0-9]+\.[0-9]*[eE][+-]?[0-9]+|-?\.[0-9]*[eE][+-]?[0-9]+ {
                                        setToken(MS_NUMBER); }

\/[^\/]*\/i                           { setToken(MS_IREGEX); }

\/[^\/]*\/                            { setToken(MS_REGEX); }

\(.*\)                                { setToken(MS_EXPRESSION); }

\"[^\"]*\"i|\'[^\']*\'i               { setToken(MS_ISTRING); }

\"[^\"]*\"|\'[^\']*\'                 { setToken(MS_STRING); }

[a-z/\.][a-z0-9/\._\-\=]*             { setToken(MS_STRING); }

\n                                    { lineNumber++; }

%%

int yywrap(){}