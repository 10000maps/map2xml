%{

#include <stdio.h>
#include <string.h>

#include "mapfilexml.h"


XmlNode* wrapNode(XmlNode *child);
XmlNode* mergeNodes(XmlNode *node1, XmlNode *node2);
XmlNode* nameNode(const char *name, XmlNode *node);
XmlNode* addChildNode(const char *name, const char *content)
/*

//using namespace std;
#define NODE_BIT 0
#define NODE 1
// stuff from flex that bison needs to know about:
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern char *yytext;
extern int line_number;
 
void yyerror(const char *s);

vector<XmlNode*> nodes;
vector<XmlNodeBit*> nodeBits;

int addAttribute(char const *name, char const *value);
int addChildNode(const char *name, const char *content);
int addChildNode(const char *name, int index);
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
  outputformat_stmt points_block point_stmt point_stmts projection_block proj_list querymap_block 
  querymap_stmts querymap_stmt reference_block reference_stmts reference_stmt scalebar_block 
  scalebar_stmts scalebar_stmt style_block style_stmts style_stmt symbol_block symbol_stmts 
  symbol_stmt validation_block web_block web_stmts web_stmt str_pairs str_pair number_list x_y rgb 
  color_opt expression_opt;

%type <str> debug_opts on_off units_opt symbol_type_opt querymap_style_opt extent_opt num_str
  position_opt true_false size_opt transparency_opt layer_type_opt legend_status_opt status_opt 
  transform_opt connectiontype_opt type_opt linejoin_opt linecap_opt style_angle_opt align_opt 
  angle_opt str_attr number_auto num_str_attr num_attr ;

%%

mapfile : map_block                                           { XmlNode_print($1); }
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
class_stmt : BACKGROUNDCOLOR rgb                             { $$ = 0; }
           | COLOR rgb                                       { $$ = 0; }
           | DEBUG on_off                                    { $$ = 0; }
           | EXPRESSION expression_opt                       { $$ = 0; }
           | GROUP MS_STRING                                 { $$ = 0; }
           | KEYIMAGE MS_STRING                              { $$ = 0; }
           | label_block                                     { $$ = 0; }
           | leader_block                                    { $$ = 0; }
           | MAXSCALEDENOM MS_NUMBER                         { $$ = 0; }
           | MAXSIZE MS_NUMBER                               { $$ = 0; }
           | metadata_block                                  { $$ = 0; }
           | MINSCALEDENOM MS_NUMBER                         { $$ = 0; }
           | MINSIZE MS_NUMBER                               { $$ = 0; }
           | NAME MS_STRING                                  { $$ = 0; }
           | OUTLINECOLOR rgb                                { $$ = 0; }
           | SIZE MS_NUMBER                                  { $$ = 0; }
           | STATUS on_off                                   { $$ = 0; }
           | style_block                                     { $$ = 0; }
           | SYMBOL num_str                                  { $$ = 0; }
           | TEMPLATE MS_STRING                              { $$ = 0; }
           | TEXT expression_opt                             { $$ = 0; }
           | validation_block                                { $$ = 0; }
           ;

cluster_block : CLUSTER cluster_stmts END                     { $$ = wrapNode($2); }
              ;
cluster_stmts : cluster_stmts cluster_stmt                    { $$ =   mergeNodes($1,$2); }
              | cluster_stmt                                  { $$ = nameNode("Cluster",$1); }
              ;
cluster_stmt : MAXDISTANCE MS_NUMBER                         { $$ = 0; }
             | REGION MS_STRING                              { $$ = 0; }
             | BUFFER MS_NUMBER                              { $$ = 0; }
             | GROUP expression_opt                          { $$ = 0; }
             | FILTER expression_opt                         { $$ = 0; }
             ;

feature_block : FEATURE feature_stmts END                     { $$ = wrapNode($2); }
              ;
feature_stmts : feature_stmts feature_stmt                    { $$ =   mergeNodes($1,$2); }
              | feature_stmt                                  { $$ = nameNode("Feature",$1); }
              ;
feature_stmt : points_block                                  { $$ = 0; }
             | ITEMS MS_STRING                               { $$ = 0; }
             | TEXT MS_STRING                                { $$ = 0; }
             | WKT MS_STRING                                 { $$ = 0; }
             ;

grid_block : GRID grid_stmts END                             { $$ = wrapNode($2); }
           ;
grid_stmts : grid_stmts grid_stmt                            { $$ =   mergeNodes($1,$2); }
           | grid_stmt                                       { $$ = nameNode("Grid",$1); }
           ;
grid_stmt : LABELFORMAT MS_STRING                             { $$ = 0; }
          | MINARCS MS_NUMBER                                 { $$ = 0; }
          | MAXARCS MS_NUMBER                                 { $$ = 0; }
          | MININTERVAL MS_NUMBER                             { $$ = 0; }
          | MAXINTERVAL MS_NUMBER                             { $$ = 0; }
          | MINSUBDIVIDE MS_NUMBER                            { $$ = 0; }
          | MAXSUBDIVIDE MS_NUMBER                            { $$ = 0; }
          ;


join_block : JOIN join_stmts END                             { $$ = wrapNode($2); }
           ;
join_stmts : join_stmts join_stmt                            { $$ =   mergeNodes($1,$2); }
           | join_stmt                                       { $$ = nameNode("Join",$1); }
           ;
join_stmt : CONNECTION MS_STRING                              { $$ = 0; }
          | CONNECTIONTYPE MS_STRING                          { $$ = 0; }
          | FOOTER MS_STRING                                  { $$ = 0; }
          | FROM MS_STRING                                    { $$ = 0; }
          | HEADER MS_STRING                                  { $$ = 0; }
          | NAME MS_STRING                                    { $$ = 0; }
          | TABLE MS_STRING                                   { $$ = 0; }
          | TEMPLATE MS_STRING                                { $$ = 0; }
          | TO MS_STRING                                      { $$ = 0; }
          | TYPE  MS_STRING                                   { $$ = 0; }
          ;

label_block : LABEL label_stmts END                           { $$ = wrapNode($2); }
            ;
label_stmts : label_stmts label_stmt                          { $$ =   mergeNodes($1,$2); }
            | label_stmt                                      { $$ = nameNode("Label",$1); }
            ;
label_stmt : ALIGN align_opt                                 { $$ = addChildNode("align",$2); }
           | ANGLE angle_opt                                 { $$ = addChildNode("angle",$2); }
           | ANTIALIAS true_false                            { $$ = addChildNode("antialias",$2); }
           | BUFFER MS_NUMBER                                { $$ = addChildNode("buffer",$2); }
           | COLOR color_opt                                 { $$ = addColorOptionNode("color","colorAttribute",$2); }
           | ENCODING MS_STRING                              { $$ = addChildNode("encoding",$2); }
           | EXPRESSION expression_opt                       { $$ = 0; }
           | FONT str_attr                                   { $$ = addChildNode("font",$2); }
           | FORCE true_false                                { $$ = addChildNode("force",$2); }
           | MAXLENGTH MS_NUMBER                             { $$ = addChildNode("maxLength",$2); }
           | MAXOVERLAPANGLE MS_NUMBER                       { $$ = addChildNode("maxOverlapAngle",$2); }
           | MAXSCALEDENOM MS_NUMBER                         { $$ = addChildNode("maxScaleDenom",$2); }
           | MAXSIZE MS_NUMBER                               { $$ = addChildNode("maxSize",$2); }
           | MINDISTANCE MS_NUMBER                           { $$ = addChildNode("minDistance",$2); }
           | MINFEATURESIZE number_auto                      { $$ = addChildNode("minFeatureSize",$2); }
           | MINSCALEDENOM MS_NUMBER                         { $$ = addChildNode("minScaleDenom",$2); }
           | MINSIZE MS_NUMBER                               { $$ = addChildNode("minSize",$2); }
           | OFFSET x_y                                      { $$ = addChildNode("offset",$2); }
           | OUTLINECOLOR color_opt                          { $$ = addColorOptionNode("outlineColor","outlineColorAttribute",$2); }
           | OUTLINEWIDTH MS_NUMBER                          { $$ = addChildNode("outlineWidth",$2); }
           | PARTIALS true_false                             { $$ = addChildNode("partials",$2); }
           | POSITION position_opt                           { $$ = addChildNode("position",$2); }
           | PRIORITY   num_str_attr                          { $$ = addChildNode("priority",$2); }
           | REPEATDISTANCE MS_NUMBER                        { $$ = addChildNode("repeatDistance",$2); }
           | SHADOWCOLOR rgb                                 { $$ = addChildNode("shadowColor",$2); }
           | SHADOWSIZE x_y                                  { $$ = addChildNode("shadowSize",$2); }
           | SIZE size_opt                                   { $$ = addChildNode("size",$2); }
           | style_block                                     { $$ = $1; }
           | TEXT expression_opt                             { $$ = 0; }
           | TYPE type_opt                                   { $$ = addAttribute("type",$2); }
           | WRAP MS_STRING                                  { $$ = addChildNode("wrap",$2); }
           ;

layer_block : LAYER layer_stmts END                           { $$ = wrapNode($2); }
            ;
            
layer_stmts : layer_stmts layer_stmt                          { $$ =   mergeNodes($1,$2); }
            | layer_stmt                                      { $$ = nameNode("Layer",$1); }
            ;
layer_stmt : class_block                                     { $$ = 0; }
           | CLASSGROUP MS_STRING                            { $$ = 0; }
           | CLASSITEM MS_BINDING                            { $$ = 0; }
           | CLASSITEM MS_STRING                             { $$ = 0; }
           | cluster_block                                   { $$ = 0; }
           | CONNECTION MS_STRING                            { $$ = 0; }
           | CONNECTIONTYPE connectiontype_opt               { $$ = 0; }
           | DATA MS_STRING                                  { $$ = 0; }
           | DEBUG debug_opts                                { $$ = 0; }
           | DUMP true_false                                 { $$ = 0; }
           | EXTENT MS_NUMBER MS_NUMBER MS_NUMBER MS_NUMBER  { $$ = 0; }
           | feature_block                                   { $$ = 0; }
           | FILTER expression_opt                           { $$ = 0; }
           | FILTERITEM MS_BINDING                           { $$ = 0; }
           | FOOTER MS_STRING                                { $$ = 0; }
           | grid_block                                      { $$ = 0; }
           | GROUP MS_STRING                                 { $$ = 0; }
           | HEADER MS_STRING                                { $$ = 0; }
           | join_block                                      { $$ = 0; }
           | LABELANGLEITEM MS_BINDING                       { $$ = 0; }
           | LABELCACHE on_off                               { $$ = 0; }
           | LABELITEM MS_BINDING                            { $$ = 0; }
           | LABELITEM MS_STRING                             { $$ = 0; }
           | LABELMAXSCALEDENOM MS_NUMBER                    { $$ = 0; }
           | LABELMINSCALEDENOM MS_NUMBER                    { $$ = 0; }
           | LABELREQUIRES expression_opt                    { $$ = 0; }
           | LABELSIZEITEM MS_BINDING                        { $$ = 0; }
           | MASK MS_STRING                                  { $$ = 0; }
           | MAXFEATURES MS_NUMBER                           { $$ = 0; }
           | MAXGEOWIDTH MS_NUMBER                           { $$ = 0; }
           | MAXSCALEDENOM MS_NUMBER                         { $$ = 0; }
           | metadata_block                                  { $$ = 0; }
           | MINGEOWIDTH MS_NUMBER                           { $$ = 0; }
           | MINSCALEDENOM MS_NUMBER                         { $$ = 0; }
           | NAME MS_STRING                                  { $$ = 0; }
           | OFFSITE rgb                                     { $$ = 0; }
           | OPACITY num_str                                 { $$ = 0; }
           | MS_PLUGIN MS_NUMBER                             { $$ = 0; }
           | POSTLABELCACHE true_false                       { $$ = 0; }
           | PROCESSING MS_STRING                            { $$ = 0; }
           | projection_block                                { $$ = 0; }
           | REQUIRES expression_opt                         { $$ = 0; }
           | SIZEUNITS units_opt                             { $$ = 0; }
           | STATUS status_opt                               { $$ = 0; }
           | STYLEITEM str_attr                              { $$ = 0; }
           | SYMBOLSCALEDENOM MS_NUMBER                      { $$ = 0; }
           | TEMPLATE MS_STRING                              { $$ = 0; }
           | TILEINDEX MS_STRING                             { $$ = 0; }
           | TILEITEM MS_BINDING                             { $$ = 0; }
           | TOLERANCE MS_NUMBER                             { $$ = 0; }
           | TOLERANCEUNITS units_opt                        { $$ = 0; }
           | TRANSPARENCY transparency_opt                   { $$ = 0; }
           | TRANSFORM transform_opt                         { $$ = 0; }
           | TYPE layer_type_opt                             { $$ = 0; }
           | UNITS units_opt                                 { $$ = 0; }
           | validation_block                                { $$ = 0; }
           ;

leader_block : LEADER leader_stmts END                       { $$ = wrapNode($2); }
             ;
leader_stmts : leader_stmts leader_stmt                      { $$ =   mergeNodes($1,$2); }
             | leader_stmt                                   { $$ = nameNode("Leader",$1); }
             ;
leader_stmt : GRIDSTEP MS_NUMBER                              { $$ = 0; }
            | MAXDISTANCE MS_NUMBER                           { $$ = 0; }
            | style_block                                     { $$ = 0; }
            ;


legend_block : LEGEND legend_stmts END                       { $$ = wrapNode($2); }
             ;
legend_stmts : legend_stmts legend_stmt                      { $$ =   mergeNodes($1,$2); }
             | legend_stmt                                   { $$ = nameNode("Legend",$1); }
             ;
legend_stmt : IMAGECOLOR rgb                                  { $$ = addChildNode("imageColor",$2); }
            | INTERLACE on_off                                { $$ = addChildNode("interlace",$2); }
            | KEYSIZE x_y                                     { $$ = addChildNode("keySize",$2); }
            | KEYSPACING x_y                                  { $$ = addChildNode("keySpacing",$2); }
            | label_block                                     { $$ = $1; }
            | OUTLINECOLOR rgb                                { $$ = addChildNode("outlineColor",$2); }
            | POSITION position_opt                           { $$ = addChildNode("position",$2); }
            | POSTLABELCACHE true_false                       { $$ = addChildNode("postLabelCache",$2); }
            | STATUS legend_status_opt                        { $$ = addAttribute("status",$2); }
            | TEMPLATE MS_STRING                              { $$ = addChildNode("template",$2); }
            | TRANSPARENT on_off                              { $$ = addChildNode("transparent",$2); }
            ;

map_block : MAP map_stmts END                                 { 
                                                                $$ = $2; 
                                                                XmlNode *node = nodes[$2];
                                                                node->addAttribute(new XmlAttribute("xmlns","http://www.mapserver.org/mapserver"));
                                                                node->addAttribute(new XmlAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance"));
                                                                node->addAttribute(new XmlAttribute("xsi:schemaLocation","http://www.mapserver.org/mapserver ../mapfile.xsd"));
                                                                node->addAttribute(new XmlAttribute("version","5.6.0"));
                                                              }
          ;
map_stmts : map_stmts map_stmt                                { $$ =   mergeNodes($1,$2); }
          | map_stmt                                          { $$ = nameNode("Map",$1); }
          ;
map_stmt : ANGLE MS_NUMBER                                    { $$ = addChildNode("angle",$2); }
         | CONFIG MS_STRING MS_STRING                        { 
                                                               XmlNode *cnode;
                                                               if(configNodeIndex < 0){
                                                                 cnode = new XmlNode("Config");
                                                                 configNodeIndex = nodes.size();
                                                                 nodes.push_back(cnode);
                                                               } else {
                                                                 cnode = nodes[configNodeIndex];
                                                               }
                                                               XmlNode *item = new XmlNode("item");
                                                               item->addAttribute(new XmlAttribute("name",$2));
                                                               item->setTextContent($3);
                                                               XmlNodeBit *bit = new XmlNodeBit();
                                                               bit->addChild(item);
                                                               $$ = nodeBits.size();
                                                               nodeBits.push_back(bit);
                                                             }
         | DATAPATTERN MS_REGEX                              { $$ = addChildNode("dataPattern",$2); }
         | DEBUG debug_opts                                  { $$ = addChildNode("debug",$2); }
         | DEFRESOLUTION MS_NUMBER                           { $$ = addChildNode("defResolution",$2); }
         | EXTENT MS_NUMBER MS_NUMBER MS_NUMBER MS_NUMBER    { 
                                                               char tmp[SMALL_STRING_SIZE];
                                                               sprintf(tmp,"%s %s %s %s",$2,$3,$4,$5);
                                                               $$ = addChildNode("extent",tmp); 
                                                             } 
         | FONTSET MS_STRING                                 { $$ = addChildNode("fontSet",$2); }
         | IMAGECOLOR rgb                                    { $$ = addChildNode("imageColor",$2); }
         | IMAGEQUALITY MS_NUMBER                            { $$ = 0; }
         | IMAGETYPE MS_STRING                               { $$ = addChildNode("imageType",$2); }
         | INCLUDE MS_STRING                                 { $$ = addChildNode("include",$2); }
         | INTERLACE on_off                                  { $$ = 0; }
         | layer_block                                       { $$ = $1; }
         | legend_block                                      { $$ = $1; }
         | MAXSIZE MS_NUMBER                                 { $$ = addChildNode("maxSize",$2); }
         | NAME MS_STRING                                    { $$ = addAttribute("name",$2); };
         | outputformat_block                                { $$ = $1; }
         | projection_block                                  { $$ = $1; }
         | querymap_block                                    { $$ = $1; }
         | reference_block                                   { $$ = $1; }
         | RESOLUTION MS_NUMBER                              { $$ = addChildNode("resolution",$2); }
         | SCALEDENOM MS_NUMBER                              { $$ = addChildNode("scaleDenom",$2); }
         | scalebar_block                                    { $$ = $1; }
         | SHAPEPATH MS_STRING                               { $$ = addChildNode("shapePath",$2); }
         | SIZE x_y                                          { $$ = addChildNode("size",$2); }
         | STATUS on_off                                     { $$ = addAttribute("status",$2); }
         | SYMBOLSET MS_STRING                               { $$ = addChildNode("symbolSet",$2); }
         | symbol_block                                      { $$ = $1; }
         | TEMPLATEPATTERN MS_REGEX                          { $$ = addChildNode("templatePattern",$2); }
         | TRANSPARENT on_off                                { $$ = 0; }
         | UNITS units_opt                                   { $$ = addChildNode("units",$2); }
         | web_block                                         { $$ = $1; }
         ;


                  
metadata_block: METADATA str_pairs END                         { $$ = wrapNode(nameNode("Metadata",$2)); };



outputformat_block : OUTPUTFORMAT outputformat_stmts END      { $$ = wrapNode($2); }
                   ;
outputformat_stmts : outputformat_stmts outputformat_stmt     { $$ =   mergeNodes($1,$2); }
                   | outputformat_stmt                        { $$ = nameNode("OutputFormat",$1); }
                   ;
outputformat_stmt : DRIVER MS_STRING                           { $$ = addChildNode("driver",$2); }
                  | EXTENSION MS_STRING                        { $$ = addChildNode("extension",$2); }
                  | FORMATOPTION MS_STRING                     { $$ = addChildNode("formatOption",$2); }
                  | IMAGEMODE MS_STRING                        { $$ = addChildNode("imageMode",$2); }
                  | MIMETYPE MS_STRING                         { $$ = addChildNode("mimeType",$2); }
                  | NAME MS_STRING                             { $$ = addAttribute("name",$2); }
                  | TRANSPARENT on_off                         { $$ = addChildNode("transparent",$2); }
                  ;

points_block  : POINTS point_stmts END                         { $$ = wrapNode($2); }
              ;
point_stmts  : point_stmts point_stmt                           { $$ =   mergeNodes($1,$2); }
            | point_stmt                                       { $$ = nameNode("Points",$1); }
            ;
point_stmt : x_y                                               { $$ = addChildNode("point",$1); }
           ;

projection_block  : PROJECTION proj_list END                   { $$ = addChildNode("projection",tempString); }
                  ;
proj_list  : proj_list MS_STRING                                { strcat(tempString,$2);strcat(tempString,"\n");}
          | MS_STRING                                          { strcpy(tempString,"\n");strcat(tempString,$1);strcat(tempString,"\n");}
          ;


querymap_block  : QUERYMAP querymap_stmts END                  { $$ = wrapNode($2); }
                ;
querymap_stmts  : querymap_stmts querymap_stmt                 { $$ =   mergeNodes($1,$2); }
                | querymap_stmt                                { $$ = nameNode("QueryMap",$1); }
                ;
querymap_stmt  : COLOR rgb                                      { $$ = addChildNode("color",$2); }
              | SIZE x_y                                       { $$ = addChildNode("size",$2); }
              | STATUS on_off                                  { $$ = addAttribute("status",$2); }
              | STYLE querymap_style_opt                       { $$ = addChildNode("style",$2); }
              ;


reference_block  : REFERENCE reference_stmts END                { $$ = wrapNode($2); }
                ;
reference_stmts  : reference_stmts reference_stmt               { $$ =   mergeNodes($1,$2); }
                | reference_stmt                               { $$ = nameNode("Reference",$1); }
                ;
reference_stmt  : COLOR rgb                                    { $$ = addChildNode("color",$2);       }
                | EXTENT extent_opt                            { $$ = addChildNode("extend",$2);      }
                | IMAGE MS_STRING                              { $$ = addChildNode("image",$2);       }
                | MARKER num_str                               { $$ = addChildNode("marker",$2);      }
                | MARKERSIZE MS_NUMBER                         { $$ = addChildNode("markerSize",$2);  }
                | MINBOXSIZE MS_NUMBER                         { $$ = addChildNode("minBoxSize",$2);  }
                | MAXBOXSIZE MS_NUMBER                         { $$ = addChildNode("maxBoxSize",$2);  }
                | OUTLINECOLOR rgb                             { $$ = addChildNode("outlineColor",$2); }
                | SIZE x_y                                     { $$ = addChildNode("size",$2);        }
                | STATUS on_off                                { $$ = addAttribute("status",$2);      }
                ;


scalebar_block  : SCALEBAR scalebar_stmts END                  { $$ = wrapNode($2); }
                ;
scalebar_stmts  : scalebar_stmts scalebar_stmt                 { $$ =   mergeNodes($1,$2); }
                | scalebar_stmt                                { $$ = nameNode("ScaleBar",$1); }
                ;
scalebar_stmt : ALIGN align_opt                                { $$ = addChildNode("align",$2); }
              | BACKGROUNDCOLOR rgb                            { $$ = addChildNode("backgroundColor",$2); }
              | COLOR rgb                                      { $$ = addChildNode("color",$2); }
              | IMAGECOLOR rgb                                 { $$ = addChildNode("imageColor",$2); }
              | INTERLACE true_false                           { $$ = addChildNode("interlace",$2); }
              | INTERVALS MS_NUMBER                            { $$ = addChildNode("intervals",$2); }
              | label_block                                    { $$ = $1; }
              | OUTLINECOLOR rgb                               { $$ = addChildNode("outlineColor",$2); }
              | POSITION position_opt                          { $$ = addChildNode("position",$2); }
              | POSTLABELCACHE true_false                      { $$ = addChildNode("postLabelCache",$2); }
              | SIZE x_y                                       { $$ = addChildNode("size",$2); }
              | STATUS legend_status_opt                       { $$ = addAttribute("status",$2); }
              | STYLE MS_NUMBER                                { $$ = addChildNode("style",$2); }
              | TRANSPARENT on_off                             { $$ = addChildNode("transparent",$2); }
              | TRANSPARENT true_false                         { $$ = addChildNode("transparent",$2); }
              | UNITS units_opt                                { $$ = addChildNode("units",$2); }
              ;

style_block :  STYLE style_stmts END                             { $$ = wrapNode($2); }
            ;
style_stmts  : style_stmts style_stmt                           { $$ =   mergeNodes($1,$2); }
            | style_stmt                                       { $$ = nameNode("Style",$1); }
            ;
style_stmt  : ANGLE style_angle_opt                            { $$ = 0; }
            | ANGLEITEM MS_STRING                              { $$ = 0; }
            | ANTIALIAS true_false                             { $$ = 0; }
            | BACKGROUNDCOLOR rgb                              { $$ = 0; }
            | COLOR color_opt                                  { $$ = 0; }
            | GAP MS_NUMBER                                    { $$ = 0; }
            | GEOMTRANSFORM expression_opt                     { $$ = 0; }
            | INITIALGAP MS_NUMBER                             { $$ = 0; }
            | LINECAP linecap_opt                              { $$ = 0; }
            | LINEJOIN linejoin_opt                            { $$ = 0; }
            | LINEJOINMAXSIZE MS_NUMBER                        { $$ = 0; }
            | MAXSCALEDENOM MS_NUMBER                          { $$ = 0; }
            | MAXSIZE MS_NUMBER                                { $$ = 0; }
            | MAXWIDTH MS_NUMBER                               { $$ = 0; }
            | MINSCALEDENOM MS_NUMBER                          { $$ = 0; }
            | MINSIZE MS_NUMBER                                { $$ = 0; }
            | MINWIDTH MS_NUMBER                               { $$ = 0; }
            | OFFSET x_y                                       { $$ = 0; }
            | OPACITY num_attr                                 { $$ = 0; }
            | OUTLINECOLOR color_opt                           { $$ = 0; }
            | OUTLINEWIDTH num_attr                            { $$ = 0; }
            | PATTERN number_list END                          { $$ = 0; }
            | POLAROFFSET num_attr num_attr                    { $$ = 0; }
            | SIZE num_attr                                    { $$ = 0; }
            | SYMBOL num_str_attr                              { $$ = 0; }
            | WIDTH num_attr                                   { $$ = 0; }
            ;

symbol_block  : SYMBOL symbol_stmts END                        { $$ = wrapNode($2); }
              ;
symbol_stmts  : symbol_stmts symbol_stmt                       { $$ =   mergeNodes($1,$2); }
              | symbol_stmt                                    { $$ = nameNode("Symbol",$1); }
              ;
symbol_stmt  : ANCHORPOINT x_y                                  { $$ = addChildNode("anchorPoint",$2); }
            | ANTIALIAS true_false                             { $$ = addChildNode("antialias",$2); }
            | CHARACTER MS_STRING                              { $$ = addChildNode("character",$2); }
            | FILLED true_false                                { $$ = addChildNode("filled",$2); }
            | FONT MS_STRING                                   { $$ = addChildNode("font",$2); }
            | IMAGE MS_STRING                                  { $$ = addChildNode("image",$2); }
            | NAME MS_STRING                                   { $$ = addAttribute("name",$2); }
            | points_block                                     { $$ = $1; }
            | TRANSPARENT num_str                              { $$ = addChildNode("transparent",$2); }
            | TYPE symbol_type_opt                             { $$ = addAttribute("type",$2); }
            ;

validation_block: VALIDATION str_pairs END                     { $$ = wrapNode(nameNode("Validation",$2)); }
                ;

web_block  : WEB web_stmts END                                  { $$ = wrapNode($2); }
          ;
web_stmts  : web_stmts web_stmt                                 { $$ =   mergeNodes($1,$2); }
          | web_stmt                                           { $$ = nameNode("Web",$1); }
          ;
web_stmt  : BROWSEFORMAT MS_STRING                             { $$ = addChildNode("browseFormat",$2); }
          | EMPTY MS_STRING                                    { $$ = addChildNode("empty",$2); }
          | ERROR MS_STRING                                    { $$ = addChildNode("error",$2); }
          | FOOTER MS_STRING                                   { $$ = addChildNode("footer",$2); }
          | HEADER MS_STRING                                   { $$ = addChildNode("header",$2); }
          | IMAGEPATH MS_STRING                                { $$ = addChildNode("imagePath",$2); }
          | IMAGEURL MS_STRING                                 { $$ = addChildNode("imageUrl",$2); }
          | LEGENDFORMAT MS_STRING                             { $$ = addChildNode("legendFormat",$2); }
          | LOG MS_STRING                                      { $$ = addChildNode("log",$2); }
          | MAXSCALEDENOM MS_NUMBER                            { $$ = addChildNode("maxScaleDenom",$2); }
          | MAXSCALE MS_NUMBER                                 { $$ = 0; }
          | MAXTEMPLATE MS_STRING                              { $$ = addChildNode("maxTemplate",$2); }
          | metadata_block                                     { $$ = $1; }
          | MINSCALEDENOM MS_NUMBER                            { $$ = addChildNode("minScaleDenom",$2); }
          | MINSCALE MS_NUMBER                                 { $$ = 0; }
          | MINTEMPLATE MS_STRING                              { $$ = addChildNode("minTemplate",$2); }
          | QUERYFORMAT MS_STRING                              { $$ = addChildNode("queryFormat",$2); }
          | TEMPLATE MS_STRING                                 { $$ = addChildNode("template",$2); }
          | TEMPPATH MS_STRING                                 { $$ = addChildNode("",$2); }
          | validation_block                                   { $$ = $1; }
          ;



extent_opt : MS_NUMBER MS_NUMBER MS_NUMBER MS_NUMBER           {
                                                                 char tmp[SMALL_STRING_SIZE];
                                                                 sprintf(tmp,"%s %s %s %s",$1,$2,$3,$4);
                                                                 strcpy($$,tmp);
                                                               }
           ;


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


str_pairs  : str_pairs str_pair                                 {
                                                                 nodeBits[$1]->add(nodeBits[$2]); 
                                                                 $$ = $1;
                                                               }
          | str_pair                                           {
                                                                 XmlNodeBit *bit = new XmlNodeBit();
                                                                 $$ = nodeBits.size();
                                                                 nodeBits.push_back(bit);
                                                                 bit->add(nodeBits[$1]);
                                                               }
          ;
str_pair  : MS_STRING MS_STRING                                 { $$ = createItemNode($1,$2); }
          ;
type_opt  : MS_TRUETYPE
          | MS_BITMAP  
          ;

number_list  : number_list MS_NUMBER                            { $$ = 0; }
            | MS_NUMBER                                        { $$ = 0; }
            ;

x_y  : MS_NUMBER MS_NUMBER                         {
                                                    XmlNodeBit *bit = new XmlNodeBit();
                                                    bit->addAttribute(new XmlAttribute("x",$1));
                                                    bit->addAttribute(new XmlAttribute("y",$2));
                                                    $$ = nodeBits.size();
                                                    nodeBits.push_back(bit);
                                                  };

linecap_opt  : MS_CJC_BUTT  
            | MS_CJC_ROUND 
            | MS_CJC_SQUARE
            ;
linejoin_opt  : MS_CJC_ROUND 
              | MS_CJC_MITER 
              | MS_CJC_BEVEL 
              ;

rgb  : MS_NUMBER MS_NUMBER MS_NUMBER    {
                                        XmlNodeBit *bit = new XmlNodeBit();
                                        bit->addAttribute(new XmlAttribute("red",$1));
                                        bit->addAttribute(new XmlAttribute("green",$2));
                                        bit->addAttribute(new XmlAttribute("blue",$3));
                                        $$ = nodeBits.size();
                                        nodeBits.push_back(bit);
                                      }

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
          | MS_BINDING                                         { $$ = addTextContent($1); }
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
expression_opt  : MS_STRING                                    { $$ = 0; }
                | MS_EXPRESSION                                { $$ = 0; }
                | MS_REGEX                                     { $$ = 0; }
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
  nodes.push_back(NULL);
  nodeBits.push_back(NULL);
  yyparse();
  
  //printf("\nSuccessful Parse\n");
}

void yyerror(const char *s) {
  cout << "EEK, parse error!  Message: " << s << endl << (line_number+1) << ": " << yytext << endl;
  // might as well halt now:
  exit(0);
}


XmlNode* addAttribute(char const *name, char const *value){
	XmlNode *node = XmlNode_new();
	XmlNode_addAttribute(node,name,value);
	return node;
}

XmlNode* addChildNode(const char *name, const char *content){
	XmlNode *child = XmlNode_new();
	XmlNode_setName(child,name);
	XmlNode_setTextContent(child,content);
	return wrapNode(child);
}

XmlNode* nameNode(const char *name, XmlNode *node){
	XmlNode_setName(node,name);
	return node;
}


XmlNode* mergeNodes(XmlNode *node1, XmlNode *node2){
	XmlNode_merge(node1,node2);
	return node1;
}


XmlNode* wrapNode(XmlNode *child){
	XmlNode *node = XmlNode_new();
	XmlNode_addChild(node,child);
	return node;
}

XmlNode* createItemNode(const char *name, const char *value){
	XmlNode *node = XmlNode_new();
	XmlNode_setName(node,"item");
	XmlNode_addAttribute(node,"name",name);
	XmlNode_setTextContent(node,value);
	return wrapNode(node);
}

int addColorOptionNode(const char *rgbName, const char *attributeName, int index){
  int r;
  XmlNodeBit *newBit = new XmlNodeBit();
  XmlNodeBit *origBit = nodeBits[index];
  XmlNode *child = new XmlNode(
    origBit->attributes.size() > 0
    ? rgbName
    : attributeName
  );
  child->add(origBit);
  newBit->addChild(child);
  r = nodeBits.size();
  nodeBits.push_back(newBit);
  return r;
}
