%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../src/map2xml.h"


int yylex();
int yyparse();
char *yytext;
int lineNumber;

void yyerror(const char *s);
%}


%union {
	char *str;
	struct XmlNode *node;
}

%token <str> ALIGN ALPHACOLOR ANGLE ANTIALIAS BACKGROUNDCOLOR BACKGROUNDSHADOWCOLOR
	BACKGROUNDSHADOWSIZE BANDSITEM BROWSEFORMAT BUFFER CHARACTER CLASS CLASSITEM CLASSGROUP COLOR
	CONFIG CONNECTION CONNECTIONTYPE DATA DATAPATTERN DEBUG DRIVER DUMP EMPTY ENCODING END ERROR
	EXPRESSION EXTENT EXTENSION FEATURE FILLED FILTER FILTERITEM FOOTER FONT FONTSET FORCE
	FORMATOPTION FROM GAP GEOMTRANSFORM GRID GRATICULE GROUP HEADER IMAGE IMAGECOLOR IMAGETYPE
	IMAGEQUALITY IMAGEMODE IMAGEPATH IMAGEURL INCLUDE INDEX INTERLACE INTERVALS JOIN KEYIMAGE KEYSIZE
	KEYSPACING LABEL LABELCACHE LABELFORMAT LABELITEM LABELMAXSCALE LABELMAXSCALEDENOM LABELMINSCALE
	LABELMINSCALEDENOM LABELREQUIRES LATLON LAYER LEGEND LEGENDFORMAT LINECAP LINEJOIN LINEJOINMAXSIZE
	LOG MAP MARKER MARKERSIZE MAXARCS MAXBOXSIZE MAXFEATURES MAXINTERVAL MAXSCALE MAXSCALEDENOM
	MAXGEOWIDTH MAXLENGTH MAXSIZE MAXSUBDIVIDE MAXTEMPLATE MAXWIDTH METADATA MIMETYPE MINARCS
	MINBOXSIZE MINDISTANCE REPEATDISTANCE MINFEATURESIZE MININTERVAL MINSCALE MINSCALEDENOM
	MINGEOWIDTH MINLENGTH MINSIZE MINSUBDIVIDE MINTEMPLATE MINWIDTH NAME OFFSET OFFSITE OPACITY
	OUTLINECOLOR OUTLINEWIDTH OUTPUTFORMAT OVERLAYBACKGROUNDCOLOR OVERLAYCOLOR OVERLAYMAXSIZE
	OVERLAYMINSIZE OVERLAYOUTLINECOLOR OVERLAYSIZE OVERLAYSYMBOL PARTIALS PATTERN POINTS ITEMS
	POSITION POSTLABELCACHE PRIORITY PROCESSING PROJECTION QUERYFORMAT QUERYMAP REFERENCE RELATIVETO
	REQUIRES RESOLUTION DEFRESOLUTION SCALE SCALEDENOM SCALEBAR SHADOWCOLOR SHADOWSIZE SHAPEPATH SIZE
	SIZEUNITS STATUS STYLE STYLEITEM SYMBOL SYMBOLSCALE SYMBOLSCALEDENOM SYMBOLSET TABLE TEMPLATE
	TEMPLATEPATTERN TEXT TILEINDEX TILEITEM TITLE TO TOLERANCE TOLERANCEUNITS TRANSPARENCY TRANSPARENT
	TRANSFORM TYPE UNITS VALIDATION WEB WIDTH WKT WRAP MS_PLUGIN LEADER MS_ISTRING INITIALGAP CLUSTER
	MAXDISTANCE ANCHORPOINT MS_BINDING MS_REGEX MS_NUMBER TEMPPATH MASK MS_STRING GRIDSTEP
	MAXOVERLAPANGLE LABELANGLEITEM REGION LABELSIZEITEM MS_IREGEX MS_EXPRESSION POLAROFFSET
	ANNOTATION AUTO BBOX BEVEL BITMAP BUTT BYTE CC CENTER CHART CIRCLE CL CR CSV DD DEFAULT ELLIPSE 
	EMBED FALSE FEET FLOAT32 GIANT HATCH HILITE INCHES INT16 KILOMETERS LABELPNT LABELPOLY LARGE LC 
	LEFT LINE LL LOCAL LR MEDIUM METERS MILES MITER MYSQL NAUTICALMILES NORMAL OFF OGR ON 
	ONE_TO_MANY ONE_TO_ONE ORACLESPATIAL PC256 PERCENTAGES PIXELS PIXMAP PLUGIN POINT POLYGON 
	POSTGIS POSTGRESQL QUERY RASTER RGB RGBA RIGHT ROUND SDE SELECTED SIMPLE SMALL SQUARE START TINY 
	TRIANGLE TRUE TRUETYPE UC UL UNION UR VECTOR VERTICES WFS WMS;

%type <node> mapfile layer_set symbol_set class_block class_stmts class_stmt cluster_block
	cluster_stmts cluster_stmt feature_block feature_stmts feature_stmt grid_block grid_stmts
	grid_stmt join_block join_stmts join_stmt label_block label_stmts label_stmt layer_block
	layer_stmts layer_stmt leader_block leader_stmts leader_stmt legend_block legend_stmts
	legend_stmt map_block map_stmts map_stmt metadata_block outputformat_block outputformat_stmts
	outputformat_stmt points_block point_stmt point_stmts projection_block querymap_block
	querymap_stmts querymap_stmt reference_block reference_stmts reference_stmt scalebar_block
	scalebar_stmts scalebar_stmt style_block style_stmts style_stmt symbol_block symbol_stmts
	symbol_stmt validation_block web_block web_stmts web_stmt xyValue rgbColor symbolValue
	expressionValue item items rootelement;

