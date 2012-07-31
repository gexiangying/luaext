#include <windows.h>
#include "include/lua.h"
#include "include/lauxlib.h"
#include <string.h>
#include <objbase.h>
#define FUN_TOKEN 1
#define STR_TOKEN 2
#define NUMBER_TOKEN 3
#define S_TOKEN 4
#define L_TOKEN 5
#define E_TOKEN 6
#define T_TOKEN 7
#define STAR_TOKEN 8
typedef struct _g_token_
{
	int type; 
	char* str;
}G_TOKEN;
static void free_token(G_TOKEN* token)
{
	free(token->str);
	free(token);
}
static G_TOKEN* e_token(const char** str)
{
	G_TOKEN* token = (G_TOKEN*)calloc(1,sizeof(G_TOKEN));
	token->type  =  E_TOKEN;
	const char* lpstr = *str;
	int index = 0;
	int flag = 0;
	do{
		if(*lpstr == '.'){
			flag++;
			if(flag == 2){
				index++,lpstr++;
				token->str=calloc(index + 1,sizeof(char));
				strncpy(token->str,*str,index);
				break;
			}
		}
		lpstr++,index++;
	}while(*lpstr != 0);
	*str = lpstr;
	return token;

}
static G_TOKEN* number_token(const char** str)
{
	G_TOKEN* token = (G_TOKEN*)calloc(1,sizeof(G_TOKEN));
	token->type  =  NUMBER_TOKEN;
	const char* lpstr = *str;
	int index = 0;
	do{
		if(*lpstr == ',' || *lpstr == ')'){
			break;
		}
		lpstr++,index++;
	}while(*lpstr != 0);
	token->str=calloc(index + 1,sizeof(char));
	strncpy(token->str,*str,index);
	*str = lpstr;
	return token;
}
static G_TOKEN* t_token(const char** str)
{
	G_TOKEN* token = number_token(str);
	token->type = T_TOKEN;
	return token;
}
static G_TOKEN* star_token(const char** str)
{
	G_TOKEN* token = (G_TOKEN*)calloc(1,sizeof(G_TOKEN));
	token->type = STAR_TOKEN;
	token->str = calloc(2,sizeof(char));
	token->str[0] = '*';
	*str += 1;
	return token;
}
static G_TOKEN* s_token(const char** str)
{
	G_TOKEN* token = (G_TOKEN*)calloc(1,sizeof(G_TOKEN));
	token->type = S_TOKEN;
	token->str = calloc(2,sizeof(char));
	token->str[0] = '$';
	*str += 1;
	return token;
}
static G_TOKEN* str_token(const char** str)
{
	G_TOKEN* token = (G_TOKEN*)calloc(1,sizeof(G_TOKEN));
	token->type = STR_TOKEN;
	const char* lpstr = *str;
	int index = 0;
	int flag = 0;
	do{
		if(*lpstr == '\''){
			flag++;
			if(flag == 2){
				index++;
				lpstr++;
				token->str=calloc(index + 1,sizeof(char));
				strncpy(token->str,*str,index);
				break;
			}
		}
		index++;
		lpstr++;
	}while(*lpstr != 0);
	*str = lpstr;
	return token;
}
static G_TOKEN* fun_token(const char** str)
{
	G_TOKEN* token = (G_TOKEN*)calloc(1,sizeof(G_TOKEN));
	token->type = FUN_TOKEN;
	const char* lpstr = *str;
	int flag = 0;
	int index = 0;
	do{
		if(*lpstr == '(') flag++;
		else if(*lpstr == ')' && flag == 1) {
			flag--;
			lpstr++;
			index++;
			token->str=calloc(index + 1,sizeof(char));
			strncpy(token->str,*str,index);
			break;
		}
		else if(*lpstr == ')') flag --;
		lpstr++;
		index++;
	}while(*lpstr != 0);
	*str = lpstr;
	return token;
}
static G_TOKEN* l_token(const char** str)
{
	G_TOKEN* token = fun_token(str);
	token->type = L_TOKEN;
	return token;
}
static void add_token(G_TOKEN* token,lua_State* L,int i)
{
	lua_newtable(L);
	lua_pushinteger(L,token->type);
	lua_setfield(L,-2,"type");
	if(token->str){
		lua_pushstring(L,token->str);
		lua_setfield(L,-2,"str");
	}
	lua_rawseti(L,-2,i);
}
static int str_machine(lua_State* L)
{
	const char* str = lua_tostring(L,-1);
	if(*str == '(') str++;
	int i = 0;
	lua_newtable(L);
	G_TOKEN* token = NULL;
	do{
		while(isspace(*str)) str++;
		if(*str == '(') {
			token = l_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(*str == '\''){
			token = str_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(*str == '$') {
			token = s_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(*str == '.'){
			token = e_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(isalpha(*str)){
			token = fun_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(*str == '-' || isdigit(*str)){
			token = number_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(*str == '#') {
			token = t_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else if(*str == '*') {
			token = star_token(&str);
			i++;
			add_token(token,L,i);
			free_token(token);
		}
		else {
			str++;
		}
		token = NULL;
	}while(*str != 0);
	return 1;
}
static int msg(lua_State *L)
{
	const char* title = luaL_checkstring(L,1);
	const char* content = luaL_checkstring(L,2);
	MessageBox(NULL,content,title,MB_OK);
	return 0;
}
static const char *cConversionTable =
//          1         2         3         4         5         6   
//0123456789012345678901234567890123456789012345678901234567890123
 "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_$";

static BOOL cv_to_64( const unsigned long number, char *code, int len )
{
    unsigned long   act;
    int             iDigit, nDigits;
    char            result[5];

    if (len > 5)
        return FALSE;

    act = number;
    nDigits = len - 1;

    for (iDigit = 0; iDigit < nDigits; iDigit++) {
        result[nDigits - iDigit - 1] = cConversionTable[(int) (act % 64)];
        act /= 64;
    }
    result[len - 1] = '\0';

    if (act != 0)
        return FALSE;

    strcpy (code, result);
    return TRUE;
}
static char * getString64FromGuid( const GUID *pGuid, char * buf, int len )
{
	unsigned long   num[6];
	char            str[6][5];
	int             i, n;

	if (len < 23) {
		return NULL;
	}

	//
	// Creation of six 32 Bit integers from the components of the GUID structure
	//
	num[0] = (unsigned long) (pGuid->Data1 / 16777216);                                                 //    16. byte  (pGuid->Data1 / 16777216) is the same as (pGuid->Data1 >> 24)
	num[1] = (unsigned long) (pGuid->Data1 % 16777216);                                                 // 15-13. bytes (pGuid->Data1 % 16777216) is the same as (pGuid->Data1 & 0xFFFFFF)
	num[2] = (unsigned long) (pGuid->Data2 * 256 + pGuid->Data3 / 256);                                 // 12-10. bytes
	num[3] = (unsigned long) ((pGuid->Data3 % 256) * 65536 + pGuid->Data4[0] * 256 + pGuid->Data4[1]);  // 09-07. bytes
	num[4] = (unsigned long) (pGuid->Data4[2] * 65536 + pGuid->Data4[3] * 256 + pGuid->Data4[4]);       // 06-04. bytes
	num[5] = (unsigned long) (pGuid->Data4[5] * 65536 + pGuid->Data4[6] * 256 + pGuid->Data4[7]);       // 03-01. bytes
	//
	// Conversion of the numbers into a system using a base of 64
	//
	buf[0]='\0';
	n = 3;
	for (i = 0; i < 6; i++) {
		if (!cv_to_64 (num[i], str[i], n)) {
			return NULL;
		}
		strcat (buf, str[i]);
		n = 5;
	}
	return buf;
}
static int lua_guid(lua_State* L)
{
	GUID id;
	if(CoCreateGuid(&id) != S_OK){
		lua_pushnil(L);
		return 1;
	}
	char buf[24] = {0};
	getString64FromGuid(&id,buf,strlen(buf)); 
	lua_pushstring(L,buf);
	return 1;
}
static const struct luaL_Reg luaext [] = {
	{"msg",msg},
	{"str_machine",str_machine},
	{"guid",lua_guid},
	{NULL,NULL}
};
int luaopen_luaext(lua_State *L){
	luaL_register(L,"luaext",luaext);
	return 1;
};

