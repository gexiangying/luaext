#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "encrypt.h"
#define LOW_CHAR 32
#define HI_CHAR 127
static char* shuffle(char* s,char* d,int num)
{
	srand(num);
	strcpy(d,s);
	int len = strlen(d);
	char* org = d;
	while(*d){
		int i = rand() % len;
		int temp = *d;
		*d = *(org + i);
		*(org +i) = temp;
		d++;
	}
	return org;
}
static int find(const char* s,char* d,int a)
{
	while(*s != a){
		s++,d++;
	}
	return *d;
}
static char* imp(const char* s,char* d,int num,int flag)
{
	char org[255]= {0};
	char dic[255]= {0} ;
	int i ;
	char* rs = d;
	for(i  = 0 ; i < HI_CHAR - LOW_CHAR; ++i){
		org[i] = i + LOW_CHAR;
	}
	org[i] = 0;
	shuffle(org,dic,num);
	while(*s){
		if(flag)
			*d = find(org,dic,*s);	
		else 
			*d = find(dic,org,*s);
		s++,d++;
	}
	*d = 0;
	return rs;
}
char* encrypt(const char* s,char* d)
{
	srand((unsigned)time(NULL));
	int a = LOW_CHAR + rand() % (HI_CHAR -LOW_CHAR);
	int b = LOW_CHAR + rand() % (HI_CHAR - LOW_CHAR);
	d[0] = a; d[1] = b;
	imp(s,d+2,a* 256 + b,1);
	return d;
}
char* decrypt(const char* s,char* d)
{
	imp(s+2,d,s[0]*256 + s[1],0);
	return d;
}
