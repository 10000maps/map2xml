

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
