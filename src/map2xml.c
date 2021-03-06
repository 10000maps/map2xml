
#include "../src/map2xml.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

char *str_replace(char *orig, const char *rep, const char *with);
char *escape(char *str);
XmlNode* configNode = 0;

XmlNode* XmlNode_new(){
	XmlNode *new = (XmlNode*) malloc(sizeof(XmlNode));
	new->name = 0;
	new->textContent = 0;
	new->attributeCount = 0;
	new->childrenCount = 0;
}


void XmlNode_setName(XmlNode *this, const char *name){
	this->name = strdup(name);
}

void XmlNode_setTextContent(XmlNode *this, const char *textContent){
	this->textContent = strdup(textContent);
}

void XmlNode_print(XmlNode *this){
	XmlNode_print_pad(this,"");
	printf("\n");
}

void XmlNode_print_pad(XmlNode *this, const char *pad){
	char childPad[32], *temp;
	int i;	
	
	strcpy(childPad,"	");
	strcat(childPad,pad);
	
	printf("\n%s<%s",pad,this->name);	
	for(i = 0; i < this->attributeCount; i++){
		printf(" %s=\"%s\"",this->attributes[i]->name,this->attributes[i]->value);
	}
	if(
		this->textContent != 0 ||
		this->childrenCount > 0
	){
		printf(">");
		if(this->textContent != 0){
			temp = escape(this->textContent);
			printf("%s",temp);
			free(temp);
		}
		for(i = 0; i < this->childrenCount; i++){
			XmlNode_print_pad(this->children[i],childPad);
		}
		if(this->childrenCount > 0){
			printf("\n%s</%s>",pad,this->name);
		} else {
			printf("</%s>",this->name);
		}
	} else {
		printf("/>");
	}	
}

void XmlNode_destory(XmlNode *this){
	int i;
	XmlAttribute *atr;
	
	free(this->name);
	free(this->textContent);
	for (i = 0; i < this->attributeCount; i++){
		atr = this->attributes[i];
		free(atr->name);
		free(atr->value);
		free(atr);
	}
	for (i = 0; i < this->childrenCount; i++){
		XmlNode_destory(this->children[i]);
	}
	free(this);	
}

void XmlNode_addAttribute(XmlNode *this, const char *name, const char *value){
	if(this->attributeCount >= XML_NODE_ATTRIBUTE_SIZE-1){
		fprintf(stderr, "Attribute Limit exceeded!\n");
		printf("about to print . . . \n");
		XmlNode_print(this);
		exit(1);
	};
	
	this->attributes[this->attributeCount++] = XmlAttribute_new(name,value);
}

XmlAttribute* XmlAttribute_new(const char *name, const char *value){
	XmlAttribute *new = (XmlAttribute*) malloc(sizeof(XmlAttribute));
	new->name = strdup(name);
	new->value = strdup(value);
	return  new;
}

void XmlNode_addChild(XmlNode *this, XmlNode *child){

	if(child->name == 0){
		fprintf(stderr, "map2xml error: Cannot add a child node that doesn't have a tag name.\n");
		XmlNode_print(child);
		exit(1);
	}

	if(this->childrenCount >= XML_NODE_CHILDREN_SIZE-1){
		fprintf(stderr, "map2xml error: Children Limit exceeded!\n");
		exit(1);
	};
	
	int index = this->childrenCount; // start at end
	
	// move items back until begining or next item is smaller
	while(index > 0 && strcasecmp(child->name,this->children[index-1]->name) < 0){
		this->children[index] = this->children[index-1];
		index--;
	}
	
	// insert new child
	this->children[index] = child;
	
	// increment count
	this->childrenCount++;
}

void XmlNode_merge(XmlNode *this, XmlNode *target){
	if (target == 0) return;
	int i;
	for( i = 0; i < target->attributeCount; i++){
		if(this->attributeCount >= XML_NODE_ATTRIBUTE_SIZE-1){
			fprintf(stderr, "Attribute Limit exceeded! on a merge\n");
			printf("%d\n",this->attributeCount);
			printf("about to print\n");
			XmlNode_print(this);
			exit(1);
		};
	
		this->attributes[this->attributeCount++] = target->attributes[i];
	}
	for( i = 0; i < target->childrenCount; i++){
		XmlNode_addChild(this,target->children[i]);
	}
	
	free(target->name);
	free(target->textContent);
	free(target);
}

