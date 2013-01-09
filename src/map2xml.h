

#define XML_NODE_ATTRIBUTE_SIZE 100
#define XML_NODE_CHILDREN_SIZE 100

typedef struct{
	char *name;
	char *value;
} XmlAttribute;

typedef struct XmlNode{
	char *name;
	char *textContent;
	int attributeCount;
	XmlAttribute *attributes[XML_NODE_ATTRIBUTE_SIZE];
	int childrenCount;
	struct XmlNode *children[XML_NODE_CHILDREN_SIZE];
} XmlNode;

XmlNode* XmlNode_new();
void XmlNode_destory(XmlNode *this);
void XmlNode_setName(XmlNode *this, const char *name);
void XmlNode_setTextContent(XmlNode *this, const char *textContent);
void XmlNode_merge(XmlNode *this, XmlNode *target);
void XmlNode_addChild(XmlNode *this, XmlNode *child);
void XmlNode_print(XmlNode *this);
void XmlNode_print_pad(XmlNode *this, const char *pad);
void XmlNode_addAttribute(XmlNode *this, const char *name, const char *value);

XmlAttribute* XmlAttribute_new(const char *name, const char *value);
void XmlAttribute_destory(XmlAttribute *this);


XmlNode* wrapNode(XmlNode *child);
XmlNode* mergeNodes(XmlNode *node1, XmlNode *node2);
XmlNode* nameNode(const char *name, XmlNode *node);
XmlNode* createSimpleNode(const char *name, char *content);
XmlNode* createAttributeNode(char const *name, char *value);
XmlNode* configNode;
XmlNode* addToMapConfig(char *name, char *value);
char *concatStrings(char *str1, char *str2);
XmlNode *createItemNode(char *name, char *value);
XmlNode *createXYNode(char *xstr, char *ystr);
XmlNode *createRGBNode(char *rstr, char *gstr, char *bstr);
XmlNode *addChildNode(XmlNode *parent, XmlNode *child);
XmlNode *createTypedNode(const char *type, char *value);