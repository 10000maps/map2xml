%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "mapfilexml.h"


int yylex();
int yyparse();
char *yytext;
int line_number;

XmlNode* wrapNode(XmlNode *child);
XmlNode* mergeNodes(XmlNode *node1, XmlNode *node2);
XmlNode* nameNode(const char *name, XmlNode *node);
XmlNode* createSimpleNode(const char *name, const char *content);
XmlNode* addColorOptionNode(const char *rgbName, const char *attributeName, XmlNode* node);
XmlNode* nameNode(const char *name, XmlNode* node);
XmlNode* addAttribute(char const *name, char const *value);
XmlNode* newNode(const char *name);
XmlNode* configNode = 0;
XmlNode* addToMapConfig(const char *name, const char *value);
char *concatStrings(char *str1, char *str2);
char *createExtentString(char *str1, char *str2, char *str3, char *str4);
XmlNode *createItemNode(const char *name, const char *value);
XmlNode *createSizeNode(char *xstr, char *ystr);
XmlNode *createRGBNode(char *rstr, char *gstr, char *bstr);
XmlNode *createNodeWithTextContent(char *content);
void yyerror(const char *s);
/*

//using namespace std;
#define NODE_BIT 0
#define NODE 1
// stuff from flex that bison needs to know about:

 
void yyerror(const char *s);

vector<XmlNode*> nodes;
vector<XmlNodeBit*> nodeBits;

int addAttribute(char const *name, char const *value);
int createSimpleNode(const char *name, const char *content);
int createSimpleNode(const char *name, int index);
int createNode(const char *name, int bitIndex);
int addNodeBitToNode(int nodeIndex, int nodeBitIndex);
int wrapNodeWithBit(int nodeIndex);
int createItemNode(const char *name, const char *value);
int addTextContent(const char *content);
int addColorOptionNode(const char *rgbName, const char *attributeName, int index);
int configNodeIndex = -1;
char tempString[LARGE_STRING_SIZE];*/
%}


%union {
	char *str;
	struct XmlNode *node;
}

// define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the union:
%token <str> COLORRANGE DATARANGE RANGEITEM ALIGN ANCHORPOINT ANGLE ANTIALIAS BACKGROUNDCOLOR BANDSITEM 
  BINDVALS BROWSEFORMAT BUFFER CHARACTER CLASS CLASSITEM CLASSGROUP CLUSTER COLOR CONFIG CONNECTION 
  CONNECTIONTYPE DATA DATAPATTERN DEBUG DRIVER DUMP EMPTY ENCODING END ERROR EXPRESSION EXTENT 
  EXTENSION FEATURE FILLED FILTER FILTERITEM FOOTER FONT FONTSET FORCE FORMATOPTION FROM GAP 
  GEOMTRANSFORM GRID GRIDSTEP GRATICULE GROUP HEADER IMAGE IMAGECOLOR IMAGETYPE IMAGEQUALITY 
  IMAGEMODE IMAGEPATH TEMPPATH IMAGEURL INCLUDE INDEX INITIALGAP INTERLACE INTERVALS JOIN KEYIMAGE 
  KEYSIZE KEYSPACING LABEL LABELCACHE LABELFORMAT LABELITEM LABELMAXSCALE LABELMAXSCALEDENOM 
  LABELMINSCALE LABELMINSCALEDENOM LABELREQUIRES LATLON LAYER LEADER LEGEND LEGENDFORMAT LINECAP 
  LINEJOIN LINEJOINMAXSIZE LOG MAP MARKER MARKERSIZE MASK MAXARCS MAXBOXSIZE MAXDISTANCE MAXFEATURES
  MAXINTERVAL MAXSCALE MAXSCALEDENOM MAXGEOWIDTH MAXLENGTH MAXSIZE MAXSUBDIVIDE MAXTEMPLATE MAXWIDTH
  METADATA MIMETYPE MINARCS MINBOXSIZE MINDISTANCE REPEATDISTANCE MAXOVERLAPANGLE MINFEATURESIZE 
  MININTERVAL MINSCALE MINSCALEDENOM MINGEOWIDTH MINLENGTH MINSIZE MINSUBDIVIDE MINTEMPLATE MINWIDTH
  NAME OFFSET OFFSITE OPACITY OUTLINECOLOR OUTLINEWIDTH OUTPUTFORMAT OVERLAYBACKGROUNDCOLOR 
  OVERLAYCOLOR OVERLAYMAXSIZE OVERLAYMINSIZE OVERLAYOUTLINECOLOR OVERLAYSIZE OVERLAYSYMBOL PARTIALS 
  PATTERN POINTS ITEMS POSITION POSTLABELCACHE PRIORITY PROCESSING PROJECTION QUERYFORMAT QUERYMAP 
  REFERENCE REGION RELATIVETO REQUIRES RESOLUTION DEFRESOLUTION SCALE SCALEDENOM SCALEBAR 
  SHADOWCOLOR SHADOWSIZE SHAPEPATH SIZE SIZEUNITS STATUS STYLE STYLEITEM SYMBOL SYMBOLSCALE 
  SYMBOLSCALEDENOM SYMBOLSET TABLE TEMPLATE TEMPLATEPATTERN TEXT TILEINDEX TILEITEM TITLE TO 
  TOLERANCE TOLERANCEUNITS TRANSPARENCY TRANSPARENT TRANSFORM TYPE UNITS VALIDATION WEB WIDTH WKT 
  WRAP MS_LAYER_ANNOTATION MS_AUTO MS_AUTO2 MS_CJC_BEVEL MS_BITMAP MS_CJC_BUTT MS_CC MS_ALIGN_CENTER
  MS_LAYER_CHART MS_LAYER_CIRCLE MS_CL MS_CR MS_DB_CSV MS_DB_POSTGRES MS_DB_MYSQL MS_DEFAULT MS_DD 
  MS_SYMBOL_ELLIPSE MS_EMBED MS_FALSE MS_FEET MS_FOLLOW MS_GIANT MS_SYMBOL_HATCH MS_HILITE MS_INCHES
  MS_KILOMETERS MS_LARGE MS_LC MS_ALIGN_LEFT MS_LAYER_LINE MS_LL MS_LR MS_MEDIUM MS_METERS 
  MS_NAUTICALMILES MS_MILES MS_CJC_MITER MS_MULTIPLE MS_CJC_NONE MS_NORMAL MS_OFF MS_OGR MS_ON 
  MS_JOIN_ONE_TO_ONE MS_JOIN_ONE_TO_MANY MS_ORACLESPATIAL MS_PERCENTAGES MS_SYMBOL_PIXMAP MS_PIXELS 
  MS_LAYER_POINT MS_LAYER_POLYGON MS_POSTGIS MS_PLUGIN MS_LAYER_QUERY MS_LAYER_RASTER MS_ALIGN_RIGHT
  MS_CJC_ROUND MS_SDE MS_SELECTED MS_SYMBOL_SIMPLE MS_SINGLE MS_SMALL MS_CJC_SQUARE MS_SYMBOL_SVG 
  POLAROFFSET MS_TINY MS_CJC_TRIANGLE MS_TRUE MS_TRUETYPE MS_UC MS_UL MS_UR MS_UNION MS_UVRASTER 
  MS_SYMBOL_VECTOR MS_WFS MS_WMS MS_GD_ALPHA MS_BINDING MS_NUMBER MS_IREGEX MS_REGEX MS_EXPRESSION 
  MS_STRING ANGLEITEM LABELANGLEITEM LABELSIZEITEM ALPHACOLORRANGE ALPHACOLOR BACKGROUNDSHADOWCOLOR
  BACKGROUNDSHADOWSIZE MS_SYMBOL_CARTOLINE MS_MYGIS MS_ISTRING