char* getCopy(const char *str){
	char *new = (char*) malloc(strlen(str)+1);
	strcpy(new,str);
	return new;
}


char *escape(char *str){
	printf("",str);
	char *temp1, *temp2;
	int i, numChars = 2;
	
	temp1 = str;
	const char *echars[] = {"&",    "<"};
	const char *rchars[] = {"&amp;","&lt;"};
	for (i = 0; i < numChars; i++){
		temp2 = str_replace(temp1,echars[i],rchars[i]);
		if(temp1 != str)free(temp1);
		temp1 = temp2;
	}
	return temp1;
}

/** 
	copied from http://stackoverflow.com/questions/779875/what-is-the-function-to-replace-string-in-c 
	with a few small changes.
**/
// You must free the result if result is non-NULL.
char *str_replace(char *orig, const char *rep, const char *with) {
    char *result; // the return string
    char *ins;    // the next insert point
    char *tmp;    // varies
    int len_rep;  // length of rep
    int len_with; // length of with
    int len_front; // distance between rep and end of last rep
    int count;    // number of replacements

    if (!orig)
        return NULL;
    if (!rep || !(len_rep = strlen(rep)))
        return NULL;
    if (!(ins = strstr(orig, rep))) 
        return strdup(orig);
    if (!with)
        with = "";
    len_with = strlen(with);

    for (count = 0; tmp = strstr(ins, rep); ++count) {
        ins = tmp + len_rep;
    }

    // first time through the loop, all the variable are set correctly
    // from here on,
    //    tmp points to the end of the result string
    //    ins points to the next occurrence of rep in orig
    //    orig points to the remainder of orig after "end of rep"
    tmp = result = malloc(strlen(orig) + (len_with - len_rep) * count + 1);

    if (!result)
        return NULL;

    while (count--) {
        ins = strstr(orig, rep);
        len_front = ins - orig;
        tmp = strncpy(tmp, orig, len_front) + len_front;
        tmp = strcpy(tmp, with) + len_with;
        orig += len_front + len_rep; // move to next "end of rep"
    }
    strcpy(tmp, orig);
    return result;
}

int main(int argc, char** args){
	int i;
	version = 0;

	for(i = 0; i < argc;i++){
		if(strcmp(args[i],"-v") == 0 && argc > i){
			version = strdup(args[i+1]);
			break;
		}
	}
	if( version == 0){
		version = strdup("5.6.0");
	}

	yyparse();

	free(version);

	return 0;
}

XmlNode *createAttributeNode(char const *name, char *value){
	XmlNode *node = XmlNode_new();
	XmlNode_addAttribute(node,name,value);
	free(value);
	return node;
}

XmlNode *createSimpleNode(const char *name, char *content){
	XmlNode *child = XmlNode_new();
	XmlNode_setName(child,name);
	XmlNode_setTextContent(child,content);
	free(content);
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

XmlNode *createItemNode(char *name, char *value){
	XmlNode *node = XmlNode_new();
	XmlNode_setName(node,"item");
	XmlNode_addAttribute(node,"name",name);
	XmlNode_setTextContent(node,value);
	free(name);
	free(value);
	return node;
}

XmlNode *addToMapConfig(char *name, char *value){
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

XmlNode *createXYNode(char *xstr, char *ystr){
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

XmlNode *addChildNode(XmlNode *parent, XmlNode *child){
	XmlNode_addChild(parent,child);
	return parent;
}



XmlNode *createTypedNode(const char *type, char *value){
	XmlNode *node = XmlNode_new();
	XmlNode_addAttribute(node,"type",type);
	XmlNode_setTextContent(node,value);
	free(value);
	return node;
}

char *concatStrings(char *str1, char *str2){
	int len = strlen(str1) + strlen(str2) + 2;
	char *newstr = malloc(len);
	strcpy(newstr,str1);
	strcat(newstr," ");
	strcat(newstr,str2);
	free(str1);
	free(str2);
	return newstr;
}
