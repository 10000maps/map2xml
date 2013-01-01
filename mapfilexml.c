
#include "MapFileXml.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

char* getCopy(const char *str);

XmlNode* XmlNode_new(){
	XmlNode *new = (XmlNode*) malloc(sizeof(XmlNode));
	new->name = 0;
	new->textContent = 0;
	new->attributeCount = 0;
	new->childrenCount = 0;
}


void XmlNode_setName(XmlNode *this, const char *name){
	this->name = getCopy(name);
}

void XmlNode_setTextContent(XmlNode *this, const char *textContent){
	this->textContent = strdup(textContent);
}

void XmlNode_print(XmlNode *this){
	XmlNode_print_pad(this,"");
	printf("\n");
}

void XmlNode_print_pad(XmlNode *this, const char *pad){
	char childPad[32];
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
		if(this->textContent != 0)printf("%s",this->textContent);
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
	new->name = getCopy(name);
	new->value = getCopy(value);
	return  new;
}

void XmlNode_addChild(XmlNode *this, XmlNode *child){

	if(this->childrenCount >= XML_NODE_CHILDREN_SIZE-1){
		fprintf(stderr, "Children Limit exceeded!\n");
		exit(1);
	};
	
	this->children[this->childrenCount++] = child;
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

		if(this->childrenCount >= XML_NODE_CHILDREN_SIZE-1){
			fprintf(stderr, "Children Limit exceeded!\n");
			exit(1);
		};
	
		this->children[this->childrenCount++] = target->children[i];
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

