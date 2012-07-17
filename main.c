#include <windows.h>
#include "include/lua.h"
#include "include/lauxlib.h"
#include <string.h>
#define FUN_TOKEN 1
#define STR_TOKEN 2
#define NUMBER_TOKEN 3
#define S_TOKEN 4
#define L_TOKEN 5
#define E_TOKEN 6
#define T_TOKEN 7
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
				*str = lpstr;
				break;
			}
		}
		lpstr++,index++;
	}while(*lpstr != 0);
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
			token->str=calloc(index + 1,sizeof(char));
			strncpy(token->str,*str,index);
			*str = lpstr;
			break;
		}
		lpstr++,index++;
	}while(*lpstr != 0);
	return token;
}
static G_TOKEN* t_token(const char** str)
{
	G_TOKEN* token = number_token(str);
	token->type = T_TOKEN;
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
				*str = lpstr;
			}
		}
		index++;
		lpstr++;
	}while(*lpstr != 0);
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
			*str = lpstr;
			break;
		}
		lpstr++;
		index++;
	}while(*lpstr != 0);
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
	lua_pushstring(L,token->str);
	lua_setfield(L,-2,"str");
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

static const struct luaL_Reg luaext [] = {
	{"msg",msg},
	{"str_machine",str_machine},
	{NULL,NULL}
};
int luaopen_luaext(lua_State *L){
	luaL_register(L,"luaext",luaext);
	return 1;
};