%type <node> mapfile layer_set symbol_set class_block class_stmts class_stmt cluster_block 
  cluster_stmts cluster_stmt feature_block feature_stmts feature_stmt grid_block grid_stmts 
  grid_stmt join_block join_stmts join_stmt label_block label_stmts label_stmt layer_block 
  layer_stmts layer_stmt leader_block leader_stmts leader_stmt legend_block legend_stmts 
  legend_stmt map_block map_stmts map_stmt metadata_block outputformat_block outputformat_stmts 
  outputformat_stmt points_block point_stmt point_stmts projection_block querymap_block 
  querymap_stmts querymap_stmt reference_block reference_stmts reference_stmt scalebar_block 
  scalebar_stmts scalebar_stmt style_block style_stmts style_stmt symbol_block symbol_stmts 
  symbol_stmt validation_block web_block web_stmts web_stmt str_pairs str_pair x_y rgb 
  color_opt;

%type <str> expression_opt debug_opts on_off units_opt symbol_type_opt querymap_style_opt extent_opt num_str
  position_opt true_false size_opt transparency_opt layer_type_opt legend_status_opt status_opt 
  transform_opt connectiontype_opt type_opt linejoin_opt linecap_opt style_angle_opt align_opt 
  angle_opt str_attr number_auto num_str_attr num_attr proj_list number_list;

%%

mapfile : map_block                                           { printf("reducing to mapfile\n");XmlNode_print($1); }
        | layer_set                                           { XmlNode_print($1); }
        | symbol_set                                          { XmlNode_print($1); }
        ;

layer_set : layer_set layer_block                             { 
																XmlNode_addChild($1,$2);
                                                                $$ = $1;
                                                              }
          | layer_block                                       { 
                                                                XmlNode *node = XmlNode_new();
																XmlNode_setName(node,"LayerSet");
																if($1 != 0)
																	XmlNode_merge(node,$1);
																$$ = node;
                                                              }
          ;
symbol_set : symbol_set symbol_block                         { 
                                                                if($2 != 0)
																	XmlNode_merge($1,$2);
																$$ = $1;
                                                              }
           | symbol_block                                    {
                                                                XmlNode *node = XmlNode_new();
																XmlNode_setName(node,"SymbolSet");
																if($1 != 0)
																	XmlNode_merge(node,$1);
																$$ = node;
                                                              };

class_block : CLASS class_stmts END                           { $$ = wrapNode($2); }
            ;
class_stmts : class_stmts class_stmt                          { $$ = mergeNodes($1,$2); }
            | class_stmt                                      { $$ = nameNode("Class",$1); }
            ;
class_stmt : BACKGROUNDCOLOR rgb                             { $$ = wrapNode(nameNode("backgroundColor",$2)); }
           | COLOR rgb                                       { $$ = wrapNode(nameNode("backgroundColor",$2)); }
           | DEBUG on_off                                    { $$ = createSimpleNode("debug",$2); }
           | EXPRESSION expression_opt                       { $$ = 0; }
           | GROUP MS_STRING                                 { $$ = createSimpleNode("group",$2); }
           | KEYIMAGE MS_STRING                              { $$ = createSimpleNode("keyImage",$2); }
           | label_block                                     { $$ = $1; }
           | leader_block                                    { $$ = $1; }
           | MAXSCALEDENOM MS_NUMBER                         { $$ = createSimpleNode("maxScaleDenom",$2); }
           | MAXSIZE MS_NUMBER                               { $$ = createSimpleNode("maxSize",$2); }
           | metadata_block                                  { $$ = $1; }
           | MINSCALEDENOM MS_NUMBER                         { $$ = createSimpleNode("minScaleDenom",$2); }
           | MINSIZE MS_NUMBER                               { $$ = createSimpleNode("minSize",$2); }
           | NAME MS_STRING                                  { $$ = addAttribute("name",$2); }
           | OUTLINECOLOR rgb                                { $$ = 0; }
           | SIZE MS_NUMBER                                  { $$ = createSimpleNode("size",$2); }
           | STATUS on_off                                   { $$ = addAttribute("status",$2); }
           | style_block                                     { $$ = $1; }
           | SYMBOL num_str                                  { $$ = createSimpleNode("symbol",$2); }
           | TEMPLATE MS_STRING                              { $$ = createSimpleNode("template",$2); }
           | TEXT expression_opt                             { $$ = 0; }
           | validation_block                                { $$ = $1; }
           ;

cluster_block : CLUSTER cluster_stmts END                     { $$ = wrapNode($2); }
              ;
cluster_stmts : cluster_stmts cluster_stmt                    { $$ =   mergeNodes($1,$2); }
              | cluster_stmt                                  { $$ = nameNode("Cluster",$1); }
              ;
cluster_stmt : MAXDISTANCE MS_NUMBER                         { $$ = createSimpleNode("maxDistance",$2); }
             | REGION MS_STRING                              { $$ = createSimpleNode("region",$2); }
             | BUFFER MS_NUMBER                              { $$ = createSimpleNode("buffer",$2); }
             | GROUP expression_opt                          { $$ = 0; }
             | FILTER expression_opt                         { $$ = 0; }
             ;