%type <str> value valueList;

%%

mapfile
	: rootelement {
		printf("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		XmlNode_print($1);
		XmlNode_destory($1);
	}
	| 
	;

rootelement
	: map_block
	| layer_set {
		$$ = $1;
	}
	| SYMBOLSET symbol_set END { $$ = $2; }
	;
layer_set
	: layer_set layer_block {
		if($2 != 0)XmlNode_merge($1,$2);
		$$ = $1;
	}
	| layer_block {
		XmlNode *node = XmlNode_new();
		XmlNode_setName(node,"LayerSet");
		XmlNode_addAttribute(node,"xmlns","http://www.mapserver.org/mapserver");
		XmlNode_addAttribute(node,"xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
		XmlNode_addAttribute(node,"xsi:schemaLocation","http://www.mapserver.org/mapserver ../mapfile.xsd");
		if($1 != 0)
			XmlNode_merge(node,$1);
		$$ = node;
	}
	;
symbol_set
	: symbol_set symbol_block {
		if($2 != 0)
			XmlNode_merge($1,$2);
		$$ = $1;
	}
	| symbol_block {
		XmlNode *node = XmlNode_new();
		XmlNode_setName(node,"SymbolSet");
		XmlNode_addAttribute(node,"xmlns","http://www.mapserver.org/mapserver");
		XmlNode_addAttribute(node,"xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
		XmlNode_addAttribute(node,"xsi:schemaLocation","http://www.mapserver.org/mapserver ../mapfile.xsd");
		if($1 != 0)
			XmlNode_merge(node,$1);
		$$ = node;
	}
	;

value
	: MS_STRING
	| MS_REGEX
	| MS_BINDING
	| MS_NUMBER
	| MS_EXPRESSION
	| ANNOTATION    { $$ = strdup("ANNOTATION"); }
	| AUTO          { $$ = strdup("AUTO"); }
	| BBOX          { $$ = strdup("BBOX"); }
	| BEVEL         { $$ = strdup("BEVEL"); }
	| BITMAP        { $$ = strdup("BITMAP"); }
	| BUTT          { $$ = strdup("BUTT"); }
	| BYTE          { $$ = strdup("BYTE"); }
	| CC            { $$ = strdup("CC"); }
	| CENTER        { $$ = strdup("CENTER"); }
	| CHART         { $$ = strdup("CHART"); }
	| CIRCLE        { $$ = strdup("CIRCLE"); }
	| CL            { $$ = strdup("CL"); }
	| CR            { $$ = strdup("CR"); }
	| CSV           { $$ = strdup("CSV"); }
	| DD            { $$ = strdup("DD"); }
	| DEFAULT       { $$ = strdup("DEFAULT"); }
	| ELLIPSE       { $$ = strdup("ELLIPSE"); }
	| EMBED         { $$ = strdup("EMBED"); }
	| FALSE         { $$ = strdup("FALSE"); }
	| FEET          { $$ = strdup("FEET"); }
	| FLOAT32       { $$ = strdup("FLOAT32"); }
	| GIANT         { $$ = strdup("GIANT"); }
	| HATCH         { $$ = strdup("HATCH"); }
	| HILITE        { $$ = strdup("HILITE"); }
	| INCHES        { $$ = strdup("INCHES"); }
	| INT16         { $$ = strdup("INT16"); }
	| KILOMETERS    { $$ = strdup("KILOMETERS"); }
	| LABELPNT      { $$ = strdup("LABELPNT"); }
	| LABELPOLY     { $$ = strdup("LABELPOLY"); }
	| LARGE         { $$ = strdup("LARGE"); }
	| LC            { $$ = strdup("LC"); }
	| LEFT          { $$ = strdup("LEFT"); }
	| LINE          { $$ = strdup("LINE"); }
	| LL            { $$ = strdup("LL"); }
	| LOCAL         { $$ = strdup("LOCAL"); }
	| LR            { $$ = strdup("LR"); }
	| MEDIUM        { $$ = strdup("MEDIUM"); }
	| METERS        { $$ = strdup("METERS"); }
	| MILES         { $$ = strdup("MILES"); }
	| MITER         { $$ = strdup("MITER"); }
	| MYSQL         { $$ = strdup("MYSQL"); }
	| NAUTICALMILES { $$ = strdup("NAUTICALMILES"); }
	| NORMAL        { $$ = strdup("NORMAL"); }
	| OFF           { $$ = strdup("OFF"); }
	| OGR           { $$ = strdup("OGR"); }
	| ON            { $$ = strdup("ON"); }
	| ONE_TO_MANY   { $$ = strdup("ONE-TO-MANY"); }
	| ONE_TO_ONE    { $$ = strdup("ONE-TO-ONE"); }
	| ORACLESPATIAL { $$ = strdup("ORACLESPATIAL"); }
	| PC256         { $$ = strdup("PC256"); }
	| PERCENTAGES   { $$ = strdup("PERCENTAGES"); }
	| PIXELS        { $$ = strdup("PIXELS"); }
	| PIXMAP        { $$ = strdup("PIXMAP"); }
	| PLUGIN        { $$ = strdup("PLUGIN"); }
	| POINT         { $$ = strdup("POINT"); }
	| POLYGON       { $$ = strdup("POLYGON"); }
	| POSTGIS       { $$ = strdup("POSTGIS"); }
	| POSTGRESQL    { $$ = strdup("POSTGRESQL"); }
	| QUERY         { $$ = strdup("QUERY"); }
	| RASTER        { $$ = strdup("RASTER"); }
	| RGB           { $$ = strdup("RGB"); }
	| RGBA          { $$ = strdup("RGBA"); }
	| RIGHT         { $$ = strdup("RIGHT"); }
	| ROUND         { $$ = strdup("ROUND"); }
	| SDE           { $$ = strdup("SDE"); }
	| SELECTED      { $$ = strdup("SELECTED"); }
	| SIMPLE        { $$ = strdup("SIMPLE"); }
	| SMALL         { $$ = strdup("SMALL"); }
	| SQUARE        { $$ = strdup("SQUARE"); }
	| START         { $$ = strdup("START"); }
	| TINY          { $$ = strdup("TINY"); }
	| TRIANGLE      { $$ = strdup("TRIANGLE"); }
	| TRUE          { $$ = strdup("TRUE"); }
	| TRUETYPE      { $$ = strdup("TRUETYPE"); }
	| UC            { $$ = strdup("UC"); }
	| UL            { $$ = strdup("UL"); }
	| UNION         { $$ = strdup("UNION"); }
	| UR            { $$ = strdup("UR"); }
	| VECTOR        { $$ = strdup("VECTOR"); }
	| VERTICES      { $$ = strdup("VERTICES"); }
	| WFS           { $$ = strdup("WFS"); }
	| WMS	        { $$ = strdup("WMS"); }
	;

rgbColor
	: value value value { $$ = createRGBNode($1,$2,$3); }
	;
xyValue
	: value value { $$ = createXYNode($1,$2); }
	;
item
	: value value { $$ = createItemNode($1,$2); }
	;
items
	: items item { $$ = addChildNode($1,$2); }
	| item { $$ = wrapNode($1); }
	;
expressionValue
	: MS_STRING { $$ = createTypedNode("CONSTANT",$1); }
	| MS_REGEX { $$ = createTypedNode("REGEX",$1); }
	| MS_EXPRESSION { $$ = createTypedNode("MSEXPR",$1); }
	;
symbolValue
	: MS_NUMBER { $$ = createTypedNode("ID",$1); }
	| MS_STRING { $$ = createTypedNode("NAME",$1); }
	;

valueList
	: valueList value { $$ = concatStrings($1,$2);}
	| value { $$ = $1; };

class_block
	: CLASS class_stmts END { $$ = wrapNode($2); }
	| CLASS END { $$ = 0; }
	;
class_stmts
	: class_stmts class_stmt { $$ = mergeNodes($1,$2); }
	| class_stmt { $$ = nameNode("Class",$1); }
	;
class_stmt
	: BACKGROUNDCOLOR rgbColor { $$ = wrapNode(nameNode("backgroundColor",$2)); }
	| COLOR rgbColor { $$ = wrapNode(nameNode("color",$2)); }
	| DEBUG value { $$ = createSimpleNode("debug",$2); }
	| EXPRESSION expressionValue { $$ = wrapNode(nameNode("expression",$2)); }
	| GROUP value { $$ = createSimpleNode("group",$2); }
	| KEYIMAGE value { $$ = createSimpleNode("keyImage",$2); }
	| label_block { $$ = $1; }
	| leader_block { $$ = $1; }
	| MAXSCALEDENOM value { $$ = createSimpleNode("maxScaleDenom",$2); }
	| MAXSIZE value { $$ = createSimpleNode("maxSize",$2); }
	| metadata_block { $$ = $1; }
	| MINSCALEDENOM value { $$ = createSimpleNode("minScaleDenom",$2); }
	| MINSIZE value { $$ = createSimpleNode("minSize",$2); }
	| NAME value { $$ = createAttributeNode("name",$2); }
	| OUTLINECOLOR rgbColor { $$ = wrapNode(nameNode("outlineColor",$2)); }
	| SIZE value { $$ = createSimpleNode("size",$2); }
	| STATUS value { $$ = createAttributeNode("status",$2); }
	| style_block { $$ = $1; }
	| SYMBOL symbolValue { $$ = wrapNode(nameNode("symbol",$2)); }
	| TEMPLATE value { $$ = createSimpleNode("template",$2); }
	| TEXT value { $$ = createSimpleNode("text",$2); }
	| validation_block { $$ = $1; }
	;

cluster_block
	: CLUSTER cluster_stmts END { $$ = wrapNode($2); }
	| CLUSTER END { $$ = 0; }
	;
cluster_stmts
	: cluster_stmts cluster_stmt { $$ = mergeNodes($1,$2); }
	| cluster_stmt { $$ = nameNode("Cluster",$1); }
	;
cluster_stmt
	: MAXDISTANCE value { $$ = createSimpleNode("maxdistance",$2); }
	| REGION value { $$ = createSimpleNode("region",$2); }
	| BUFFER value { $$ = createSimpleNode("buffer",$2); }
	| GROUP expressionValue { $$ = wrapNode(nameNode("group",$2)); }
	| FILTER expressionValue { $$ = wrapNode(nameNode("filter",$2)); }
	;

feature_block
	: FEATURE feature_stmts END { $$ = wrapNode($2); }
	| FEATURE END { $$ = 0; }
	;
feature_stmts
	: feature_stmts feature_stmt { $$ = mergeNodes($1,$2); }
	| feature_stmt { $$ = nameNode("Feature",$1); }
	;
feature_stmt
	: points_block { $$ = $1; }
	| ITEMS value { $$ = createSimpleNode("items",$2); }
	| TEXT value { $$ = createSimpleNode("text",$2); }
	| WKT value { $$ = createSimpleNode("wkt",$2); }
	;

grid_block
	: GRID grid_stmts END { $$ = wrapNode($2); }
	| GRID END { $$ = 0; }
	;
grid_stmts
	: grid_stmts grid_stmt { $$ = mergeNodes($1,$2); }
	| grid_stmt { $$ = nameNode("Grid",$1); }
	;
grid_stmt
	: LABELFORMAT value { $$ = createSimpleNode("labelFormat",$2); }
	| MINARCS value { $$ = createSimpleNode("minArcs",$2); }
	| MAXARCS value { $$ = createSimpleNode("maxArcs",$2); }
	| MININTERVAL value { $$ = createSimpleNode("minInterval",$2); }
	| MAXINTERVAL value { $$ = createSimpleNode("maxInterval",$2); }
	| MINSUBDIVIDE value { $$ = createSimpleNode("minSubdivide",$2); }
	| MAXSUBDIVIDE value { $$ = createSimpleNode("maxSubdivide",$2); }
	;


join_block
	: JOIN join_stmts END { $$ = wrapNode($2); }
	| JOIN END { $$ = 0; }
	;
join_stmts
	: join_stmts join_stmt { $$ = mergeNodes($1,$2); }
	| join_stmt { $$ = nameNode("Join",$1); }
	;
join_stmt
	: CONNECTION value { $$ = createSimpleNode("connection",$2); }
	| CONNECTIONTYPE value { $$ = createSimpleNode("connectionType",$2); }
	| FOOTER value { $$ = createSimpleNode("footer",$2); }
	| FROM value { $$ = createSimpleNode("from",$2); }
	| HEADER value { $$ = createSimpleNode("header",$2); }
	| NAME value { $$ = createAttributeNode("name",$2); }
	| TABLE value { $$ = createSimpleNode("table",$2); }
	| TEMPLATE value { $$ = createSimpleNode("template",$2); }
	| TO value { $$ = createSimpleNode("to",$2); }
	| TYPE value { $$ = createAttributeNode("type",$2); }
	;


label_block
	: LABEL label_stmts END { $$ = wrapNode($2); }
	| LABEL END { $$ = 0; }
	;
label_stmts
	: label_stmts label_stmt { $$ = mergeNodes($1,$2); }
	| label_stmt { $$ = nameNode("Label",$1); }
	;
label_stmt
	: ALIGN value { $$ = createSimpleNode("align",$2); }
	| ANGLE value { $$ = createSimpleNode("angle",$2); }
	| ANTIALIAS value { $$ = createSimpleNode("antialias",$2); }
	| BACKGROUNDCOLOR rgbColor { $$ = wrapNode(nameNode("backgroundColor",$2)); }
	| BACKGROUNDSHADOWCOLOR rgbColor { $$ = wrapNode(nameNode("backgroundShadowColor",$2)); }
	| BACKGROUNDSHADOWSIZE xyValue { $$ = wrapNode(nameNode("backgroundShadowSize",$2)); }
	| BUFFER value { $$ = createSimpleNode("buffer",$2); }
	| COLOR rgbColor { $$ = wrapNode(nameNode("color",$2)); }
	| COLOR MS_BINDING { $$ = createSimpleNode("colorAttribute",$2); }
	| ENCODING value { $$ = createSimpleNode("encoding",$2); }
	| EXPRESSION expressionValue { $$ = 0; }
	| FONT value { $$ = createSimpleNode("font",$2); }
	| FORCE value { $$ = createSimpleNode("force",$2); }
	| MAXLENGTH value { $$ = createSimpleNode("maxLength",$2); }
	| MAXOVERLAPANGLE value { $$ = createSimpleNode("maxOverlapAngle",$2); }
	| MAXSCALEDENOM value { $$ = createSimpleNode("maxScaleDenom",$2); }
	| MAXSIZE value { $$ = createSimpleNode("maxSize",$2); }
	| MINDISTANCE value { $$ = createSimpleNode("minDistance",$2); }
	| MINFEATURESIZE value { $$ = createSimpleNode("minFeatureSize",$2); }
	| MINSIZE value { $$ = createSimpleNode("minSize",$2); }
	| OFFSET xyValue { $$ = wrapNode(nameNode("offset",$2)); }
	| OUTLINECOLOR rgbColor { $$ = wrapNode(nameNode("outlineColor",$2)); }
	| OUTLINECOLOR MS_BINDING { $$ = createSimpleNode("outlineColorAttribute",$2); }
	| OUTLINEWIDTH value { $$ = createSimpleNode("outlineWidth",$2); }
	| PARTIALS value { $$ = createSimpleNode("partials",$2); }
	| POSITION value { $$ = createSimpleNode("position",$2); }
	| PRIORITY value { $$ = createSimpleNode("priority",$2); }
	| REPEATDISTANCE value { $$ = createSimpleNode("repeatDistance",$2); }
	| SHADOWCOLOR rgbColor { $$ = wrapNode(nameNode("shadowColor",$2)); }
	| SHADOWSIZE xyValue { $$ = wrapNode(nameNode("shadowSize",$2)); }
	| SIZE value { $$ = createSimpleNode("size",$2); }
	| style_block { $$ = $1; }
	| TYPE value { $$ = createAttributeNode("type",$2); }
	| WRAP value { $$ = createSimpleNode("wrap",$2); }
	;

legend_block
	: LEGEND legend_stmts END { $$ = wrapNode($2); }
	| LEGEND END { $$ = 0; }
	;
legend_stmts
	: legend_stmts legend_stmt { $$ = mergeNodes($1,$2); }
	| legend_stmt { $$ = nameNode("Legend",$1); }
	;
legend_stmt
	: IMAGECOLOR rgbColor { $$ = wrapNode(nameNode("imageColor",$2)); }
	| KEYSIZE xyValue { $$ = wrapNode(nameNode("keySize",$2)); }
	| KEYSPACING xyValue { $$ = wrapNode(nameNode("keySpacing",$2)); }
	| label_block { $$ = $1; }
	| OUTLINECOLOR rgbColor { $$ = wrapNode(nameNode("outlineColor",$2)); }
	| POSITION value { $$ = createSimpleNode("position",$2); }
	| POSTLABELCACHE value { $$ = createSimpleNode("postLabelCache",$2); }
	| STATUS value { $$ = createAttributeNode("status",$2); }
	| TEMPLATE value { $$ = createSimpleNode("template",$2); }
	;

layer_block
	: LAYER layer_stmts END { $$ = wrapNode($2); }
	| LAYER END { $$ = 0; }
	;

layer_stmts
	: layer_stmts layer_stmt { $$ = mergeNodes($1,$2); }
	| layer_stmt { $$ = nameNode("Layer",$1); }
	;
layer_stmt
	: class_block { $$ = $1; }
	| CLASSGROUP value { $$ = createSimpleNode("classGroup",$2); }
	| CLASSITEM value { $$ = createSimpleNode("classItem",$2); }
	| cluster_block { $$ = $1; }
	| CONNECTION value { $$ = createSimpleNode("connection",$2); }
	| CONNECTIONTYPE value { $$ = createSimpleNode("connectionType",$2); }
	| DATA value { $$ = createSimpleNode("data",$2); }
	| DEBUG value { $$ = createSimpleNode("debug",$2); }
	| DUMP value { $$ = createSimpleNode("dump",$2); }
	| EXTENT valueList { $$ = createSimpleNode("extent",$2); }
	| feature_block { $$ = $1; }
	| FILTER expressionValue { $$ = wrapNode(nameNode("filter",$2)); }
	| FILTERITEM value { $$ = createSimpleNode("filterItem",$2); }
	| FOOTER value { $$ = createSimpleNode("footer",$2); }
	| grid_block { $$ = $1; }
	| GROUP value { $$ = createSimpleNode("group",$2); }
	| HEADER value { $$ = createSimpleNode("header",$2); }
	| join_block { $$ = $1; }
	| LABELANGLEITEM value { $$ = createSimpleNode("labelAngleItem",$2); }
	| LABELCACHE value { $$ = createSimpleNode("labelCache",$2); }
	| LABELITEM value { $$ = createSimpleNode("labelItem",$2); }
	| LABELMAXSCALEDENOM value { $$ = createSimpleNode("labelMaxScaleDenom",$2); }
	| LABELMINSCALEDENOM value { $$ = createSimpleNode("labelMinScaleDenom",$2); }
	| LABELREQUIRES value { $$ = createSimpleNode("labelRequires",$2); }
	| LABELSIZEITEM value { $$ = createSimpleNode("labelSizeItem",$2); }
	| MASK value { $$ = createSimpleNode("mask",$2); }
	| MAXFEATURES value { $$ = createSimpleNode("maxFeatures",$2); }
	| MAXGEOWIDTH value { $$ = createSimpleNode("maxGeoWidth",$2); }
	| MAXSCALEDENOM value { $$ = createSimpleNode("maxScaleDenom",$2); }
	| metadata_block { $$ = $1; }
	| MINGEOWIDTH value { $$ = createSimpleNode("minGeoWidth",$2); }
	| MINSCALEDENOM value { $$ = createSimpleNode("minScaleDenom",$2); }
	| NAME value { $$ = createAttributeNode("name",$2); }
	| OFFSITE rgbColor { $$ = wrapNode(nameNode("offsite",$2)); }
	| OPACITY value { $$ = createSimpleNode("opacity",$2); }
	| MS_PLUGIN value { $$ = createSimpleNode("plugin",$2); }
	| POSTLABELCACHE value { $$ = createSimpleNode("postLabelCache",$2); }
	| PROCESSING value { $$ = createSimpleNode("processing",$2); }
	| projection_block { $$ = $1; }
	| REQUIRES value { $$ = createSimpleNode("requires",$2); }
	| SIZEUNITS value { $$ = createSimpleNode("sizeUnits",$2); }
	| STATUS value { $$ = createAttributeNode("status",$2); }
	| STYLEITEM value { $$ = createSimpleNode("styleItem",$2); }
	| SYMBOLSCALEDENOM value { $$ = createSimpleNode("symbolScaleDenom",$2); }
	| TEMPLATE value { $$ = createSimpleNode("template",$2); }
	| TILEINDEX value { $$ = createSimpleNode("tileIndex",$2); }
	| TILEITEM value { $$ = createSimpleNode("tileItem",$2); }
	| TOLERANCE value { $$ = createSimpleNode("tolerance",$2); }
	| TOLERANCEUNITS value { $$ = createSimpleNode("toleranceUnits",$2); }
	| TRANSPARENCY value { $$ = createSimpleNode("transparency",$2); }
	| TRANSFORM value { $$ = createSimpleNode("transform",$2); }
	| TYPE value { $$ = createAttributeNode("type",$2); }
	| UNITS value { $$ = createSimpleNode("units",$2); }
	| validation_block { $$ = $1; }
	;

leader_block
	: LEADER leader_stmts END { $$ = wrapNode($2); }
	| LEADER END { $$ = 0; }
	;
leader_stmts
	: leader_stmts leader_stmt { $$ = mergeNodes($1,$2); }
	| leader_stmt { $$ = nameNode("LabelLeader",$1); }
	;
leader_stmt
	: GRIDSTEP value { $$ = createSimpleNode("gridstep",$2); }
	| MAXDISTANCE value { $$ = createSimpleNode("maxdistance",$2); }
	| style_block { $$ = $1; }
	;

map_block
	: MAP map_stmts END {
		$$ = $2;
		XmlNode_addAttribute($2,"xmlns","http://www.mapserver.org/mapserver");
		XmlNode_addAttribute($2,"xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
		XmlNode_addAttribute($2,"xsi:schemaLocation","http://www.mapserver.org/mapserver ../mapfile.xsd");
		XmlNode_addAttribute($2,"version",version);
	}
	| MAP END { $$ = 0; }
	;
map_stmts
	: map_stmts map_stmt { $$ = mergeNodes($1,$2); }
	| map_stmt { $$ = nameNode("Map",$1); }
	;
map_stmt
	: ANGLE value { $$ = createSimpleNode("angle",$2); }
	| CONFIG value value { $$ = addToMapConfig($2,$3); }
	| DATAPATTERN value { $$ = createSimpleNode("dataPattern",$2); }
	| DEBUG value { $$ = createSimpleNode("debug",$2); }
	| DEFRESOLUTION value { $$ = createSimpleNode("defResolution",$2); }
	| EXTENT valueList { $$ = createSimpleNode("extent",$2); }
	| FONTSET value { $$ = createSimpleNode("fontSet",$2); }
	| IMAGECOLOR rgbColor { $$ = wrapNode(nameNode("imageColor",$2)); }
	| IMAGEQUALITY value { $$ = createSimpleNode("",$2); }
	| IMAGETYPE value { $$ = createSimpleNode("imageType",$2); }
	| INCLUDE value { $$ = createSimpleNode("include",$2); }
	| INTERLACE value { $$ = createSimpleNode("",$2); }
	| layer_block { $$ = $1; }
	| legend_block { $$ = $1; }
	| MAXSIZE value { $$ = createSimpleNode("maxSize",$2); }
	| NAME value { $$ = createAttributeNode("name",$2); };
	| outputformat_block { $$ = $1; }
	| projection_block { $$ = $1; }
	| querymap_block { $$ = $1; }
	| reference_block { $$ = $1; }
	| RESOLUTION value { $$ = createSimpleNode("resolution",$2); }
	| SCALEDENOM value { $$ = createSimpleNode("scaleDenom",$2); }
	| scalebar_block { $$ = $1; }
	| SHAPEPATH value { $$ = createSimpleNode("shapePath",$2); }
	| SIZE xyValue { $$ = wrapNode(nameNode("size",$2)); }
	| STATUS value { $$ = createAttributeNode("status",$2); }
	| SYMBOLSET value { $$ = createSimpleNode("symbolSet",$2); }
	| symbol_block { $$ = $1; }
	| TEMPLATEPATTERN value { $$ = createSimpleNode("templatePattern",$2); }
	| TRANSPARENT value { $$ = createSimpleNode("transparent",$2); }
	| UNITS value { $$ = createSimpleNode("units",$2); }
	| web_block { $$ = $1; }
	;

outputformat_block
	: OUTPUTFORMAT outputformat_stmts END { $$ = wrapNode($2); }
	| OUTPUTFORMAT END { $$ = 0; }
	;
outputformat_stmts
	: outputformat_stmts outputformat_stmt { $$ = mergeNodes($1,$2); }
	| outputformat_stmt { $$ = nameNode("OutputFormat",$1); }
	;
outputformat_stmt
	: DRIVER value { $$ = createSimpleNode("driver",$2); }
	| EXTENSION value { $$ = createSimpleNode("extension",$2); }
	| FORMATOPTION value { $$ = createSimpleNode("formatOption",$2); }
	| IMAGEMODE value { $$ = createSimpleNode("imageMode",$2); }
	| IMAGEMODE END { $$ = createSimpleNode("imageMode",strdup("FEATURE")); } // FEATURE can't be included in the value enumeration because it caues shift/reduce errors
	| MIMETYPE value { $$ = createSimpleNode("mimeType",$2); }
	| NAME value { $$ = createAttributeNode("name",$2); }
	| TRANSPARENT value { $$ = createSimpleNode("transparent",$2); }
	;

points_block
	: POINTS point_stmts END { $$ = wrapNode($2); }
	| POINTS END { $$ = 0; }
	;
point_stmts
	: point_stmts point_stmt { $$ = mergeNodes($1,$2); }
	| point_stmt { $$ = nameNode("Points",$1); }
	;
point_stmt
	: xyValue { $$ = wrapNode(nameNode("point",$1)); }
	;

projection_block
	: PROJECTION valueList END { $$ = createSimpleNode("projection",$2); }
	| PROJECTION END { $$ = 0; }
	;

querymap_block
	: QUERYMAP querymap_stmts END { $$ = wrapNode($2); }
	| QUERYMAP END { $$ = 0; }
	;
querymap_stmts
	: querymap_stmts querymap_stmt { $$ = mergeNodes($1,$2); }
	| querymap_stmt { $$ = nameNode("QueryMap",$1); }
	;
querymap_stmt
	: COLOR rgbColor { $$ = wrapNode(nameNode("color",$2)); }
	| SIZE xyValue { $$ = wrapNode(nameNode("size",$2)); }
	| STATUS value { $$ = createAttributeNode("status",$2); }
	| STYLE value { $$ = createSimpleNode("style",$2); }
	;

reference_block
	: REFERENCE reference_stmts END { $$ = wrapNode($2); }
	| REFERENCE END { $$ = 0; }
	;
reference_stmts
	: reference_stmts reference_stmt { $$ = mergeNodes($1,$2); }
	| reference_stmt { $$ = nameNode("Reference",$1); }
	;
reference_stmt
	: COLOR rgbColor { $$ = wrapNode(nameNode("color",$2)); }
	| EXTENT valueList { $$ = createSimpleNode("extent",$2);	}
	| IMAGE value { $$ = createSimpleNode("image",$2);	}
	| MARKER value { $$ = createSimpleNode("marker",$2);	}
	| MARKERSIZE value { $$ = createSimpleNode("markerSize",$2); }
	| MINBOXSIZE value { $$ = createSimpleNode("minBoxSize",$2); }
	| MAXBOXSIZE value { $$ = createSimpleNode("maxBoxSize",$2); }
	| OUTLINECOLOR rgbColor { $$ = wrapNode(nameNode("outlineColor",$2)); }
	| SIZE xyValue { $$ = wrapNode(nameNode("size",$2));		}
	| STATUS value { $$ = createAttributeNode("status",$2);	}
	;


scalebar_block
	: SCALEBAR scalebar_stmts END { $$ = wrapNode($2); }
	| SCALEBAR END { $$ = 0; }
	;
scalebar_stmts
	: scalebar_stmts scalebar_stmt { $$ = mergeNodes($1,$2); }
	| scalebar_stmt { $$ = nameNode("ScaleBar",$1); }
	;
scalebar_stmt
	: ALIGN value { $$ = createSimpleNode("align",$2); }
	| BACKGROUNDCOLOR rgbColor { $$ = wrapNode(nameNode("backgroundColor",$2)); }
	| COLOR rgbColor { $$ = wrapNode(nameNode("color",$2)); }
	| IMAGECOLOR rgbColor { $$ = wrapNode(nameNode("imageColor",$2)); }
	| INTERVALS value { $$ = createSimpleNode("intervals",$2); }
	| label_block { $$ = $1; }
	| OUTLINECOLOR rgbColor { $$ = wrapNode(nameNode("outlineColor",$2)); }
	| POSITION value { $$ = createSimpleNode("position",$2); }
	| POSTLABELCACHE value { $$ = createSimpleNode("postLabelCache",$2); }
	| SIZE xyValue { $$ = wrapNode(nameNode("size",$2)); }
	| STATUS value { $$ = createAttributeNode("status",$2); }
	| STYLE value { $$ = createSimpleNode("style",$2); }
	| TRANSPARENT value { $$ = createSimpleNode("transparent",$2); }
	| UNITS value { $$ = createSimpleNode("units",$2); }
	;

style_block
	: STYLE style_stmts END { $$ = wrapNode($2); }
	| STYLE END { $$ = 0; }
	;
style_stmts
	: style_stmts style_stmt { $$ = mergeNodes($1,$2); }
	| style_stmt { $$ = nameNode("Style",$1); }
	;
style_stmt
	: ANGLE value { $$ = createSimpleNode("angle",$2); }
	| ANTIALIAS value { $$ = createSimpleNode("antialias",$2); }
	| BACKGROUNDCOLOR rgbColor { $$ = wrapNode(nameNode("backgroundColor",$2)); }
	| COLOR rgbColor { $$ = wrapNode(nameNode("color",$2)); }
	| COLOR MS_BINDING { $$ = createSimpleNode("colorAttribute",$2); }
	| GAP value { $$ = createSimpleNode("gap",$2); }
	| GEOMTRANSFORM value { $$ = createSimpleNode("geomTransform",$2); }
	| GEOMTRANSFORM END { $$ = createSimpleNode("geomTransform",strdup("END")); } // END can't be included in the value enumeration because it caues shift/reduce errors
	| INITIALGAP value { $$ = createSimpleNode("initialGap",$2); }
	| LINECAP value { $$ = createSimpleNode("lineCap",$2); }
	| LINEJOIN value { $$ = createSimpleNode("lineJoin",$2); }
	| LINEJOINMAXSIZE value { $$ = createSimpleNode("lineJoinMaxSize",$2); }
	| MAXSCALEDENOM value { $$ = createSimpleNode("maxScaleDenom",$2); }
	| MAXSIZE value { $$ = createSimpleNode("maxSize",$2); }
	| MAXWIDTH value { $$ = createSimpleNode("maxWidth",$2); }
	| MINSCALEDENOM value { $$ = createSimpleNode("minScaleDenom",$2); }
	| MINSIZE value { $$ = createSimpleNode("minSize",$2); }
	| MINWIDTH value { $$ = createSimpleNode("minWidth",$2); }
	| OFFSET xyValue { $$ = wrapNode(nameNode("offset",$2)); }
	| OPACITY value { $$ = createSimpleNode("opacity",$2); }
	| OUTLINECOLOR rgbColor { $$ = wrapNode(nameNode("outlineColor",$2)); }
	| OUTLINECOLOR MS_BINDING { $$ = createSimpleNode("outlineColorAttribute",$2); }
	| OUTLINEWIDTH value { $$ = createSimpleNode("outlineWidth",$2); }
	| PATTERN valueList END { $$ = createSimpleNode("pattern",$2); }
	| POLAROFFSET value { $$ = createSimpleNode("polarOffset",$2); }
	| SIZE value { $$ = createSimpleNode("size",$2); }
	| SYMBOL symbolValue { $$ = wrapNode(nameNode("symbol",$2)); }
	| WIDTH value { $$ = createSimpleNode("width",$2); }
	;

symbol_block
	: SYMBOL symbol_stmts END { $$ = wrapNode($2); }
	| SYMBOL END { $$ = 0; }
	;
symbol_stmts
	: symbol_stmts symbol_stmt { $$ = mergeNodes($1,$2); }
	| symbol_stmt { $$ = nameNode("Symbol",$1); }
	;
symbol_stmt
	: ANCHORPOINT xyValue { $$ = wrapNode(nameNode("anchorPoint",$2)); }
	| ANTIALIAS value { $$ = createSimpleNode("antialias",$2); }
	| CHARACTER value { $$ = createSimpleNode("character",$2); }
	| FILLED value { $$ = createSimpleNode("filled",$2); }
	| FONT value { $$ = createSimpleNode("font",$2); }
	| GAP value { $$ = createSimpleNode("gap",$2); }
	| IMAGE value { $$ = createSimpleNode("image",$2); }
	| NAME value { $$ = createAttributeNode("name",$2); }
	| LINECAP value { $$ = createSimpleNode("lineCap",$2); }
	| LINEJOIN value { $$ = createSimpleNode("lineJoin",$2); }
	| LINEJOINMAXSIZE value { $$ = createSimpleNode("lineJoinMaxSize",$2); }
	| PATTERN valueList END { $$ = createSimpleNode("pattern",$2); }
	| points_block { $$ = $1; }
	| TRANSPARENT value { $$ = createSimpleNode("transparent",$2); }
	| TYPE value { $$ = createAttributeNode("type",$2); }
	;

web_block
	: WEB web_stmts END { $$ = wrapNode($2); }
	| WEB END { $$ = 0; }
	;
web_stmts
	: web_stmts web_stmt { $$ = mergeNodes($1,$2); }
	| web_stmt { $$ = nameNode("Web",$1); }
	;
web_stmt
	: BROWSEFORMAT value { $$ = createSimpleNode("browseFormat",$2); }
	| EMPTY value { $$ = createSimpleNode("empty",$2); }
	| ERROR value { $$ = createSimpleNode("error",$2); }
	| FOOTER value { $$ = createSimpleNode("footer",$2); }
	| HEADER value { $$ = createSimpleNode("header",$2); }
	| IMAGEPATH value { $$ = createSimpleNode("imagePath",$2); }
	| IMAGEURL value { $$ = createSimpleNode("imageUrl",$2); }
	| LEGENDFORMAT value { $$ = createSimpleNode("legendFormat",$2); }
	| LOG value { $$ = createSimpleNode("log",$2); }
	| MAXSCALEDENOM value { $$ = createSimpleNode("maxScaleDenom",$2); }
	| MAXSCALE value { $$ = 0; }
	| MAXTEMPLATE value { $$ = createSimpleNode("maxTemplate",$2); }
	| metadata_block { $$ = $1; }
	| MINSCALEDENOM value { $$ = createSimpleNode("minScaleDenom",$2); }
	| MINSCALE value { $$ = createSimpleNode("minScale",$2); }
	| MINTEMPLATE value { $$ = createSimpleNode("minTemplate",$2); }
	| QUERYFORMAT value { $$ = createSimpleNode("queryFormat",$2); }
	| TEMPLATE value { $$ = createSimpleNode("template",$2); }
	| TEMPPATH value { $$ = createSimpleNode("tempPath",$2); }
	| validation_block { $$ = $1; }
	;
metadata_block
	: METADATA items END { $$ = wrapNode(nameNode("Metadata",$2)); }
	| METADATA END { $$ = 0; }
	;
validation_block
	: VALIDATION items END { $$ = wrapNode(nameNode("Validation",$2)); }
	| VALIDATION END { $$ = 0; }
	;

	
	
%%

void yyerror(const char *s) {
 fprintf(stderr, "%s (line: %d): %s\n", s, lineNumber+1,yytext);
 exit(1);
}