feature_block : FEATURE feature_stmts END                     { $$ = wrapNode($2); }
              ;
feature_stmts : feature_stmts feature_stmt                    { $$ =   mergeNodes($1,$2); }
              | feature_stmt                                  { $$ = nameNode("Feature",$1); }
              ;
feature_stmt : points_block                                  { $$ = $1; }
             | ITEMS MS_STRING                               { $$ = createSimpleNode("items",$2); }
             | TEXT MS_STRING                                { $$ = createSimpleNode("text",$2); }
             | WKT MS_STRING                                 { $$ = createSimpleNode("wkt",$2); }
             ;

grid_block : GRID grid_stmts END                             { $$ = wrapNode($2); }
           ;
grid_stmts : grid_stmts grid_stmt                            { $$ =   mergeNodes($1,$2); }
           | grid_stmt                                       { $$ = nameNode("Grid",$1); }
           ;
grid_stmt : LABELFORMAT MS_STRING                             { $$ = createSimpleNode("labelFont",$2); }
          | MINARCS MS_NUMBER                                 { $$ = createSimpleNode("minArcs",$2); }
          | MAXARCS MS_NUMBER                                 { $$ = createSimpleNode("maxArcs",$2); }
          | MININTERVAL MS_NUMBER                             { $$ = createSimpleNode("minInterval",$2); }
          | MAXINTERVAL MS_NUMBER                             { $$ = createSimpleNode("maxInterval",$2); }
          | MINSUBDIVIDE MS_NUMBER                            { $$ = createSimpleNode("minSubdivide",$2); }
          | MAXSUBDIVIDE MS_NUMBER                            { $$ = createSimpleNode("maxSubdivide",$2); }
          ;


join_block : JOIN join_stmts END                             { $$ = wrapNode($2); }
           ;
join_stmts : join_stmts join_stmt                            { $$ =   mergeNodes($1,$2); }
           | join_stmt                                       { $$ = nameNode("Join",$1); }
           ;
join_stmt : CONNECTION MS_STRING                              { $$ = createSimpleNode("connection",$2); }
          | CONNECTIONTYPE MS_STRING                          { $$ = createSimpleNode("connectionType",$2); }
          | FOOTER MS_STRING                                  { $$ = createSimpleNode("footer",$2); }
          | FROM MS_STRING                                    { $$ = createSimpleNode("from",$2); }
          | HEADER MS_STRING                                  { $$ = createSimpleNode("header",$2); }
          | NAME MS_STRING                                    { $$ = createSimpleNode("name",$2); }
          | TABLE MS_STRING                                   { $$ = createSimpleNode("table",$2); }
          | TEMPLATE MS_STRING                                { $$ = createSimpleNode("template",$2); }
          | TO MS_STRING                                      { $$ = createSimpleNode("to",$2); }
          | TYPE  MS_STRING                                   { $$ = createSimpleNode("type",$2); }
          ;

label_block : LABEL label_stmts END                           { $$ = wrapNode($2); }
            ;
label_stmts : label_stmts label_stmt                          { $$ =   mergeNodes($1,$2); }
            | label_stmt                                      { $$ = nameNode("Label",$1); }
            ;
label_stmt : ALIGN align_opt                                 { $$ = createSimpleNode("align",$2); }
           | ANGLE angle_opt                                 { $$ = createSimpleNode("angle",$2); }
           | ANTIALIAS true_false                            { $$ = createSimpleNode("antialias",$2); }
		   | BACKGROUNDCOLOR rgb                             { $$ = wrapNode(nameNode("backgroundColor",$2)); }
		   | BACKGROUNDSHADOWCOLOR rgb                       { $$ = wrapNode(nameNode("backgroundShadowColor",$2)); }
		   | BACKGROUNDSHADOWSIZE x_y                        { $$ = wrapNode(nameNode("backgroundShadowSize",$2)); }		   
           | BUFFER MS_NUMBER                                { $$ = createSimpleNode("buffer",$2); }
           | COLOR color_opt                                 { $$ = addColorOptionNode("color","colorAttribute",$2); }
           | ENCODING MS_STRING                              { $$ = createSimpleNode("encoding",$2); }
           | EXPRESSION expression_opt                       { $$ = 0; }
           | FONT str_attr                                   { $$ = createSimpleNode("font",$2); }
           | FORCE true_false                                { $$ = createSimpleNode("force",$2); }
           | MAXLENGTH MS_NUMBER                             { $$ = createSimpleNode("maxLength",$2); }
           | MAXOVERLAPANGLE MS_NUMBER                       { $$ = createSimpleNode("maxOverlapAngle",$2); }
           | MAXSCALEDENOM MS_NUMBER                         { $$ = createSimpleNode("maxScaleDenom",$2); }
           | MAXSIZE MS_NUMBER                               { $$ = createSimpleNode("maxSize",$2); }
           | MINDISTANCE MS_NUMBER                           { $$ = createSimpleNode("minDistance",$2); }
           | MINFEATURESIZE number_auto                      { $$ = createSimpleNode("minFeatureSize",$2); }
           | MINSCALEDENOM MS_NUMBER                         { $$ = createSimpleNode("minScaleDenom",$2); }
           | MINSIZE MS_NUMBER                               { $$ = createSimpleNode("minSize",$2); }
           | OFFSET x_y                                      { $$ = wrapNode(nameNode("offset",$2)); }
           | OUTLINECOLOR color_opt                          { $$ = addColorOptionNode("outlineColor","outlineColorAttribute",$2); }
           | OUTLINEWIDTH MS_NUMBER                          { $$ = createSimpleNode("outlineWidth",$2); }
           | PARTIALS true_false                             { $$ = createSimpleNode("partials",$2); }
           | POSITION position_opt                           { $$ = createSimpleNode("position",$2); }
           | PRIORITY   num_str_attr                         { $$ = createSimpleNode("priority",$2); }
           | REPEATDISTANCE MS_NUMBER                        { $$ = createSimpleNode("repeatDistance",$2); }
           | SHADOWCOLOR rgb                                 { $$ = wrapNode(nameNode("shadowColor",$2)); }
           | SHADOWSIZE x_y                                  { $$ = wrapNode(nameNode("shadowSize",$2)); }
           | SIZE size_opt                                   { $$ = createSimpleNode("size",$2); }
           | style_block                                     { $$ = $1; }
           | TEXT expression_opt                             { $$ = 0; }
           | TYPE type_opt                                   { $$ = addAttribute("type",$2); }
           | WRAP MS_STRING                                  { $$ = createSimpleNode("wrap",$2); }
           ;

layer_block : LAYER layer_stmts END                           { $$ = wrapNode($2); }
            ;
            
layer_stmts : layer_stmts layer_stmt                          { $$ =   mergeNodes($1,$2); }
            | layer_stmt                                      { $$ = nameNode("Layer",$1); }
            ;
layer_stmt : class_block                                     { $$ = $1; }
           | CLASSGROUP MS_STRING                            { $$ = createSimpleNode("classGroup",$2); }
           | CLASSITEM MS_BINDING                            { $$ = createSimpleNode("classItem",$2); }
           | CLASSITEM MS_STRING                             { $$ = createSimpleNode("classItem",$2); }
           | cluster_block                                   { $$ = $1; }
           | CONNECTION MS_STRING                            { $$ = createSimpleNode("connection",$2); }
           | CONNECTIONTYPE connectiontype_opt               { $$ = createSimpleNode("connectionType",$2); }
           | DATA MS_STRING                                  { $$ = createSimpleNode("data",$2); }
           | DEBUG debug_opts                                { $$ = createSimpleNode("debug",$2); }
           | DUMP true_false                                 { $$ = createSimpleNode("dump",$2); }
           | EXTENT extent_opt                               { $$ = createSimpleNode("extent",$2); }
           | feature_block                                   { $$ = $1; }
           | FILTER expression_opt                           { $$ = 0; }
           | FILTERITEM str_attr                           { $$ = createSimpleNode("filterItem",$2); }
           | FOOTER MS_STRING                                { $$ = createSimpleNode("footer",$2); }
           | grid_block                                      { $$ = $1; }
           | GROUP MS_STRING                                 { $$ = createSimpleNode("group",$2); }
           | HEADER MS_STRING                                { $$ = createSimpleNode("header",$2); }
           | join_block                                      { $$ = $1; }
           | LABELANGLEITEM MS_BINDING                       { $$ = createSimpleNode("labelAngleItem",$2); }
           | LABELCACHE on_off                               { $$ = createSimpleNode("labelCahce",$2); }
           | LABELITEM MS_BINDING                            { $$ = createSimpleNode("labelItem",$2); }
           | LABELITEM MS_STRING                             { $$ = createSimpleNode("labelItem",$2); }
           | LABELMAXSCALEDENOM MS_NUMBER                    { $$ = createSimpleNode("labelMaxScaleDenom",$2); }
           | LABELMINSCALEDENOM MS_NUMBER                    { $$ = createSimpleNode("labelMinScaleDenom",$2); }
           | LABELREQUIRES expression_opt                    { $$ = 0; }
           | LABELSIZEITEM MS_BINDING                        { $$ = createSimpleNode("labelSizeItem",$2); }
           | MASK MS_STRING                                  { $$ = createSimpleNode("mask",$2); }
           | MAXFEATURES MS_NUMBER                           { $$ = createSimpleNode("maxFeatures",$2); }
           | MAXGEOWIDTH MS_NUMBER                           { $$ = createSimpleNode("maxGeoWidth",$2); }
           | MAXSCALEDENOM MS_NUMBER                         { $$ = createSimpleNode("maxScaleDenom",$2); }
           | metadata_block                                  { $$ = $1; }
           | MINGEOWIDTH MS_NUMBER                           { $$ = createSimpleNode("minGeoWidth",$2); }
           | MINSCALEDENOM MS_NUMBER                         { $$ = createSimpleNode("minScaleDenom",$2); }
           | NAME MS_STRING                                  { $$ = createSimpleNode("name",$2); }
           | OFFSITE rgb                                     { $$ = 0; }
           | OPACITY num_str                                 { $$ = createSimpleNode("opacity",$2); }
           | MS_PLUGIN MS_NUMBER                             { $$ = createSimpleNode("plugin",$2); }
           | POSTLABELCACHE true_false                       { $$ = createSimpleNode("postLabelCache",$2); }
           | PROCESSING MS_STRING                            { $$ = createSimpleNode("processing",$2); }
           | projection_block                                { $$ = 0; }
           | REQUIRES expression_opt                         { $$ = 0; }
           | SIZEUNITS units_opt                             { $$ = createSimpleNode("sizeUnites",$2); }
           | STATUS status_opt                               { $$ = 0; }
           | STYLEITEM str_attr                              { $$ = createSimpleNode("styleItem",$2); }
           | SYMBOLSCALEDENOM MS_NUMBER                      { $$ = createSimpleNode("symbolScaleDenom",$2); }
           | TEMPLATE MS_STRING                              { $$ = createSimpleNode("template",$2); }
           | TILEINDEX MS_STRING                             { $$ = createSimpleNode("tileIndex",$2); }
           | TILEITEM MS_BINDING                             { $$ = createSimpleNode("tileItem",$2); }
           | TOLERANCE MS_NUMBER                             { $$ = createSimpleNode("tolerance",$2); }
           | TOLERANCEUNITS units_opt                        { $$ = createSimpleNode("toleranceUnits",$2); }
           | TRANSPARENCY transparency_opt                   { $$ = createSimpleNode("transparency",$2); }
           | TRANSFORM transform_opt                         { $$ = createSimpleNode("transform",$2); }
           | TYPE layer_type_opt                             { $$ = createSimpleNode("type",$2); }
           | UNITS units_opt                                 { $$ = createSimpleNode("units",$2); }
           | validation_block                                { $$ = $1; }
           ;

leader_block : LEADER leader_stmts END                       { $$ = wrapNode($2); }
             ;
leader_stmts : leader_stmts leader_stmt                      { $$ =   mergeNodes($1,$2); }
             | leader_stmt                                   { $$ = nameNode("Leader",$1); }
             ;
leader_stmt : GRIDSTEP MS_NUMBER                              { $$ = createSimpleNode("gridStep",$2); }
            | MAXDISTANCE MS_NUMBER                           { $$ = createSimpleNode("maxDistance",$2); }
            | style_block                                     { $$ = $1; }
            ;


legend_block : LEGEND legend_stmts END                       { $$ = wrapNode($2); }
             ;
legend_stmts : legend_stmts legend_stmt                      { $$ =   mergeNodes($1,$2); }
             | legend_stmt                                   { $$ = nameNode("Legend",$1); }
             ;
legend_stmt : IMAGECOLOR rgb                                  { $$ = wrapNode(nameNode("imageColor",$2)); }
            | INTERLACE on_off                                { $$ = createSimpleNode("interlace",$2); }
            | KEYSIZE x_y                                     { $$ = wrapNode(nameNode("keySize",$2)); }
            | KEYSPACING x_y                                  { $$ = wrapNode(nameNode("keySpacing",$2)); }
            | label_block                                     { $$ = $1; }
            | OUTLINECOLOR rgb                                { $$ = wrapNode(nameNode("outlineColor",$2)); }
            | POSITION position_opt                           { $$ = createSimpleNode("position",$2); }
            | POSTLABELCACHE true_false                       { $$ = createSimpleNode("postLabelCache",$2); }
            | STATUS legend_status_opt                        { $$ = addAttribute("status",$2); }
            | TEMPLATE MS_STRING                              { $$ = createSimpleNode("template",$2); }
            | TRANSPARENT on_off                              { $$ = createSimpleNode("transparent",$2); }
            ;

map_block : MAP map_stmts END                                 { 
                                                                printf("reducing to map block\n");
																$$ = $2;
																XmlNode_addAttribute($2,"xmlns","http://www.mapserver.org/mapserver");
																XmlNode_addAttribute($2,"xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
																XmlNode_addAttribute($2,"xsi:schemaLocation","http://www.mapserver.org/mapserver ../mapfile.xsd");
																XmlNode_addAttribute($2,"version","5.6.0");
                                                              }
          ;
map_stmts : map_stmts map_stmt                                { $$ = mergeNodes($1,$2); }
          | map_stmt                                          { $$ = nameNode("Map",$1); }
          ;
map_stmt : ANGLE MS_NUMBER                                    { $$ = createSimpleNode("angle",$2); }
         | CONFIG MS_STRING MS_STRING                        { $$ = addToMapConfig($2,$3); }
         | DATAPATTERN expression_opt                        { $$ = createSimpleNode("dataPattern",$2); }
         | DEBUG debug_opts                                  { $$ = createSimpleNode("debug",$2); }
         | DEFRESOLUTION MS_NUMBER                           { $$ = createSimpleNode("defResolution",$2); }
         | EXTENT extent_opt                                 { $$ = createSimpleNode("extent",$2); }
         | FONTSET MS_STRING                                 { $$ = createSimpleNode("fontSet",$2); }
         | IMAGECOLOR rgb                                    { $$ = wrapNode(nameNode("imageColor",$2)); }
         | IMAGEQUALITY MS_NUMBER                            { $$ = createSimpleNode("",$2); }
         | IMAGETYPE MS_STRING                               { $$ = createSimpleNode("imageType",$2); }
         | INCLUDE MS_STRING                                 { $$ = createSimpleNode("include",$2); }
         | INTERLACE on_off                                  { $$ = createSimpleNode("",$2); }
         | layer_block                                       { $$ = $1; }
         | legend_block                                      { $$ = $1; }
         | MAXSIZE MS_NUMBER                                 { $$ = createSimpleNode("maxSize",$2); }
         | NAME MS_STRING                                    { $$ = addAttribute("name",$2); };
         | outputformat_block                                { $$ = $1; }
         | projection_block                                  { $$ = $1; }
         | querymap_block                                    { $$ = $1; }
         | reference_block                                   { $$ = $1; }
         | RESOLUTION MS_NUMBER                              { $$ = createSimpleNode("resolution",$2); }
         | SCALEDENOM MS_NUMBER                              { $$ = createSimpleNode("scaleDenom",$2); }
         | scalebar_block                                    { $$ = $1; }
         | SHAPEPATH MS_STRING                               { $$ = createSimpleNode("shapePath",$2); }
         | SIZE x_y                                          { $$ = wrapNode(nameNode("size",$2)); }
         | STATUS on_off                                     { $$ = addAttribute("status",$2); }
         | SYMBOLSET MS_STRING                               { $$ = createSimpleNode("symbolSet",$2); }
         | symbol_block                                      { $$ = $1; }
         | TEMPLATEPATTERN expression_opt                    { $$ = createSimpleNode("templatePattern",$2); }
         | TRANSPARENT on_off                                { $$ = createSimpleNode("",$2); }
         | UNITS units_opt                                   { $$ = createSimpleNode("units",$2); }
         | web_block                                         { $$ = $1; }
         ;


                  
metadata_block: METADATA str_pairs END                         { $$ = wrapNode(nameNode("Metadata",$2)); };



outputformat_block : OUTPUTFORMAT outputformat_stmts END      { $$ = wrapNode($2); }
                   ;
outputformat_stmts : outputformat_stmts outputformat_stmt     { $$ =   mergeNodes($1,$2); }
                   | outputformat_stmt                        { $$ = nameNode("OutputFormat",$1); }
                   ;
outputformat_stmt : DRIVER MS_STRING                           { $$ = createSimpleNode("driver",$2); }
                  | EXTENSION MS_STRING                        { $$ = createSimpleNode("extension",$2); }
                  | FORMATOPTION MS_STRING                     { $$ = createSimpleNode("formatOption",$2); }
                  | IMAGEMODE MS_STRING                        { $$ = createSimpleNode("imageMode",$2); }
                  | MIMETYPE MS_STRING                         { $$ = createSimpleNode("mimeType",$2); }
                  | NAME MS_STRING                             { $$ = addAttribute("name",$2); }
                  | TRANSPARENT on_off                         { $$ = createSimpleNode("transparent",$2); }
                  ;

points_block : POINTS point_stmts END                         { $$ = wrapNode($2); }
             ;
point_stmts : point_stmts point_stmt                           { $$ = mergeNodes($1,$2); }
            | point_stmt                                       { $$ = nameNode("Points",$1); }
            ;
point_stmt : x_y                                               { $$ = nameNode("point",$1); }
           ;

projection_block : PROJECTION proj_list END                   { $$ = createSimpleNode("projection",$2); }
                 ;
proj_list : proj_list MS_STRING                               { $$ = concatStrings(concatStrings($1,strdup("\n")),$2);}
          | MS_STRING                                          
          ;


querymap_block : QUERYMAP querymap_stmts END                  { $$ = wrapNode($2); }
               ;
querymap_stmts : querymap_stmts querymap_stmt                 { $$ =   mergeNodes($1,$2); }
               | querymap_stmt                                { $$ = nameNode("QueryMap",$1); }
               ;
querymap_stmt : COLOR rgb                                      { $$ = nameNode("color",$2); }
              | SIZE x_y                                       { $$ = nameNode("size",$2); }
              | STATUS on_off                                  { $$ = addAttribute("status",$2); }
              | STYLE querymap_style_opt                       { $$ = createSimpleNode("style",$2); }
              ;


reference_block  : REFERENCE reference_stmts END                { $$ = wrapNode($2); }
                ;
reference_stmts  : reference_stmts reference_stmt               { $$ =   mergeNodes($1,$2); }
                | reference_stmt                               { $$ = nameNode("Reference",$1); }
                ;
reference_stmt  : COLOR rgb                                    { $$ = wrapNode(nameNode("color",$2)); }
                | EXTENT extent_opt                            { $$ = createSimpleNode("extend",$2);      }
                | IMAGE MS_STRING                              { $$ = createSimpleNode("image",$2);       }
                | MARKER num_str                               { $$ = createSimpleNode("marker",$2);      }
                | MARKERSIZE MS_NUMBER                         { $$ = createSimpleNode("markerSize",$2);  }
                | MINBOXSIZE MS_NUMBER                         { $$ = createSimpleNode("minBoxSize",$2);  }
                | MAXBOXSIZE MS_NUMBER                         { $$ = createSimpleNode("maxBoxSize",$2);  }
                | OUTLINECOLOR rgb                             { $$ = wrapNode(nameNode("outlineColor",$2)); }
                | SIZE x_y                                     { $$ = wrapNode(nameNode("size",$2));        }
                | STATUS on_off                                { $$ = addAttribute("status",$2);      }
                ;


scalebar_block  : SCALEBAR scalebar_stmts END                  { $$ = wrapNode($2); }
                ;
scalebar_stmts  : scalebar_stmts scalebar_stmt                 { $$ =   mergeNodes($1,$2); }
                | scalebar_stmt                                { $$ = nameNode("ScaleBar",$1); }
                ;
scalebar_stmt : ALIGN align_opt                                { $$ = createSimpleNode("align",$2); }
              | BACKGROUNDCOLOR rgb                            { $$ = wrapNode(nameNode("backgroundColor",$2)); }
              | COLOR rgb                                      { $$ = wrapNode(nameNode("color",$2)); }
              | IMAGECOLOR rgb                                 { $$ = wrapNode(nameNode("imageColor",$2)); }
              | INTERLACE true_false                           { $$ = createSimpleNode("interlace",$2); }
              | INTERVALS MS_NUMBER                            { $$ = createSimpleNode("intervals",$2); }
              | label_block                                    { $$ = $1; }
              | OUTLINECOLOR rgb                               { $$ = wrapNode(nameNode("outlineColor",$2)); }
              | POSITION position_opt                          { $$ = createSimpleNode("position",$2); }
              | POSTLABELCACHE true_false                      { $$ = createSimpleNode("postLabelCache",$2); }
              | SIZE x_y                                       { $$ = wrapNode(nameNode("size",$2)); }
              | STATUS legend_status_opt                       { $$ = addAttribute("status",$2); }
              | STYLE MS_NUMBER                                { $$ = createSimpleNode("style",$2); }
              | TRANSPARENT on_off                             { $$ = createSimpleNode("transparent",$2); }
              | TRANSPARENT true_false                         { $$ = createSimpleNode("transparent",$2); }
              | UNITS units_opt                                { $$ = createSimpleNode("units",$2); }
              ;

style_block :  STYLE style_stmts END                             { $$ = wrapNode($2); }
            ;
style_stmts  : style_stmts style_stmt                           { $$ =   mergeNodes($1,$2); }
            | style_stmt                                       { $$ = nameNode("Style",$1); }
            ;
style_stmt  : ANGLE style_angle_opt                            { $$ = createSimpleNode("angle",$2); }
            | ANGLEITEM MS_STRING                              { $$ = createSimpleNode("angleItem",$2); }
            | ANTIALIAS true_false                             { $$ = createSimpleNode("antialias",$2); }
            | BACKGROUNDCOLOR rgb                              { $$ = 0; }
            | COLOR color_opt                                  { $$ = 0; }
            | GAP MS_NUMBER                                    { $$ = createSimpleNode("gap",$2); }
            | GEOMTRANSFORM expression_opt                     { $$ = 0; }
            | INITIALGAP MS_NUMBER                             { $$ = createSimpleNode("geomTransform",$2); }
            | LINECAP linecap_opt                              { $$ = createSimpleNode("lineCap",$2); }
            | LINEJOIN linejoin_opt                            { $$ = createSimpleNode("lineJoin",$2); }
            | LINEJOINMAXSIZE MS_NUMBER                        { $$ = createSimpleNode("lineJoinMaxSize",$2); }
            | MAXSCALEDENOM MS_NUMBER                          { $$ = createSimpleNode("maxScaleDenom",$2); }
            | MAXSIZE MS_NUMBER                                { $$ = createSimpleNode("maxSize",$2); }
            | MAXWIDTH MS_NUMBER                               { $$ = createSimpleNode("maxWitdh",$2); }
            | MINSCALEDENOM MS_NUMBER                          { $$ = createSimpleNode("minScaleDenom",$2); }
            | MINSIZE MS_NUMBER                                { $$ = createSimpleNode("minSize",$2); }
            | MINWIDTH MS_NUMBER                               { $$ = createSimpleNode("minWidth",$2); }
            | OFFSET x_y                                       { $$ = 0; }
            | OPACITY num_attr                                 { $$ = createSimpleNode("opacity",$2); }
            | OUTLINECOLOR color_opt                           { $$ = 0; }
            | OUTLINEWIDTH num_attr                            { $$ = createSimpleNode("outlineWidth",$2); }
            | PATTERN number_list END                          { $$ = 0; }
            | POLAROFFSET num_attr num_attr                    { $$ = 0; }
            | SIZE num_attr                                    { $$ = createSimpleNode("size",$2); }
            | SYMBOL num_str_attr                              { $$ = createSimpleNode("symbol",$2); }
            | WIDTH num_attr                                   { $$ = createSimpleNode("width",$2); }
            ;

symbol_block  : SYMBOL symbol_stmts END                        { $$ = wrapNode($2); }
              ;
symbol_stmts  : symbol_stmts symbol_stmt                       { $$ = mergeNodes($1,$2); }
              | symbol_stmt                                    { $$ = nameNode("Symbol",$1); }
              ;
symbol_stmt : ANCHORPOINT x_y                                  { $$ = wrapNode(nameNode("anchorPoint",$2)); }
            | ANTIALIAS true_false                             { $$ = createSimpleNode("antialias",$2); }
            | CHARACTER MS_STRING                              { $$ = createSimpleNode("character",$2); }
            | FILLED true_false                                { $$ = createSimpleNode("filled",$2); }
            | FONT MS_STRING                                   { $$ = createSimpleNode("font",$2); }
			| GAP MS_NUMBER                                    { $$ = createSimpleNode("gap",$2); }
            | IMAGE MS_STRING                                  { $$ = createSimpleNode("image",$2); }
            | NAME MS_STRING                                   { $$ = addAttribute("name",$2); }
			| LINECAP linecap_opt                              { $$ = createSimpleNode("lineCap",$2); }
			| LINEJOIN linejoin_opt                            { $$ = createSimpleNode("lineJoin",$2); }
			| LINEJOINMAXSIZE MS_NUMBER                        { $$ = createSimpleNode("lineJoinMaxSize",$2); }
			| PATTERN number_list                              { $$ = createSimpleNode("pattern",$2); }
            | points_block                                     { $$ = $1; }
            | TRANSPARENT num_str                              { $$ = createSimpleNode("transparent",$2); }
            | TYPE symbol_type_opt                             { $$ = addAttribute("type",$2); }
            ;

validation_block: VALIDATION str_pairs END                     { $$ = wrapNode(nameNode("Validation",$2)); }
                ;

web_block  : WEB web_stmts END                                  { $$ = wrapNode($2); }
          ;
web_stmts  : web_stmts web_stmt                                 { $$ =   mergeNodes($1,$2); }
          | web_stmt                                           { $$ = nameNode("Web",$1); }
          ;
web_stmt  : BROWSEFORMAT MS_STRING                             { $$ = createSimpleNode("browseFormat",$2); }
          | EMPTY MS_STRING                                    { $$ = createSimpleNode("empty",$2); }
          | ERROR MS_STRING                                    { $$ = createSimpleNode("error",$2); }
          | FOOTER MS_STRING                                   { $$ = createSimpleNode("footer",$2); }
          | HEADER MS_STRING                                   { $$ = createSimpleNode("header",$2); }
          | IMAGEPATH MS_STRING                                { $$ = createSimpleNode("imagePath",$2); }
          | IMAGEURL MS_STRING                                 { $$ = createSimpleNode("imageUrl",$2); }
          | LEGENDFORMAT MS_STRING                             { $$ = createSimpleNode("legendFormat",$2); }
          | LOG MS_STRING                                      { $$ = createSimpleNode("log",$2); }
          | MAXSCALEDENOM MS_NUMBER                            { $$ = createSimpleNode("maxScaleDenom",$2); }
          | MAXSCALE MS_NUMBER                                 { $$ = 0; }
          | MAXTEMPLATE MS_STRING                              { $$ = createSimpleNode("maxTemplate",$2); }
          | metadata_block                                     { $$ = $1; }
          | MINSCALEDENOM MS_NUMBER                            { $$ = createSimpleNode("minScaleDenom",$2); }
          | MINSCALE MS_NUMBER                                 { $$ = createSimpleNode("",$2); }
          | MINTEMPLATE MS_STRING                              { $$ = createSimpleNode("minTemplate",$2); }
          | QUERYFORMAT MS_STRING                              { $$ = createSimpleNode("queryFormat",$2); }
          | TEMPLATE MS_STRING                                 { $$ = createSimpleNode("template",$2); }
          | TEMPPATH MS_STRING                                 { $$ = createSimpleNode("",$2); }
          | validation_block                                   { $$ = $1; }
          ;



extent_opt : MS_NUMBER MS_NUMBER MS_NUMBER MS_NUMBER           { $$ = createExtentString($1,$2,$3,$4); }


transparency_opt  : MS_NUMBER  
                  | MS_GD_ALPHA
                  ;
layer_type_opt  : MS_LAYER_ANNOTATION
                | MS_LAYER_CHART     
                | MS_LAYER_CIRCLE    
                | MS_LAYER_LINE      
                | MS_LAYER_POINT     
                | MS_LAYER_POLYGON   
                | MS_LAYER_RASTER    
                | MS_LAYER_QUERY     
                ;

symbol_type_opt  : MS_SYMBOL_ELLIPSE
                | MS_SYMBOL_HATCH  
                | MS_SYMBOL_PIXMAP 
                | MS_SYMBOL_SVG    
                | MS_TRUETYPE      
                | MS_SYMBOL_VECTOR 
                | MS_SYMBOL_SIMPLE   
				| MS_SYMBOL_CARTOLINE
                ;

legend_status_opt : MS_EMBED 
                  | on_off   
                  ;


transform_opt  : true_false  
              | position_opt
              ;

status_opt: on_off    
          | MS_DEFAULT
          ;

connectiontype_opt  : MS_OGR           
                    | MS_ORACLESPATIAL 
                    | MS_PLUGIN        
                    | MS_POSTGIS       
                    | MS_SDE           
                    | MS_UNION         
                    | MS_UVRASTER      
                    | MS_WFS           
                    | MS_WMS           
                    ; // LOCAL IS MISSING


str_pairs  : str_pairs str_pair                                 { $$ = mergeNodes($1,$2); }
          | str_pair
          ;
str_pair  : MS_STRING MS_STRING                                 { $$ = createItemNode($1,$2); }
          ;
type_opt  : MS_TRUETYPE
          | MS_BITMAP  
          ;

number_list  : number_list MS_NUMBER                            { $$ = 0; }
            | MS_NUMBER                                        { $$ = 0; }
            ;

x_y : MS_NUMBER MS_NUMBER                         { $$ = createSizeNode($1,$2); }
    ;

linecap_opt  : MS_CJC_BUTT  
            | MS_CJC_ROUND 
            | MS_CJC_SQUARE
            | MS_CJC_TRIANGLE
            ;
linejoin_opt  : MS_CJC_ROUND 
              | MS_CJC_MITER 
              | MS_CJC_BEVEL 
              ;

rgb : MS_NUMBER MS_NUMBER MS_NUMBER    { $$ = createRGBNode($1,$2,$3); }
    ;

style_angle_opt  : MS_NUMBER  
                | MS_BINDING 
                | MS_AUTO    
                ;

units_opt  : MS_DD            
          | MS_FEET          
          | MS_INCHES        
          | MS_KILOMETERS    
          | MS_METERS        
          | MS_MILES         
          | MS_NAUTICALMILES 
          ;
debug_opts  : on_off    
            | MS_NUMBER 
            ;
on_off  : MS_ON          
        | MS_OFF        
        ;
align_opt  : MS_ALIGN_LEFT   
          | MS_ALIGN_CENTER 
          | MS_ALIGN_RIGHT  
          ;
angle_opt  : MS_NUMBER  
          | MS_AUTO    
          | MS_AUTO2   
          | MS_FOLLOW  
          | MS_BINDING 
          ;
true_false  : MS_TRUE 
            | MS_FALSE
            ;
color_opt  : rgb                                                { $$ = $1; }
          | MS_BINDING                                          { $$ = createNodeWithTextContent($1); }
          ;
str_attr  : MS_STRING  
          | MS_BINDING 
          ;
number_auto  : MS_NUMBER 
            | MS_AUTO   
            ;
position_opt  : MS_UL  
              | MS_UC  
              | MS_UR  
              | MS_CL  
              | MS_CC  
              | MS_CR  
              | MS_LL  
              | MS_LC  
              | MS_LR  
              | MS_AUTO
              ;
num_str_attr  : MS_NUMBER 
              | MS_STRING 
              | MS_BINDING
              ;
num_attr      : MS_NUMBER 
              | MS_BINDING
              ;
size_opt  : MS_NUMBER 
          | MS_TINY   
          | MS_SMALL  
          | MS_MEDIUM 
          | MS_LARGE  
          | MS_GIANT  
          | MS_BINDING
          ;
expression_opt  : MS_STRING                                    { $$ = $1; }
                | MS_EXPRESSION                                { $$ = $1; }
                | MS_REGEX                                     { $$ = $1; }
                ;
num_str  : MS_NUMBER 
        | MS_STRING 
        ;
        
querymap_style_opt  : MS_SELECTED
                    | MS_HILITE
                    | MS_NORMAL
                    ;
%%

int main(){
  /*
  // open a file handle to a particular file:
  FILE *myfile = fopen("map.map", "r");
  // make sure it's valid:
  if (!myfile) {
    cout << "I can't open map.map!" << endl;
    return -1;
  }
  // set lex to read from it instead of defaulting to STDIN:
  yyin = myfile;
  */
  
  // parse through the input until there is no more:
  yyparse();
  
  //printf("\nSuccessful Parse\n");
}

XmlNode *addAttribute(char const *name, char const *value){
	XmlNode *node = XmlNode_new();
	XmlNode_addAttribute(node,name,value);
	return node;
}

XmlNode *createSimpleNode(const char *name, const char *content){
	XmlNode *child = XmlNode_new();
	XmlNode_setName(child,name);
	XmlNode_setTextContent(child,content);
	return wrapNode(child);
}

XmlNode *nameNode(const char *name, XmlNode *node){
	XmlNode_setName(node,name);
	return node;
}


XmlNode *mergeNodes(XmlNode *node1, XmlNode *node2){
	XmlNode_merge(node1,node2);
	return node1;
}


XmlNode *wrapNode(XmlNode *child){
	XmlNode *node = XmlNode_new();
	XmlNode_addChild(node,child);
	return node;
}

XmlNode *createItemNode(const char *name, const char *value){
	XmlNode *node = XmlNode_new();
	XmlNode_setName(node,"item");
	XmlNode_addAttribute(node,"name",name);
	XmlNode_setTextContent(node,value);
	return wrapNode(node);
}

XmlNode *addColorOptionNode(const char *rgbName, const char *attributeName, XmlNode* node){
  if(node->attributeCount > 0){ // rgb nodes will have three attributes
	XmlNode_setName(node,rgbName);
  } else {
	XmlNode_setName(node,attributeName);
  }
  return wrapNode(node);  
}


XmlNode *addToMapConfig(const char *name, const char *value){
	XmlNode *ret;
	if(configNode == 0){
		configNode = XmlNode_new();
		XmlNode_setName(configNode,"Config");
		ret = wrapNode(configNode);
	} else {
		ret = 0;
	}
	XmlNode *itemNode = XmlNode_new();
	XmlNode_setName(itemNode,"item");
	XmlNode_addAttribute(itemNode,"name",name);
	XmlNode_setTextContent(itemNode,value);
	XmlNode_addChild(configNode,itemNode);
	return ret;
}

char *concatStrings(char *str1, char *str2){
	int newSize = strlen(str1) + strlen(str2) + 1;
	char * newStr = (char*)malloc(newSize);
	strcpy(newStr,str1);
	strcat(newStr,str2);
	free(str1);
	free(str2);
	return newStr;
	
}
char *createExtentString(char *str1, char *str2, char *str3, char *str4){
	char *ret;
	ret = concatStrings(str1,strdup(" "));
	ret = concatStrings(ret,str2);
	ret = concatStrings(ret,strdup(" "));
	ret = concatStrings(ret,str3);
	ret = concatStrings(ret,strdup(" "));
	ret = concatStrings(ret,str4);
	return ret;
}

XmlNode *createSizeNode(char *xstr, char *ystr){
	XmlNode *node = XmlNode_new();
	XmlNode_addAttribute(node,"x",xstr);
	XmlNode_addAttribute(node,"y",ystr);
	free(xstr);
	free(ystr);
	return node;
}

XmlNode *createRGBNode(char *rstr, char *gstr, char *bstr){
	XmlNode *node = XmlNode_new();
	XmlNode_addAttribute(node,"red",rstr);
	XmlNode_addAttribute(node,"green",gstr);
	XmlNode_addAttribute(node,"blue",bstr);
	free(rstr);
	free(gstr);
	free(bstr);
	return node;	
}

XmlNode *createNodeWithTextContent(char *content){
	XmlNode *node = XmlNode_new();
	XmlNode_setTextContent(node,content);
	free(content);
	return node;
}

void yyerror(const char *s) {
  printf("EEK, parse error!  Message: %s\n%d: %s\n", s,line_number+1,yytext);
  exit(0);
}